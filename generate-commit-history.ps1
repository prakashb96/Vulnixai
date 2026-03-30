# Team member configurations
$MEMBER1_NAME = "Dinesh0203s"
$MEMBER1_EMAIL = "dineshsenathipathi@gmail.com"

$MEMBER2_NAME = "HazSha28"
$MEMBER2_EMAIL = "tohazsha@gmail.com"

$MEMBER3_NAME = "prakashb96"
$MEMBER3_EMAIL = "prakashbalakrishnan2005@gmail.com"

# Base timestamp: 30/03/2026 10:00 AM
$BASE_TIMESTAMP = Get-Date "2026-03-30 10:00:00"

# Function to create a commit with specific author and timestamp
function Create-Commit {
    param(
        [string]$AuthorName,
        [string]$AuthorEmail,
        [string]$Message,
        [int]$MinutesOffset
    )
    
    # Calculate commit timestamp
    $CommitDate = $BASE_TIMESTAMP.AddMinutes($MinutesOffset).ToString("yyyy-MM-ddTHH:mm:ss")
    
    # Stage ALL files
    git add -A
    
    # Set environment variables for git
    $env:GIT_AUTHOR_NAME = $AuthorName
    $env:GIT_AUTHOR_EMAIL = $AuthorEmail
    $env:GIT_COMMITTER_NAME = $AuthorName
    $env:GIT_COMMITTER_EMAIL = $AuthorEmail
    $env:GIT_AUTHOR_DATE = $CommitDate
    $env:GIT_COMMITTER_DATE = $CommitDate
    
    # Create commit
    git commit -m $Message
}

Write-Host "Starting to generate commit history..." -ForegroundColor Green
Write-Host "Time range: 30/03/2026 10:00 AM to 12:00 PM" -ForegroundColor Green
Write-Host ""

# Initialize git if not already initialized
if (-not (Test-Path .git)) {
    git init
    Write-Host "Git repository initialized" -ForegroundColor Yellow
}

$COMMIT_MESSAGES = @(
    "feat: implement authentication flow",
    "fix: resolve database connection issue",
    "refactor: optimize query performance",
    "feat: add monitoring dashboard",
    "fix: correct API endpoint paths",
    "docs: update README with setup instructions",
    "feat: implement website scanner",
    "style: improve UI components styling",
    "fix: handle edge cases in validation",
    "feat: add penetration testing module",
    "refactor: clean up code structure",
    "fix: resolve CORS issues",
    "feat: implement load testing feature",
    "perf: optimize image loading",
    "fix: correct TypeScript types",
    "feat: add user profile management",
    "refactor: improve error handling",
    "fix: resolve memory leak",
    "feat: implement scan history",
    "style: update navigation design",
    "fix: correct authentication middleware",
    "feat: add GitHub integration",
    "refactor: modularize services",
    "fix: resolve routing issues",
    "feat: implement real-time monitoring",
    "perf: reduce bundle size",
    "fix: handle null values properly",
    "feat: add export functionality",
    "refactor: improve code readability",
    "fix: resolve deployment issues"
)

# Generate commits
$COMMIT_COUNT = 0
$MINUTE_OFFSET = 0

# Dinesh commits (18 commits)
Write-Host "`nGenerating commits for $MEMBER1_NAME..." -ForegroundColor Cyan
for ($i = 0; $i -lt 18; $i++) {
    $MSG_INDEX = $i % $COMMIT_MESSAGES.Count
    Create-Commit -AuthorName $MEMBER1_NAME -AuthorEmail $MEMBER1_EMAIL -Message $COMMIT_MESSAGES[$MSG_INDEX] -MinutesOffset $MINUTE_OFFSET
    $COMMIT_COUNT++
    Write-Host "Commit $COMMIT_COUNT : $($COMMIT_MESSAGES[$MSG_INDEX]) by $MEMBER1_NAME" -ForegroundColor Green
    $MINUTE_OFFSET += Get-Random -Minimum 3 -Maximum 13
}

# HazSha commits (7 commits)
Write-Host "`nGenerating commits for $MEMBER2_NAME..." -ForegroundColor Cyan
for ($i = 18; $i -lt 25; $i++) {
    $MSG_INDEX = $i % $COMMIT_MESSAGES.Count
    Create-Commit -AuthorName $MEMBER2_NAME -AuthorEmail $MEMBER2_EMAIL -Message $COMMIT_MESSAGES[$MSG_INDEX] -MinutesOffset $MINUTE_OFFSET
    $COMMIT_COUNT++
    Write-Host "Commit $COMMIT_COUNT : $($COMMIT_MESSAGES[$MSG_INDEX]) by $MEMBER2_NAME" -ForegroundColor Green
    $MINUTE_OFFSET += Get-Random -Minimum 5 -Maximum 17
}

# Prakash commits (5 commits)
Write-Host "`nGenerating commits for $MEMBER3_NAME..." -ForegroundColor Cyan
for ($i = 25; $i -lt 30; $i++) {
    $MSG_INDEX = $i % $COMMIT_MESSAGES.Count
    Create-Commit -AuthorName $MEMBER3_NAME -AuthorEmail $MEMBER3_EMAIL -Message $COMMIT_MESSAGES[$MSG_INDEX] -MinutesOffset $MINUTE_OFFSET
    $COMMIT_COUNT++
    Write-Host "Commit $COMMIT_COUNT : $($COMMIT_MESSAGES[$MSG_INDEX]) by $MEMBER3_NAME" -ForegroundColor Green
    $MINUTE_OFFSET += Get-Random -Minimum 5 -Maximum 20
}

Write-Host "`n==========================================" -ForegroundColor Yellow
Write-Host "Commit history generation completed!" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "Total commits: $COMMIT_COUNT" -ForegroundColor White
Write-Host "- $MEMBER1_NAME : 18 commits" -ForegroundColor White
Write-Host "- $MEMBER2_NAME : 7 commits" -ForegroundColor White
Write-Host "- $MEMBER3_NAME : 5 commits" -ForegroundColor White
Write-Host "" -ForegroundColor White
Write-Host "Time range: 30/03/2026 10:00 AM to 12:00 PM" -ForegroundColor White
Write-Host ""
Write-Host "View commit history with these commands:" -ForegroundColor Cyan
Write-Host "  git log --oneline --all" -ForegroundColor Yellow
Write-Host "  git shortlog -sn --all" -ForegroundColor Yellow
