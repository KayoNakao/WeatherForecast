#!/bin/bash

# Get the current directory where the script is located
script_dir=$(dirname "$0")

# Ask user for the new name
echo "Enter the new name (e.g., NEWNAME):"
read new_name

# Define the old and new paths for the folder and the xcodeproj file
old_name="CoordinatorTemplate"
old_project_path="${script_dir}/${old_name}.xcodeproj"
new_project_path="${script_dir}/${new_name}.xcodeproj"
new_folder_path="${script_dir}/${new_name}"

# Define the plist path based on the new folder name
plist_path="${new_folder_path}/Info.plist"

# Check if the old folder and project file exist
if [[ ! -d "$old_project_path" ]]; then
  echo "Error: Project file not found at $old_project_path"
  exit 1
fi

# Rename the folder and project file
echo "Renaming folder '$old_name' to '$new_name'..."
mv "$script_dir/$old_name" "$new_folder_path"

echo "Renaming project file '$old_name.xcodeproj' to '$new_name.xcodeproj'..."
mv "$old_project_path" "$new_project_path"

# Now we need to update the `Info.plist` file and other configurations

# Update the bundle identifier in Info.plist
echo "Updating bundle identifier in Info.plist at '$plist_path'..."
sed -i '' "s|<key>CFBundleIdentifier</key>\s*<string>.*</string>|<key>CFBundleIdentifier</key>\n\t<string>com.example.$new_name</string>|" "$plist_path"

# Update the target and product name in the Xcode project
ruby -e "
require 'xcodeproj'

# Open the project file
project = Xcodeproj::Project.open('$new_project_path')

# Rename target
target = project.targets.find { |t| t.name == '$old_name' }
if target
  target.name = '$new_name'
  puts 'Renamed target to $new_name'
else
  puts 'Target not found'
end

# Update the product bundle identifier
target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.example.$new_name'
  puts 'Updated bundle identifier to com.example.$new_name'
end

# Save the project
project.save
puts 'Project updated successfully.'
"

# Update the Info.plist file path in Build Settings
echo "Updating Info.plist path in Build Settings..."
ruby -e "
require 'xcodeproj'

project = Xcodeproj::Project.open('$new_project_path')
target = project.targets.find { |t| t.name == '$new_name' }

if target
  target.build_configurations.each do |config|
    # Update the Info.plist file path in the build settings
    config.build_settings['INFOPLIST_FILE'] = '$new_name/Info.plist'
    puts 'Updated Info.plist path to $new_name/Info.plist'
  end
  project.save
else
  puts 'Target not found in project'
end
"

# If you have any schemes, update their names as well
old_scheme="${old_name}"
new_scheme="${new_name}"

find "$new_project_path" -name "*.xcscheme" -exec sed -i '' "s/$old_scheme/$new_scheme/g" {} \;

# Final message
echo "All changes applied successfully."

