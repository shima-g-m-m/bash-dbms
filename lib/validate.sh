#!/bin/bash

# valid_name NAME
# Succeeds (return 0) if NAME is a valid database/table/column name.
# Otherwise prints the reason and fails (return 1).
valid_name() {
    local name="$1"

    if [[ -z "$name" ]]; then
        echo "Error: name cannot be empty."
        return 1
    fi

    if [[ ${#name} -gt 30 ]]; then
        echo "Error: name cannot be longer than 30 characters."
        return 1
    fi

    if [[ ! "$name" =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]; then
        echo "Error: name must start with a letter and contain only letters, digits and underscores."
        return 1
    fi

    return 0
}
