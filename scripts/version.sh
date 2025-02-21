#!/bin/bash
# scripts/version.sh

# 1) Validate the semantic version (x.y.z)
validate_version() {
    local version=$1
    if ! [[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Version must be in semantic format (x.y.z)"
        exit 1
    fi
}

# 2) Read current version from pubspec.yaml
get_current_version() {
    grep "^version:" pubspec.yaml | sed 's/version: //' | sed 's/+.*//'
}

# 3) Read current build number
get_current_build() {
    grep "^version:" pubspec.yaml | sed 's/.*+//'
}

# 4) Apply new version + build number
apply_version() {
    local new_version="$1"
    local build_number="$2"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed needs an empty string after -i
        sed -i '' "s/^version: .*$/version: $new_version+$build_number/" pubspec.yaml
    else
        sed -i "s/^version: .*$/version: $new_version+$build_number/" pubspec.yaml
    fi
}

# MAIN SCRIPT
current_version=$(get_current_version)
current_build=$(get_current_build)
echo "Current version: $current_version (Build: $current_build)"

# Let user override version (x.y.z)
read -p "Enter new version (press enter to keep $current_version): " new_version
new_version="${new_version:-$current_version}"

# If user entered a new version, validate
if [[ "$new_version" != "$current_version" ]]; then
    validate_version "$new_version"
fi

# Build number: YYMMDD + 2-digit suffix
base_date=$(date +%y%m%d)  # e.g. '230224' for 2023-02-24
default_suffix="00"
default_build="${base_date}${default_suffix}"  # e.g. '23022400'

if [[ "$current_build" == "$base_date"* ]]; then
    # Attempt to parse the existing 2-digit suffix
    existing_suffix="${current_build#$base_date}"  # strip out the leading base_date
    if [[ "$existing_suffix" =~ ^[0-9]{2}$ ]]; then
        # convert that 2-digit suffix to integer
        suffix_num=$((10#${existing_suffix}))
        next_suffix_num=$((suffix_num + 1))
        # enforce 2-digit format
        next_suffix=$(printf "%02d" $next_suffix_num)
    else
        # if there's some weird format, just reset to "01"
        next_suffix="01"
    fi
    
    read -p "Same day detected. Increment build number to $next_suffix? (y/N): " should_increment
    if [[ "$should_increment" =~ ^[Yy]$ ]]; then
        new_build="${base_date}${next_suffix}"
        apply_version "$new_version" "$new_build"
        echo "Updated to version: $new_version+$new_build"
    else
        apply_version "$new_version" "$default_build"
        echo "Updated to version: $new_version+$default_build"
    fi
else
    # Not same day or version changed => just set to "YYMMDD00"
    apply_version "$new_version" "$default_build"
    echo "Updated to version: $new_version+$default_build"
fi