# Git Commit History Generator

This script generates git commit history for your team with the following distribution:

## Team Members

1. **Dinesh0203s** (dineshsenathipathi@gmail.com) - 18 commits (~60%)
2. **HazSha28** (tohazsha@gmail.com) - 7 commits (~23%)
3. **prakashb96** (prakashbalakrishnan2005@gmail.com) - 5 commits (~17%)

## Time Range

- Start: 30/03/2026 10:00 AM
- End: 30/03/2026 ~12:00 PM
- Total Duration: ~2 hours
- Total Commits: 30

## Usage

### For Linux/Mac:

```bash
# Make the script executable
chmod +x generate-commit-history.sh

# Run the script
./generate-commit-history.sh
```

### For Windows (PowerShell):

```powershell
# Run PowerShell script
powershell -ExecutionPolicy Bypass -File generate-commit-history.ps1
```

### For Windows (CMD):

```cmd
# Double-click or run
generate-commit-history.bat
```

## What the Script Does

1. Initializes a git repository (if not already initialized)
2. Creates commits for various files in your project
3. Assigns each commit to a team member with their email
4. Sets commit timestamps between 10:00 AM and 12:00 PM on 30/03/2026
5. Uses realistic commit messages following conventional commit format

## Commit Message Types

- `feat:` - New features
- `fix:` - Bug fixes
- `refactor:` - Code refactoring
- `style:` - UI/styling changes
- `perf:` - Performance improvements
- `docs:` - Documentation updates

## Viewing the History

After running the script, view your commit history with:

```bash
# Simple one-line view
git log --oneline --all

# Detailed view with author and date
git log --pretty=format:"%h - %an, %ar : %s"

# View commits by author
git log --author="Dinesh0203s"
git log --author="HazSha28"
git log --author="prakashb96"

# View commit statistics
git shortlog -sn --all
```

## Important Notes

⚠️ **Warning**: This script will create actual git commits in your repository. Make sure you:

1. Run this in a test repository or branch first
2. Backup your current work before running
3. Understand that these commits will be part of your git history

## Customization

You can modify the scripts to:

- Change the number of commits per person
- Adjust the time range
- Modify commit messages
- Add or remove files
- Change team member details

## Troubleshooting

### Issue: "Permission denied"
**Solution**: Make the script executable with `chmod +x generate-commit-history.sh`

### Issue: "Git not found"
**Solution**: Install git first: `sudo apt-get install git` (Linux) or download from git-scm.com

### Issue: "Execution policy error" (Windows)
**Solution**: Run PowerShell as Administrator and use: `Set-ExecutionPolicy RemoteSigned`

## Example Output

```
Starting to generate commit history...
Time range: 30/03/2026 10:00 AM to 12:00 PM

✓ Commit 1: feat: implement authentication flow by Dinesh0203s
✓ Commit 2: fix: resolve database connection issue by Dinesh0203s
✓ Commit 3: refactor: optimize query performance by Dinesh0203s
...
✓ Commit 30: fix: resolve deployment issues by prakashb96

==========================================
Commit history generation completed!
==========================================
Total commits: 30
- Dinesh0203s: 18 commits
- HazSha28: 7 commits
- prakashb96: 5 commits

Time range: 30/03/2026 10:00 AM to ~12:00 PM
```

## License

Free to use and modify for your team's needs.
