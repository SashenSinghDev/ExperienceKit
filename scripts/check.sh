#!/bin/bash
# Static checks that need no Swift toolchain. Runs on macOS and Linux.
# Usage: ./scripts/check.sh
# CI runs this on every pull request; scripts/build_and_test.sh covers compiling.

set -u
export LC_ALL=C
cd "$(dirname "$0")/.."

COMPONENTS_DIR="Sources/ExperienceKit/Components"
ALL_REGISTERS="$COMPONENTS_DIR/Core/AllRegisters.swift"
BUILDER="$COMPONENTS_DIR/Core/ComponentExtensionBuilder.swift"
EXAMPLE_DIR="Example/Example"
PBXPROJ="Example/Example.xcodeproj/project.pbxproj"
RAW_COLOUR_BASELINE="scripts/raw-colour-baseline.txt"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

failures=0

fail() {
  failures=$((failures + 1))
  echo "FAIL [$1] $2"
}

# --- scaffold: every component folder holds the four generated files ---------
for dir in "$COMPONENTS_DIR"/*/; do
  name="$(basename "$dir")"
  case "$name" in Core|Shared) continue ;; esac
  for suffix in ComponentRegister Properties ViewModel; do
    [ -f "$dir$name$suffix.swift" ] || fail scaffold "$dir is missing $name$suffix.swift"
  done
  if [ ! -f "$dir${name}View.swift" ] && [ ! -f "$dir${name}ComponentView.swift" ]; then
    fail scaffold "$dir is missing ${name}View.swift"
  fi
done

# --- registry: AllRegisters.swift and ComponentExtensionBuilder.swift match
#     what Templates/Core generates from the // sourcery: annotations ---------
grep -rh -A1 --include='*.swift' '^// sourcery: register' "$COMPONENTS_DIR" \
  | sed -n -E 's/^.*class ([A-Za-z0-9_]+).*$/\1/p' | sort > "$TMP/registers.expected"
sed -n -E 's/^ *([A-Za-z0-9_]+)\(\),$/\1/p' "$ALL_REGISTERS" > "$TMP/registers.actual"
if ! diff "$TMP/registers.expected" "$TMP/registers.actual" > "$TMP/registers.diff"; then
  fail registry "$ALL_REGISTERS disagrees with the '// sourcery: register' classes (< expected, > actual):"
  cat "$TMP/registers.diff"
fi

# "<content type> <properties type>" pairs, sorted by properties type.
: > "$TMP/components.unsorted"
grep -rl --include='*.swift' '^// sourcery: component = ' "$COMPONENTS_DIR" | while read -r file; do
  awk '
    /^\/\/ sourcery: component = "/ {
      split($0, parts, "\""); type = parts[2]
      if ((getline next_line) > 0) {
        count = split(next_line, words, /[ :<{]+/)
        for (i = 1; i < count; i++) {
          if (words[i] == "struct" || words[i] == "extension") { print type, words[i + 1]; break }
        }
      }
    }' "$file" >> "$TMP/components.unsorted"
done
sort -k2 "$TMP/components.unsorted" > "$TMP/components.expected"

sed -n -E 's/^ *static func ([A-Za-z0-9_]+)Component\(properties: ([A-Za-z0-9_]+)\) -> Component \{$/\1 \2/p' "$BUILDER" \
  > "$TMP/components.actual"
if ! diff "$TMP/components.expected" "$TMP/components.actual" > "$TMP/components.diff"; then
  fail registry "$BUILDER disagrees with the '// sourcery: component' types (< expected, > actual):"
  cat "$TMP/components.diff"
fi

sed -n -E 's/^ *return Component\(contentType: "([^"]*)",$/\1/p' "$BUILDER" > "$TMP/builder.types"
cut -d' ' -f1 "$TMP/components.actual" > "$TMP/builder.names"
if ! diff "$TMP/builder.names" "$TMP/builder.types" > "$TMP/builder.diff"; then
  fail registry "$BUILDER builds a content type that differs from its function name (< name, > content type):"
  cat "$TMP/builder.diff"
fi

# --- content type: each register answers to the type its builder creates -----
while read -r type properties; do
  name="${properties%Properties}"
  register="$COMPONENTS_DIR/$name/${name}ComponentRegister.swift"
  [ -f "$register" ] || continue
  registered="$(grep -A2 'var contentType: String' "$register" | sed -n -E 's/^ *"([^"]*)" *$/\1/p' | head -n 1)"
  if [ "$registered" != "$type" ]; then
    fail content-type "$register returns \"$registered\" but $properties is annotated \"$type\", so .${type}Component(properties:) renders nothing"
  fi
done < "$TMP/components.expected"

# --- example target: every Swift file under Example/Example is compiled ------
find "$EXAMPLE_DIR" -name '*.swift' | sort | while read -r file; do
  base="$(basename "$file")"
  grep -q "/\* $base in Sources \*/" "$PBXPROJ" || echo "$file"
done > "$TMP/pbx.missing"
if [ -s "$TMP/pbx.missing" ]; then
  fail example-target "Swift files missing from the Example target in $PBXPROJ (need PBXBuildFile, PBXFileReference, group and Sources entries):"
  cat "$TMP/pbx.missing"
fi

sed -n -E 's/^.*isa = PBXFileReference; lastKnownFileType = sourcecode\.swift; path = "?([^";]+)"?;.*$/\1/p' "$PBXPROJ" \
  | sort -u | while read -r base; do
  [ -n "$(find "$EXAMPLE_DIR" -name "$base" -print -quit)" ] || echo "$base"
done > "$TMP/pbx.dangling"
if [ -s "$TMP/pbx.dangling" ]; then
  fail example-target "$PBXPROJ references Swift files that do not exist under $EXAMPLE_DIR:"
  cat "$TMP/pbx.dangling"
fi

# --- raw colour: ExperienceKit styles with design-system tokens --------------
# See docs/architecture/DESIGNSYSTEM.md. Files in the baseline predate the rule.
RAW_COLOUR='UIColor|NSColor|Color\((\.|uiColor:|nsColor:|red:|white:|hue:|\.sRGB)|Color\.(white|black|gray|red|green|blue|orange|yellow|pink|purple|brown|cyan|indigo|mint|teal)([^A-Za-z0-9_]|$)|\.(foregroundStyle|foregroundColor|fill|background|tint|stroke|strokeBorder|border)\(\.(white|black|gray|red|green|blue|orange|yellow|pink|purple|brown|cyan|indigo|mint|teal)[),.]'
grep -v -E '^(#|$)' "$RAW_COLOUR_BASELINE" | sort > "$TMP/colour.baseline"
grep -rlE --include='*.swift' "$RAW_COLOUR" Sources/ExperienceKit | sort > "$TMP/colour.files"

comm -23 "$TMP/colour.files" "$TMP/colour.baseline" > "$TMP/colour.new"
if [ -s "$TMP/colour.new" ]; then
  fail raw-colour "Raw or UIKit colours in ExperienceKit; use a Color+Extension.swift token (add it from Figma if missing):"
  while read -r file; do grep -nE "$RAW_COLOUR" "$file" | sed "s|^|$file:|"; done < "$TMP/colour.new"
fi

comm -13 "$TMP/colour.files" "$TMP/colour.baseline" > "$TMP/colour.stale"
if [ -s "$TMP/colour.stale" ]; then
  fail raw-colour "These files no longer use raw colours; delete them from $RAW_COLOUR_BASELINE:"
  cat "$TMP/colour.stale"
fi

# -----------------------------------------------------------------------------
if [ "$failures" -gt 0 ]; then
  echo
  echo "$failures check(s) failed."
  exit 1
fi
echo "All static checks passed."
