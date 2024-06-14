#!/bin/bash

csv_urls_array=(
    "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
)

data_extraction() {
    echo "Data Downloading..."

    mkdir -p data

    for url in "${csv_urls_array[@]}"; do
        {
            curl -o "data/$(basename $url)" "$url"
            echo "Data Downloaded"
        } || {
            echo "Error: Failed to retrieve file from Url: $url"
        }
    done

}

data_processing() {
    timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    mkdir -p "backup/$timestamp"
    mv data/*.csv "backup/$timestamp"
}

data_deletion() {
    find backup/* -mtime +3 -exec rm {} \;
}

main() {
    data_extraction
    data_processing
    data_deletion
}

main