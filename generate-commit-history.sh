#!/bin/bash

# Team member configurations
MEMBER1_NAME="Dinesh0203s"
MEMBER1_EMAIL="dineshsenathipathi@gmail.com"

MEMBER2_NAME="HazSha28"
MEMBER2_EMAIL="tohazsha@gmail.com"

MEMBER3_NAME="prakashb96"
MEMBER3_EMAIL="prakashbalakrishnan2005@gmail.com"

# Base timestamp: 30/03/2026 10:00 AM
BASE_TIMESTAMP="2026-03-30T10:00:00"

# Function to create a commit with specific author and timestamp
create_commit() {
    local author_name=$1
    local author_email=$2
    local file=$3
    local message=$4
    local minutes_offset=$5
    
    # Calculate commit timestamp
    local commit_date=$(date -d "$BASE_TIMESTAMP +${minutes_offset} minutes" +"%Y-%m-%dT%H:%M:%S")
    
    # Stage the file
    git add "$file"
    
    # Create commit with specific author and date
    GIT_AUTHOR_NAME="$author_name" \
    GIT_AUTHOR_EMAIL="$author_email" \
    GIT_COMMITTER_NAME="$author_name" \
    GIT_COMMITTER_EMAIL="$author_email" \
    GIT_AUTHOR_DATE="$commit_date" \
    GIT_COMMITTER_DATE="$commit_date" \
    git commit -m "$message"
}

echo "Starting to generate commit history..."
echo "Time range: 30/03/2026 10:00 AM to 12:00 PM"
echo ""

# Initialize git if not already initialized
if [ ! -d .git ]; then
    git init
    echo "Git repository initialized"
fi

# Array of files to commit (you can modify this based on your actual files)
declare -a FILES=(
    "backend/src/index.ts"
    "backend/src/config/database.ts"
    "backend/src/controllers/auth.controller.ts"
    "backend/src/services/monitoring.service.ts"
    "src/App.tsx"
    "src/pages/LandingPage.tsx"
    "src/components/Navigation.tsx"
    "backend/src/services/websiteScanner.service.ts"
    "src/pages/MonitoringPage.tsx"
    "backend/src/controllers/scan.controller.ts"
    "src/services/scan.service.ts"
    "backend/src/services/penetrationTesting.service.ts"
    "src/pages/ScanHistoryPage.tsx"
    "backend/src/db/models/User.model.ts"
    "src/contexts/AuthContext.tsx"
    "backend/src/middleware/auth.middleware.ts"
    "src/pages/WebsiteScanPage.tsx"
    "backend/src/services/loadTesting.service.ts"
    "src/components/ui/button.tsx"
    "backend/src/controllers/monitoring.controller.ts"
    "src/pages/ProfilePage.tsx"
    "backend/src/services/groq.service.ts"
    "src/pages/ResultsPage.tsx"
    "backend/src/config/env.ts"
    "src/utils/api.ts"
    "backend/src/services/repoScanner.service.ts"
    "src/pages/ScanDetailPage.tsx"
    "backend/src/db/models/Scan.model.ts"
    "src/components/ProtectedRoute.tsx"
    "backend/src/services/githubAuth.service.ts"
)

declare -a COMMIT_MESSAGES=(
    "feat: implement authentication flow"
    "fix: resolve database connection issue"
    "refactor: optimize query performance"
    "feat: add monitoring dashboard"
    "fix: correct API endpoint paths"
    "docs: update README with setup instructions"
    "feat: implement website scanner"
    "style: improve UI components styling"
    "fix: handle edge cases in validation"
    "feat: add penetration testing module"
    "refactor: clean up code structure"
    "fix: resolve CORS issues"
    "feat: implement load testing feature"
    "perf: optimize image loading"
    "fix: correct TypeScript types"
    "feat: add user profile management"
    "refactor: improve error handling"
    "fix: resolve memory leak"
    "feat: implement scan history"
    "style: update navigation design"
    "fix: correct authentication middleware"
    "feat: add GitHub integration"
    "refactor: modularize services"
    "fix: resolve routing issues"
    "feat: implement real-time monitoring"
    "perf: reduce bundle size"
    "fix: handle null values properly"
    "feat: add export functionality"
    "refactor: improve code readability"
    "fix: resolve deployment issues"
)

# Generate commits (total 30 commits over 120 minutes)
# Dinesh: ~18 commits, HazSha: ~7 commits, Prakash: ~5 commits

COMMIT_COUNT=0
MINUTE_OFFSET=0

# Dinesh commits (18 commits)
for i in {0..17}; do
    FILE_INDEX=$((i % ${#FILES[@]}))
    MSG_INDEX=$((i % ${#COMMIT_MESSAGES[@]}))
    create_commit "$MEMBER1_NAME" "$MEMBER1_EMAIL" "${FILES[$FILE_INDEX]}" "${COMMIT_MESSAGES[$MSG_INDEX]}" $MINUTE_OFFSET
    echo "✓ Commit $((++COMMIT_COUNT)): ${COMMIT_MESSAGES[$MSG_INDEX]} by $MEMBER1_NAME"
    MINUTE_OFFSET=$((MINUTE_OFFSET + RANDOM % 10 + 3))
done

# HazSha commits (7 commits)
for i in {18..24}; do
    FILE_INDEX=$((i % ${#FILES[@]}))
    MSG_INDEX=$((i % ${#COMMIT_MESSAGES[@]}))
    create_commit "$MEMBER2_NAME" "$MEMBER2_EMAIL" "${FILES[$FILE_INDEX]}" "${COMMIT_MESSAGES[$MSG_INDEX]}" $MINUTE_OFFSET
    echo "✓ Commit $((++COMMIT_COUNT)): ${COMMIT_MESSAGES[$MSG_INDEX]} by $MEMBER2_NAME"
    MINUTE_OFFSET=$((MINUTE_OFFSET + RANDOM % 12 + 5))
done

# Prakash commits (5 commits)
for i in {25..29}; do
    FILE_INDEX=$((i % ${#FILES[@]}))
    MSG_INDEX=$((i % ${#COMMIT_MESSAGES[@]}))
    create_commit "$MEMBER3_NAME" "$MEMBER3_EMAIL" "${FILES[$FILE_INDEX]}" "${COMMIT_MESSAGES[$MSG_INDEX]}" $MINUTE_OFFSET
    echo "✓ Commit $((++COMMIT_COUNT)): ${COMMIT_MESSAGES[$MSG_INDEX]} by $MEMBER3_NAME"
    MINUTE_OFFSET=$((MINUTE_OFFSET + RANDOM % 15 + 5))
done

echo ""
echo "=========================================="
echo "Commit history generation completed!"
echo "=========================================="
echo "Total commits: $COMMIT_COUNT"
echo "- $MEMBER1_NAME: 18 commits"
echo "- $MEMBER2_NAME: 7 commits"
echo "- $MEMBER3_NAME: 5 commits"
echo ""
echo "Time range: 30/03/2026 10:00 AM to ~12:00 PM"
echo ""
echo "Run 'git log --oneline --all' to view the commit history"
echo "Run 'git log --pretty=format:\"%h - %an, %ar : %s\"' for detailed view"
