#!/bin/bash

# throw an error if the .env file is not found
if [ ! -f ./.env ]; then
    echo "Please create a .env file in the root of the project and set the `package_namespace`, `skeleton_path` and `package_src_path`"
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

# throw an error if the package_src_path is not set
if [ -z "$package_src_path" ]; then
    echo "Please set the package_src_path in the .env file"
    exit 1
fi

# throw an error if the package_src_path does not exist
if [ ! -d "$package_src_path" ]; then
    echo "The package_src_path does not exist"
    exit 1
fi

git -C $skeleton_path reset --hard
git -C $skeleton_path clean -fd

php $skeleton_path/artisan "${@}"

git -C $skeleton_path/ add .

for file in $(git -C $skeleton_path --no-pager diff --name-only --cached)
do
    filepath=$(dirname "$file")
    filepath=$(sed "s/app/$package_src_path/g" <<< "$filepath")

    sed -i "s/namespace App/namespace $package_namespace/g" "$skeleton_path/$file"
    sed -i "s/namespace Database/namespace $package_namespace\\\Database/g" "$skeleton_path/$file"
    sed -i "s/namespace Tests/namespace $package_namespace\\\Tests/g" "$skeleton_path/$file"
    sed -i "s/use Tests/use $package_namespace\\\Tests/g" "$skeleton_path/$file"
    echo "File: $skeleton_path/$file"
    echo "Path: $filepath"
    mkdir -p $filepath
    cp "$skeleton_path/$file" $filepath
done
