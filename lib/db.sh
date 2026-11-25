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

connect_database() {
    if [[ -z "$(ls -A "$DB_ROOT")" ]]; then
        echo "No databases found. Create one first."
        return
    fi

    list_databases
    read -p "Enter database name to connect to: " db_name

    if ! valid_name "$db_name"; then
        return
    fi

    if [[ ! -d "$DB_ROOT/$db_name" ]]; then
        echo "Error: database '$db_name' does not exist."
        return
    fi

    echo "Connected to '$db_name'."
    table_menu "$db_name"
}

drop_database() {
    if [[ -z "$(ls -A "$DB_ROOT")" ]]; then
        echo "No databases found."
        return
    fi

    list_databases
    read -p "Enter database name to drop: " db_name

    if ! valid_name "$db_name"; then
        return
    fi

    if [[ ! -d "$DB_ROOT/$db_name" ]]; then
        echo "Error: database '$db_name' does not exist."
        return
    fi

    read -p "Drop '$db_name' and ALL its tables? (y/n): " answer

    case "$answer" in
        y|Y|yes|YES) rm -r "$DB_ROOT/$db_name"
                     echo "Database '$db_name' dropped." ;;
        *)           echo "Drop cancelled." ;;
    esac
}
