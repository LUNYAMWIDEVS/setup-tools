#!/bin/bash

cd /tmp
rm -rf projectRepos
git clone git@github.com:LUNYAMWIDEVS/projectRepos.git || exit 1


input_file="/tmp/projectRepos/repos.md"
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

cd - 

mapfile -t repos < "$input_file"

# Loop through each repository URL
for repo in "${repos[@]}"; do
    # Clone repository
    repo_name=$(basename "$repo" .git)
    if [ -d "$repo_name" ]; then
    	cd "$repo_name"
        git pull origin main
        cd -
    else
    	git clone "$repo"    
    fi
    
    
done
# Loop through each repository URL
for repo in "${repos[@]}"; do
    
    # Get the repository name
    repo_name=$(basename "$repo" .git)
    
    # Change directory into the repository
    cd "$repo_name" || exit 1
    
    if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    	cp .env.example .env
    fi
    
    # Check if docker-compose.airflow.yaml file exists
    if [ -f "docker-compose.airflow.yaml" ]; then
        # Run docker-compose for Airflow
        docker-compose -f docker-compose.airflow.yaml up -d
    fi
    
    # Check if docker-compose.yaml file exists
    if [ -f "docker-compose.yaml" ]; then
        docker-compose up --build -d
    fi
    
    # Change back to the original directory
    cd - || exit 1
done
