#!/bin/bash

show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -e, --echo      Echo the current version"
    echo "  -r, --replace   Run sed to replace version in pom.xml"
    echo "  -h, --help      Show this help message"
}

current_version=$(awk -F'[<>]' '/<artifactId>my-app<\/artifactId>/{getline; getline; print $3}' pom.xml)

IFS='.-' read -ra version_parts <<< "$current_version"
major_version="${version_parts[0]}"
minor_version="${version_parts[1]}"
patch_version="${version_parts[2]}"

patch_version=$((patch_version + 1))

new_version="$major_version.$minor_version.$patch_version-SNAPSHOT"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -e|--echo)
            echo "$current_version"
            shift
            ;;
        -r|--replace)
            sed -i "s/<version>$current_version<\/version>/<version>$new_version<\/version>/" pom.xml
            echo "Version replaced in pom.xml"
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Invalid option: $1"
            show_help
            exit 1
            ;;
    esac
done
