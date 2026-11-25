#!/bin/bash

create_table() {
    local db_name="$1"
    local db_path="$DB_ROOT/$db_name"
    local table_name col_count i col_name type_choice col_type pk_choice dup existing
    local names=() types=()

    # --- table name (asks again until valid) ---
    while true; do
        read -p "Enter table name (Ctrl+D to cancel): " table_name || { echo; echo "Table creation cancelled."; return; }

        if ! valid_name "$table_name"; then
            continue
        fi

        if [[ -e "$db_path/$table_name.meta" ]]; then
            echo "Error: table '$table_name' already exists."
            continue
        fi
        break
    done

    # --- number of columns (asks again until valid) ---
    while true; do
        read -p "Enter number of columns (1-20): " col_count || { echo; echo "Table creation cancelled."; return; }

        if [[ "$col_count" =~ ^[1-9][0-9]?$ ]] && (( col_count <= 20 )); then
            break
        fi
        echo "Error: number of columns must be a whole number from 1 to 20."
    done

    for (( i = 1; i <= col_count; i++ )); do
        # --- column name ---
        while true; do
            read -p "Column $i name: " col_name || { echo; echo "Table creation cancelled."; return; }

            if ! valid_name "$col_name"; then
                continue
            fi

            dup=0
            for existing in "${names[@]}"; do
                if [[ "${existing,,}" == "${col_name,,}" ]]; then
                    dup=1
                fi
            done
            if (( dup )); then
                echo "Error: column '$col_name' is already used in this table."
                continue
            fi
            break
        done

        # --- column type ---
        while true; do
            read -p "Column $i type (1=int, 2=string): " type_choice || { echo; echo "Table creation cancelled."; return; }
            case "$type_choice" in
                1) col_type="int"; break ;;
                2) col_type="string"; break ;;
                *) echo "Error: enter 1 for int or 2 for string." ;;
            esac
        done

        names+=("$col_name")
        types+=("$col_type")
    done

    # --- primary key ---
    echo "Columns:"
    for (( i = 0; i < col_count; i++ )); do
        echo "  $((i + 1))) ${names[i]} (${types[i]})"
    done

    while true; do
        read -p "Choose the primary key column number: " pk_choice || { echo; echo "Table creation cancelled."; return; }
        if [[ "$pk_choice" =~ ^[1-9][0-9]?$ ]] && (( pk_choice <= col_count )); then
            break
        fi
        echo "Error: enter a number from 1 to $col_count."
    done

    # --- everything is valid: write the files ---
    : > "$db_path/$table_name.meta"
    for (( i = 0; i < col_count; i++ )); do
        if (( i + 1 == pk_choice )); then
            echo "${names[i]}:${types[i]}:pk" >> "$db_path/$table_name.meta"
        else
            echo "${names[i]}:${types[i]}" >> "$db_path/$table_name.meta"
        fi
    done
    touch "$db_path/$table_name.data"

    echo "Table '$table_name' created."
}

table_menu() {
    local db_name="$1"

    while true; do
        echo
        echo "------ Database: $db_name ------"
        echo "1) Create Table"
        echo "2) List Tables"
        echo "3) Drop Table"
        echo "4) Insert into Table"
        echo "5) Select From Table"
        echo "6) Delete From Table"
        echo "7) Update Table"
        echo "8) Back to Main Menu"
        read -p "Choose: " choice || { echo; return; }

        case "$choice" in
            1) create_table "$db_name" ;;
            2|3|4|5|6|7) echo "Coming soon" ;;
            8) return ;;
            *) echo "Invalid choice, enter a number from 1 to 8." ;;
        esac
    done
}
