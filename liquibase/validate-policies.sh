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

CHANGELOG_FILE="${1:-liquibase/gcp.yaml}"

errors=0
warnings=0

echo "=================================="
echo "  Liquibase Policy Validation"
echo "=================================="
echo "Scanning: $CHANGELOG_FILE"
echo ""

# Check if changelog file exists
if [ ! -f "$CHANGELOG_FILE" ]; then
    echo -e "${RED}❌ Error: Changelog file not found: $CHANGELOG_FILE${NC}"
    exit 1
fi

# Function to extract and validate schema names from YAML
check_schema_names_yaml() {
    # Extract schemaName values from YAML
    grep -oE "schemaName:\s*[a-zA-Z0-9_]+" "$CHANGELOG_FILE" 2>/dev/null | while read -r line; do
        schema_name=$(echo "$line" | sed -E "s/schemaName:\s*//" | tr -d ' \t')

        if [ -n "$schema_name" ]; then
            # Check length
            if [ ${#schema_name} -gt $MAX_SCHEMA_NAME_LENGTH ]; then
                echo -e "${RED}❌ Schema '$schema_name' exceeds $MAX_SCHEMA_NAME_LENGTH character limit (length: ${#schema_name})${NC}"
                ((errors++))
            fi

            # Check naming convention (snake_case)
            if ! echo "$schema_name" | grep -qE '^[a-z][a-z0-9_]*$'; then
                echo -e "${RED}❌ Schema '$schema_name' must be snake_case (lowercase with underscores)${NC}"
                ((errors++))
            fi

            # Check for discouraged prefixes
            if echo "$schema_name" | grep -qE '^(sch_|schema_)'; then
                echo -e "${YELLOW}⚠️  Schema '$schema_name' uses discouraged prefix${NC}"
                ((warnings++))
            fi
        fi
    done
}

# Function to extract and validate table names from YAML
check_table_names_yaml() {
    # Extract tableName values from YAML
    grep -oE "tableName:\s*[a-zA-Z0-9_]+" "$CHANGELOG_FILE" 2>/dev/null | while read -r line; do
        table_name=$(echo "$line" | sed -E "s/tableName:\s*//" | tr -d ' \t')

        if [ -n "$table_name" ]; then
            # Check length
            if [ ${#table_name} -gt $MAX_TABLE_NAME_LENGTH ]; then
                echo -e "${RED}❌ Table '$table_name' exceeds $MAX_TABLE_NAME_LENGTH character limit (length: ${#table_name})${NC}"
                ((errors++))
            fi

            # Check naming convention (snake_case)
            if ! echo "$table_name" | grep -qE '^[a-z][a-z0-9_]*$'; then
                echo -e "${RED}❌ Table '$table_name' must be snake_case (lowercase with underscores)${NC}"
                ((errors++))
            fi

            # Check for discouraged prefixes
            if echo "$table_name" | grep -qE '^(tbl_|tb_|table_)'; then
                echo -e "${YELLOW}⚠️  Table '$table_name' uses discouraged prefix${NC}"
                ((warnings++))
            fi

            # Check for reserved words
            if echo "$table_name" | grep -qE '^(user|order|group|table|index|select|insert|update|delete)$'; then
                echo -e "${RED}❌ Table '$table_name' is a reserved SQL keyword${NC}"
                ((errors++))
            fi
        fi
    done
}

# Function to extract and validate column names from YAML
check_column_names_yaml() {
    # Extract column name values from YAML (looking for "name:" under columns)
    grep -oE "name:\s*[a-zA-Z0-9_]+" "$CHANGELOG_FILE" 2>/dev/null | while read -r line; do
        column_name=$(echo "$line" | sed -E "s/name:\s*//" | tr -d ' \t')

        if [ -n "$column_name" ]; then
            # Check length
            if [ ${#column_name} -gt $MAX_COLUMN_NAME_LENGTH ]; then
                echo -e "${YELLOW}⚠️  Column '$column_name' exceeds $MAX_COLUMN_NAME_LENGTH character limit (length: ${#column_name})${NC}"
                ((warnings++))
            fi

            # Check naming convention (snake_case)
            if ! echo "$column_name" | grep -qE '^[a-z][a-z0-9_]*$'; then
                echo -e "${YELLOW}⚠️  Column '$column_name' should be snake_case${NC}"
                ((warnings++))
            fi
        fi
    done
}

# Function to check for foreign keys without indexes
check_foreign_key_indexes() {
    # Look for foreign key constraints
    if grep -q "foreignKeyName:" "$CHANGELOG_FILE" 2>/dev/null; then
        # Basic check - in real scenarios, this would be more sophisticated
        local fk_count=$(grep -c "foreignKeyName:" "$CHANGELOG_FILE")
        local idx_count=$(grep -c "createIndex:" "$CHANGELOG_FILE")

        if [ $idx_count -lt $fk_count ]; then
            echo -e "${YELLOW}⚠️  Found $fk_count foreign keys but only $idx_count indexes - consider indexing foreign key columns${NC}"
            ((warnings++))
        fi
    fi
}

# Function to check for SQL in YAML
check_inline_sql() {
    # Check for sql: or sqlFile: tags with dangerous patterns
    if grep -E "^\s*-?\s*sql:" "$CHANGELOG_FILE" 2>/dev/null | grep -q "SELECT \*"; then
        echo -e "${YELLOW}⚠️  Contains 'SELECT *' in inline SQL - specify columns explicitly${NC}"
        ((warnings++))
    fi

    if grep -E "^\s*-?\s*sql:" "$CHANGELOG_FILE" 2>/dev/null | grep -qE "DROP\s+TABLE"; then
        echo -e "${YELLOW}⚠️  Contains DROP TABLE in inline SQL - ensure proper rollback strategy${NC}"
        ((warnings++))
    fi
}

# Function to check for rollback definitions
check_rollback_strategy() {
    local changeset_count=$(grep -c "changeSet:" "$CHANGELOG_FILE" 2>/dev/null || echo "0")
    local rollback_count=$(grep -c "rollback:" "$CHANGELOG_FILE" 2>/dev/null || echo "0")

    if [ $changeset_count -gt 0 ] && [ $rollback_count -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No rollback strategies defined - consider adding rollback for production safety${NC}"
        ((warnings++))
    fi
}

# Main validation
echo "Validating Liquibase changelog..."
echo ""

check_schema_names_yaml
check_table_names_yaml
check_column_names_yaml
check_foreign_key_indexes
check_inline_sql
check_rollback_strategy

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
