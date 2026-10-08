#!/bin/bash
# Usage:
#   ./generate_component.sh <Name>   scaffold a component, then refresh the core registries
#   ./generate_component.sh          same, prompting for the name
#   ./generate_component.sh --core   refresh the core registries only
#
# Needs Sourcery (macOS: brew install sourcery).

set -e
cd "$(dirname "$0")"

# Paths
CONFIG_FILE="generateComponentSourcery.yaml"
CONFIGCORE_FILE="ammendCoreComponents.yaml"
TEMPLATE_OUTPUT=".build/generated-temp"
CORE_FOLDER="./Sources/ExperienceKit/Components/Core"

if ! command -v sourcery > /dev/null; then
  echo "❌ Sourcery is not installed. On macOS: brew install sourcery."
  echo "   Without it, follow the fallback in docs/architecture/COMPONENTCREATION.md section 1."
  exit 1
fi

# Sourcery prefixes every file with a two-line "Generated using Sourcery" header.
strip_header() {
  tail -n +3 "$1" > tmp.swift && mv tmp.swift "$1"
}

generate_component() {
  COMPONENT_NAME="$1"
  TARGET_FOLDER="./Sources/ExperienceKit/Components/$COMPONENT_NAME"

  # 🔧 Update the sourcery.yaml to reflect the new component name
  sed -i '' -E "s/^( *component: ).*/\1$COMPONENT_NAME/" "$CONFIG_FILE"

  # 🛠 Run Sourcery with argument (optional override, still passing via CLI too)
  STATUS=0
  sourcery --config "$CONFIG_FILE" --args component=$COMPONENT_NAME || STATUS=$?

  # 🔄 Revert changes to sourcery.yaml, also when Sourcery failed
  git checkout -- "$CONFIG_FILE"
  echo "🔁 Reverted changes to sourcery.yaml"
  [ "$STATUS" -eq 0 ] || exit "$STATUS"

  # Create folder if not exists
  mkdir -p "$TARGET_FOLDER"

  # Debug: List generated files
  echo "🔍 Generated files:"
  ls "$TEMPLATE_OUTPUT"

  # Move, rename and clean generated files
  for KIND in ComponentRegister Properties View ViewModel; do
    mv "$TEMPLATE_OUTPUT/$KIND.generated.swift" "$TARGET_FOLDER/${COMPONENT_NAME}$KIND.swift"
    strip_header "$TARGET_FOLDER/${COMPONENT_NAME}$KIND.swift"
  done

  echo "✅ Generated $COMPONENT_NAME component in: $TARGET_FOLDER"
}

generate_core() {
  # 🛠 Run Sourcery for amending current files
  sourcery --config "$CONFIGCORE_FILE"

  for FILE in AllRegisters ComponentExtensionBuilder; do
    mv "$TEMPLATE_OUTPUT/$FILE.generated.swift" "$CORE_FOLDER/$FILE.swift"
    strip_header "$CORE_FOLDER/$FILE.swift"
  done

  echo "✅ Refreshed AllRegisters.swift and ComponentExtensionBuilder.swift"
}

if [ "${1:-}" = "--core" ]; then
  generate_core
  exit 0
fi

RAW_NAME="${1:-}"
if [ -z "$RAW_NAME" ]; then
  read -p "Enter component name: " RAW_NAME
fi

if [ -z "$RAW_NAME" ]; then
  echo "❌ Component name cannot be empty."
  exit 1
fi

# Capitalize first letter (e.g. test → Test)
COMPONENT_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${RAW_NAME:0:1})${RAW_NAME:1}"

generate_component "$COMPONENT_NAME"
generate_core
