#!/bin/bash
# Compiles and tests on an iOS simulator. Needs macOS with Xcode 26 or later.
# Usage: ./scripts/build_and_test.sh [package|example]   (default: both)
#   package   run the ExperienceKit package tests
#   example   build the Example app
# Set DESTINATION to pick the simulator, e.g. "platform=iOS Simulator,name=iPhone 17".

set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v xcodebuild > /dev/null; then
  echo "xcodebuild not found: this script needs macOS with Xcode." >&2
  echo "Without Xcode, run ./scripts/check.sh, push, and read the CI result on the pull request." >&2
  exit 2
fi

TARGET="${1:-all}"

if [ -z "${DESTINATION:-}" ]; then
  UDID="$(xcrun simctl list devices available | sed -n -E 's/^ +iPhone[^(]*\(([0-9A-F-]{36})\).*$/\1/p' | tail -n 1)"
  if [ -z "$UDID" ]; then
    echo "No available iPhone simulator found. Install one in Xcode, or set DESTINATION." >&2
    exit 2
  fi
  DESTINATION="platform=iOS Simulator,id=$UDID"
fi

run_xcodebuild() {
  if command -v xcbeautify > /dev/null; then
    xcodebuild "$@" 2>&1 | xcbeautify ${GITHUB_ACTIONS:+--renderer github-actions}
  else
    xcodebuild -quiet "$@"
  fi
}

if [ "$TARGET" = "all" ] || [ "$TARGET" = "package" ]; then
  echo "== ExperienceKit package tests ($DESTINATION)"
  run_xcodebuild test -scheme ExperienceKit -destination "$DESTINATION"
fi

if [ "$TARGET" = "all" ] || [ "$TARGET" = "example" ]; then
  echo "== Example app build"
  run_xcodebuild build -project Example/Example.xcodeproj -scheme Example \
    -destination "generic/platform=iOS Simulator" CODE_SIGNING_ALLOWED=NO
fi
