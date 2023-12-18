#!/bin/bash

# Compile a list of all files in the jobs and lib folders
echo "Compiling list of files..."
find jobs lib -type f > filelist.txt

# Add the changes to staging
echo "Adding changes to Git..."
git add .

# Check for changes; if none, exit
if ! git diff --staged --exit-code; then
    echo "No changes to commit."
    exit 0
fi

# Commit the changes
echo "Committing changes..."
git commit -m "Update files"

# Push the changes to the remote repository
echo "Pushing changes to remote..."
git push

echo "Done!"
