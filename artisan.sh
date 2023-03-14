#!/bin/bash

# throw an error if the .env file is not found

if [ ! -f ./.env ]; then
    echo "Please create a .env file in the root of the project and set the \$package_namespace and \$skeleton_path"
    exit 1
fi

set -o allexport
source ./.env
set +o allexport

# throw an error if the package namespace is not set
if [ -z "$package_namespace" ]; then
    echo "Please set the package namespace in the .env file"
    exit 1
fi

# throw an error if the skeleton path is not set
if [ -z "$skeleton_path" ]; then
    echo "Please set the skeleton path in the .env file"
    exit 1
fi

# thorw an error if the skeleton path does not exist

if [ ! -d "$skeleton_path" ]; then
    echo "The skeleton path does not exist"
    exit 1
fi

# throw an error if the skeleton path is not a git repository

if [ ! -d "$skeleton_path/.git" ]; then
    echo "The skeleton path is not a git repository"
    exit 1
fi

# throw an error if the src_path is not set
if [ -z "$src_path" ]; then
    echo "Please set the src_path in the .env file"
    exit 1
fi

# throw an error if the src_path does not exist

if [ ! -d "$src_path" ]; then
    echo "The src_path does not exist"
    exit 1
fi

git -C $skeleton_path reset --hard

git -C $skeleton_path clean -fd

php $skeleton_path/artisan "${@}"

git -C $skeleton_path/ add .

for file in $(git -C $skeleton_path --no-pager diff --name-only --cached)
do
    filepath=$(dirname "$file")
    filepath=$(sed "s/app/$src_path/g" <<< "$filepath")

    sed -i "s/namespace App/namespace $package_namespace/g" "$skeleton_path/$file"
    echo "File: $skeleton_path/$file"
    echo "Path: $filepath"
    echo "Namespace: $package_namespace"
    mkdir -p "$PWD/$filepath"
    cp "$skeleton_path/$file" "$PWD/$filepath"
done
