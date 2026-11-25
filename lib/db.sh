#!/bin/bash

create_database() {
    read -p "Enter database name: " db_name

    if ! valid_name "$db_name"; then
        return
    fi

    if [[ -d "$DB_ROOT/$db_name" ]]; then
        echo "Error: database '$db_name' already exists."
        return
    fi

    mkdir "$DB_ROOT/$db_name"
    echo "Database '$db_name' created."
}

list_databases() {
    if [[ -z "$(ls -A "$DB_ROOT")" ]]; then
        echo "No databases found."
        return
    fi

    echo "Databases:"
    ls -1 "$DB_ROOT"
}
