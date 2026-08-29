#!/bin/bash
# Usage: ./generate_component.sh

# Ask user for component name
read -p "Enter component name: " RAW_NAME

if [ -z "$RAW_NAME" ]; then
  echo "❌ Component name cannot be empty."
  exit 1
fi

# Capitalize first letter (e.g. test → Test)
COMPONENT_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${RAW_NAME:0:1})${RAW_NAME:1}"

# Paths
CONFIG_FILE="generateComponentSourcery.yaml"
CONFIGCORE_FILE="ammendCoreComponents.yaml"
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

# 🔍 Clean files
for FILE in \
  "$TARGET_FOLDER/${COMPONENT_NAME}ComponentRegister.swift" \
  "$TARGET_FOLDER/${COMPONENT_NAME}Properties.swift" \
  "$TARGET_FOLDER/${COMPONENT_NAME}View.swift" \
  "$TARGET_FOLDER/${COMPONENT_NAME}ViewModel.swift"
do
  tail -n +3 "$FILE" > tmp.swift && mv tmp.swift "$FILE"
done

# 🛠 Run Sourcery for amending current files
sourcery --config "$CONFIGCORE_FILE"

mv "$TEMPLATE_OUTPUT/AllRegisters.generated.swift" "./Sources/ExperienceKit/Components/Core/AllRegisters.swift"
mv "$TEMPLATE_OUTPUT/ComponentExtensionBuilder.generated.swift" "./Sources/ExperienceKit/Components/Core/ComponentExtensionBuilder.swift"

tail -n +3 "./Sources/ExperienceKit/Components/Core/AllRegisters.swift" > tmp.swift && mv tmp.swift "./Sources/ExperienceKit/Components/Core/AllRegisters.swift"
tail -n +3 "./Sources/ExperienceKit/Components/Core/ComponentExtensionBuilder.swift" > tmp.swift && mv tmp.swift "./Sources/ExperienceKit/Components/Core/ComponentExtensionBuilder.swift"
