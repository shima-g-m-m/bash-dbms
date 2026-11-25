#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_ROOT="$SCRIPT_DIR/DBs"

mkdir -p "$DB_ROOT"

source "$SCRIPT_DIR/lib/validate.sh"
source "$SCRIPT_DIR/lib/db.sh"
source "$SCRIPT_DIR/lib/table.sh"

while true; do
    echo
    echo "------ Main Menu ------"
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect To Database"
    echo "4) Drop Database"
    echo "5) Exit"
    read -p "Choose: " choice || { echo; echo "Bye"; exit 0; }

    case "$choice" in
        1) create_database ;;
        2) list_databases ;;
        3) connect_database ;;
        4) drop_database ;;
        5) echo "Bye"; exit 0 ;;
        *) echo "Invalid choice, enter a number from 1 to 5." ;;
    esac
done
