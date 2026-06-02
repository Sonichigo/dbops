#!/bin/bash

# Quick deployment script for Jenkins pipelines
# This script helps you quickly set up the pipelines on localhost:8080

set -e

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
JENKINS_USER=admin
JENKINS_TOKEN=1138253846e1994a751b0d97cb80c59954

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   Jenkins Pipeline Quick Deploy Script                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Jenkins URL: $JENKINS_URL"
echo ""

# Check if Jenkins is running
echo "🔍 Checking if Jenkins is accessible..."
if ! curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL" | grep -q "200\|403"; then
    echo "❌ Error: Jenkins is not accessible at $JENKINS_URL"
    echo "   Please ensure Jenkins is running: docker-compose up -d"
    exit 1
fi
echo "✅ Jenkins is accessible"
echo ""

# Check if Jenkins CLI is available
if [ -n "$JENKINS_TOKEN" ] && [ -n "$JENKINS_USER" ]; then
    echo "🔑 Jenkins credentials found"
    echo "   User: $JENKINS_USER"
    echo ""

    echo "📋 You can create pipelines via Jenkins CLI:"
    echo ""
    echo "Option 1: Download Jenkins CLI"
    echo "  wget $JENKINS_URL/jnlpJars/jenkins-cli.jar"
    echo ""
    echo "Option 2: Use Jenkins API to create jobs"
    echo "  (Manual steps below)"
    echo ""
else
    echo "⚠️  Jenkins credentials not provided"
    echo "   Set environment variables:"
    echo "     export JENKINS_USER=admin"
    echo "     export JENKINS_TOKEN=your_api_token"
    echo ""
fi

echo "═══════════════════════════════════════════════════════════"
echo "  MANUAL DEPLOYMENT STEPS"
echo "═══════════════════════════════════════════════════════════"
echo ""

echo "Step 1️⃣: Access Jenkins"
echo "  Open: $JENKINS_URL"
echo "  Login with your credentials"
echo ""

echo "Step 2️⃣: Create Pipeline Jobs"
echo ""
echo "  For FLYWAY pipeline:"
echo "  ────────────────────"
echo "  1. Click 'New Item'"
echo "  2. Name: Flyway-Database-Migration"
echo "  3. Type: Pipeline"
echo "  4. Pipeline Definition: Pipeline script from SCM"
echo "  5. SCM: Git"
echo "  6. Repository URL: $(git remote get-url origin 2>/dev/null || echo '<your-repo-url>')"
echo "  7. Script Path: Jenkinsfile.flyway"
echo "  8. Click Save"
echo ""

echo "  For LIQUIBASE pipeline:"
echo "  ─────────────────────"
echo "  1. Click 'New Item'"
echo "  2. Name: Liquibase-Database-Migration"
echo "  3. Type: Pipeline"
echo "  4. Pipeline Definition: Pipeline script from SCM"
echo "  5. SCM: Git"
echo "  6. Repository URL: $(git remote get-url origin 2>/dev/null || echo '<your-repo-url>')"
echo "  7. Script Path: Jenkinsfile.liquibase"
echo "  8. Click Save"
echo ""

echo "Step 3️⃣: Configure Credentials (for main Jenkinsfile)"
echo "  ────────────────────────────"
echo "  Go to: Manage Jenkins → Credentials → (global)"
echo ""
echo "  Add these credentials:"
echo "  • database-url: jdbc:postgresql://10.0.198.213:5432/Jenkins"
echo "  • database-username: user"
echo "  • database-password: password"
echo ""
echo "  OR use Jenkinsfile.liquibase.local which has credentials built-in"
echo ""

echo "Step 4️⃣: Run Your First Build"
echo "  ──────────────────────────"
echo "  1. Open the pipeline job"
echo "  2. Click 'Build with Parameters'"
echo "  3. Set DRY_RUN = true (for first run)"
echo "  4. Click 'Build'"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  ALTERNATIVE: Direct Pipeline Script (Quick Test)"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "If you want to test quickly without Git:"
echo ""
echo "1. New Item → Name: 'Flyway-Test' → Pipeline"
echo "2. Pipeline Definition: Pipeline script"
echo "3. Copy-paste contents of: Jenkinsfile.flyway"
echo "4. Save and Build"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  VALIDATION SCRIPTS"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "The pipelines use these standalone validation scripts:"
echo "  • flyway/validate-policies.sh"
echo "  • liquibase/validate-policies.sh"
echo ""
echo "Test them locally before pushing:"
echo "  ./flyway/validate-policies.sh flyway/migrations"
echo "  ./liquibase/validate-policies.sh liquibase/gcp.yaml"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  FILES TO REVIEW"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📄 Jenkinsfile.flyway           - Flyway pipeline definition"
echo "📄 Jenkinsfile.liquibase        - Liquibase pipeline definition"
echo "📄 flyway/validate-policies.sh  - Flyway validation script"
echo "📄 liquibase/validate-policies.sh - Liquibase validation script"
echo "📄 JENKINS_DEPLOYMENT_GUIDE.md  - Detailed deployment guide"
echo "📄 POLICY_VALIDATION_GUIDE.md   - Policy documentation"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  NEED HELP?"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📖 Read the full guide: JENKINS_DEPLOYMENT_GUIDE.md"
echo "🐛 Issues? Check troubleshooting section in the guide"
echo ""
echo "Ready to deploy! 🚀"
echo ""
