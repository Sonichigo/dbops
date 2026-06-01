#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Policy Configuration
MAX_SCHEMA_NAME_LENGTH=63
MAX_TABLE_NAME_LENGTH=63
MAX_COLUMN_NAME_LENGTH=63

MIGRATIONS_DIR="${1:-flyway/migrations}"

errors=0
warnings=0

echo "=================================="
echo "  Flyway Policy Validation"
echo "=================================="
echo "Scanning: $MIGRATIONS_DIR"
echo ""

# Check if migrations directory exists
if [ ! -d "$MIGRATIONS_DIR" ]; then
    echo -e "${RED}❌ Error: Migrations directory not found: $MIGRATIONS_DIR${NC}"
    exit 1
fi

# Function to check schema names
check_schema_names() {
    local file=$1
    local filename=$(basename "$file")

    # Extract schema names from CREATE SCHEMA statements
    grep -iE "CREATE\s+SCHEMA\s+(IF\s+NOT\s+EXISTS\s+)?([a-zA-Z0-9_]+)" "$file" 2>/dev/null | while read -r line; do
        schema_name=$(echo "$line" | sed -nE 's/.*CREATE\s+SCHEMA\s+(IF\s+NOT\s+EXISTS\s+)?([a-zA-Z0-9_]+).*/\2/ip')

        if [ -n "$schema_name" ]; then
            # Check length
            if [ ${#schema_name} -gt $MAX_SCHEMA_NAME_LENGTH ]; then
                echo -e "${RED}❌ $filename: Schema '$schema_name' exceeds $MAX_SCHEMA_NAME_LENGTH character limit (length: ${#schema_name})${NC}"
                ((errors++))
            fi

            # Check naming convention (snake_case)
            if ! echo "$schema_name" | grep -qE '^[a-z][a-z0-9_]*$'; then
                echo -e "${RED}❌ $filename: Schema '$schema_name' must be snake_case (lowercase with underscores)${NC}"
                ((errors++))
            fi

            # Check for discouraged prefixes
            if echo "$schema_name" | grep -qE '^(sch_|schema_)'; then
                echo -e "${YELLOW}⚠️  $filename: Schema '$schema_name' uses discouraged prefix${NC}"
                ((warnings++))
            fi
        fi
    done
}

# Function to check table names
check_table_names() {
    local file=$1
    local filename=$(basename "$file")

    # Extract table names from CREATE TABLE statements
    grep -iE "CREATE\s+TABLE\s+(IF\s+NOT\s+EXISTS\s+)?([a-zA-Z0-9_]+\.)?([a-zA-Z0-9_]+)" "$file" 2>/dev/null | while read -r line; do
        # Handle both schema.table and just table formats
        table_name=$(echo "$line" | sed -nE 's/.*CREATE\s+TABLE\s+(IF\s+NOT\s+EXISTS\s+)?([a-zA-Z0-9_]+\.)?([a-zA-Z0-9_]+).*/\3/ip')

        if [ -n "$table_name" ]; then
            # Check length
            if [ ${#table_name} -gt $MAX_TABLE_NAME_LENGTH ]; then
                echo -e "${RED}❌ $filename: Table '$table_name' exceeds $MAX_TABLE_NAME_LENGTH character limit (length: ${#table_name})${NC}"
                ((errors++))
            fi

            # Check naming convention (snake_case)
            if ! echo "$table_name" | grep -qE '^[a-z][a-z0-9_]*$'; then
                echo -e "${RED}❌ $filename: Table '$table_name' must be snake_case (lowercase with underscores)${NC}"
                ((errors++))
            fi

            # Check for discouraged prefixes
            if echo "$table_name" | grep -qE '^(tbl_|tb_|table_)'; then
                echo -e "${YELLOW}⚠️  $filename: Table '$table_name' uses discouraged prefix${NC}"
                ((warnings++))
            fi

            # Check for reserved words
            if echo "$table_name" | grep -qE '^(user|order|group|table|index|select|insert|update|delete)$'; then
                echo -e "${RED}❌ $filename: Table '$table_name' is a reserved SQL keyword${NC}"
                ((errors++))
            fi
        fi
    done
}

# Function to check column names
check_column_names() {
    local file=$1
    local filename=$(basename "$file")

    # Extract column definitions (basic pattern)
    grep -E "^\s+[a-zA-Z0-9_]+\s+(VARCHAR|INTEGER|BIGINT|TEXT|TIMESTAMP|BOOLEAN|NUMERIC|SERIAL|UUID|DATE|TIME|JSON)" "$file" 2>/dev/null | while read -r line; do
        column_name=$(echo "$line" | awk '{print $1}')

        if [ -n "$column_name" ]; then
            # Check length
            if [ ${#column_name} -gt $MAX_COLUMN_NAME_LENGTH ]; then
                echo -e "${YELLOW}⚠️  $filename: Column '$column_name' exceeds $MAX_COLUMN_NAME_LENGTH character limit (length: ${#column_name})${NC}"
                ((warnings++))
            fi

            # Check naming convention (snake_case)
            if ! echo "$column_name" | grep -qE '^[a-z][a-z0-9_]*$'; then
                echo -e "${YELLOW}⚠️  $filename: Column '$column_name' should be snake_case${NC}"
                ((warnings++))
            fi
        fi
    done
}

# Function to check for dangerous SQL patterns
check_dangerous_patterns() {
    local file=$1
    local filename=$(basename "$file")

    # Check for SELECT *
    if grep -iq "SELECT\s\+\*" "$file" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  $filename: Contains 'SELECT *' - specify columns explicitly for better performance${NC}"
        ((warnings++))
    fi

    # Check for DROP TABLE without IF EXISTS
    if grep -iE "DROP\s+TABLE\s+[^I]" "$file" 2>/dev/null | grep -qiv "IF EXISTS"; then
        echo -e "${YELLOW}⚠️  $filename: DROP TABLE without 'IF EXISTS' - may cause errors${NC}"
        ((warnings++))
    fi
}

# Main validation loop
echo "Validating SQL migration files..."
echo ""

for file in "$MIGRATIONS_DIR"/*.sql; do
    if [ -f "$file" ]; then
        check_schema_names "$file"
        check_table_names "$file"
        check_column_names "$file"
        check_dangerous_patterns "$file"
    fi
done

echo ""
echo "=================================="
echo "  Validation Summary"
echo "=================================="

if [ $warnings -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Warnings: $warnings${NC}"
fi

if [ $errors -gt 0 ]; then
    echo -e "${RED}❌ Errors: $errors${NC}"
    echo ""
    echo "Please fix the errors above before proceeding with migration."
    exit 1
else
    echo -e "${GREEN}✅ All policy checks passed!${NC}"
    exit 0
fi
