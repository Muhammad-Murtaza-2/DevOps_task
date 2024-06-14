#!/bin/bash

# List of CSV URLs
csv_urls=(
    "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
    # Add more URLs as needed
)

# Function to retrieve data from the internet
retrieve_data() {
    echo "Data Downloading..."

    # Create data directory if it doesn't exist
    mkdir -p data

    for url in "${csv_urls[@]}"; do
        {
            curl -o "data/$(basename $url)" "$url"
            echo "Data Downloaded"
        } || {
            echo "Error: Failed to retrieve file from Url: $url"
        }
    done

}

# Function to organize data into time-stamped directories
organize_data() {
    timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    mkdir -p "backup/$timestamp"
    mv data/*.csv "backup/$timestamp"
}

# Function to delete data copies older than 3 days
delete_old_data() {
    find backup/* -mtime +3 -exec rm {} \;
}

# Main function to execute the script
main() {
    retrieve_data
    organize_data
    delete_old_data
}

# Run the main function
main