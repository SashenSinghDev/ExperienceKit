#!/bin/bash

RAW_NAME=$1

if [ -z "$RAW_NAME" ]; then
  echo "❌ Usage: ./generate_component.sh <component-name>"
  exit 1
fi

# Capitalize first letter (e.g. test → Test)
COMPONENT_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${RAW_NAME:0:1})${RAW_NAME:1}"

# Paths
CONFIG_FILE="generateComponentSourcery.yaml"
TEMPLATE_OUTPUT=".build/generated-temp"
TARGET_FOLDER="./Sources/ExperienceKit/Components/$COMPONENT_NAME"

# 🔧 Update the sourcery.yaml to reflect the new component name
sed -i '' -E "s/^( *component: ).*/\1$COMPONENT_NAME/" "$CONFIG_FILE"

# 🛠 Run Sourcery with argument (optional override, still passing via CLI too)
sourcery --config "$CONFIG_FILE" --args component=$COMPONENT_NAME

# Create folder if not exists
mkdir -p "$TARGET_FOLDER"

# Debug: List generated files
echo "🔍 Generated files:"
ls "$TEMPLATE_OUTPUT"

# Move and rename generated files
mv "$TEMPLATE_OUTPUT/ComponentRegister.generated.swift" "$TARGET_FOLDER/${COMPONENT_NAME}ComponentRegister.swift"
mv "$TEMPLATE_OUTPUT/Properties.generated.swift" "$TARGET_FOLDER/${COMPONENT_NAME}Properties.swift"
mv "$TEMPLATE_OUTPUT/View.generated.swift" "$TARGET_FOLDER/${COMPONENT_NAME}View.swift"
mv "$TEMPLATE_OUTPUT/ViewModel.generated.swift" "$TARGET_FOLDER/${COMPONENT_NAME}ViewModel.swift"

echo "✅ Generated $COMPONENT_NAME component in: $TARGET_FOLDER"

# 🔄 Revert changes to sourcery.yaml
git checkout -- generateComponentSourcery.yaml
echo "🔁 Reverted changes to sourcery.yaml"
