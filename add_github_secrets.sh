#!/bin/bash
# add_github_secrets.sh

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "gh CLI is not installed. Please install it first."
    exit 1
fi

# Check for .env file
if [ ! -f ".env" ]; then
    echo "No .env file found."
    exit 1
fi

# Read .env file and add secrets
while read -r line || [ -n "$line" ]; do
    if [[ ! "$line" =~ ^\# && "$line" =~ ^[[:alnum:]_]+=[[:alnum:]_]+ ]]; then
        key=$(echo "$line" | cut -d '=' -f 1)
        value=$(echo "$line" | cut -d '=' -f 2-)
        echo "Adding secret $key"
        gh secret set "$key" --body="$value"
    fi
done < ".env"

echo "All secrets have been added."

