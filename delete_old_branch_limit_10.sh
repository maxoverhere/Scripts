#!/bin/bash

# Configuration
CUTOFF_DATE=$(date -v-90d "+%Y-%m-%d") # Approx. 90 days ago
MAX_BRANCH_DELETIONS=10 # Capped number of branches to delete
DELETABLE_PREFIXES=("refactor" "feat" "new" "bugfix" "fix" "hotfix") # Branch prefixes eligible for deletion
DELETED_BRANCH_COUNT=0
LOG_DIR=~/.scripts/logs
LOG_FILE="$LOG_DIR/branch_clean_$(date "+%d_%m_%y").log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Check if today is a weekday (don't run automated script on weekend)
DAY_OF_WEEK=$(date "+%u")
if [ "$DAY_OF_WEEK" -gt 5 ]; then
    echo "Script run aborted: Today is not a weekday." >> "$LOG_FILE"
    exit 0
fi

# Initialize log
echo "Script run at: $(date "+%Y-%m-%d %H:%M:%S")" > "$LOG_FILE"
echo "Starting branch deletion process..." >> "$LOG_FILE"
echo "Only deleting branches with prefix of: ${DELETABLE_PREFIXES[*]}" >> "$LOG_FILE"
echo >> "$LOG_FILE"

# Function to process a single Git repository
process_repository() {
    local repo_path="$1"
    echo "Processing repository: $repo_path" >> "$LOG_FILE"
    local branch_deleted_count=0
    local branch_analyzed_count=0

    # Navigate to the repository
    cd "$repo_path" || return

    # Ensure it's a Git repository
    if [ ! -d .git ]; then
        echo "Skipping $repo_path - Not a Git repository" >> "$LOG_FILE"
        echo >> "$LOG_FILE"
        return 0
    fi

    # Fetch all remote branches
    fetch_output=$(git fetch --all 2>&1)
    new_branches=$(echo "$fetch_output" | grep "new branch" | wc -l)
    echo "Fetched $new_branches new branches." >> "$LOG_FILE"

    # Loop through remote branches
    for branch in $(git branch -r | grep -v HEAD); do
        branch_analyzed_count=$((branch_analyzed_count + 1))
        branch_name=$(echo "$branch" | sed 's/origin\///')
        
        # Check if branch matches any of our deletable prefixes
        should_evaluate=false
        for prefix in "${DELETABLE_PREFIXES[@]}"; do
            if [[ "$branch_name" =~ ^$prefix ]]; then
                should_evaluate=true
                break
            fi
        done

        if [ "$should_evaluate" = true ]; then
            last_commit_date=$(git log -1 --format="%ai" "$branch" | cut -d ' ' -f 1)
            if [[ "$last_commit_date" < "$CUTOFF_DATE" ]]; then
                git push origin --delete "$branch_name" >> /dev/null 2>&1
                git branch -D "$branch_name" >> /dev/null 2>&1 # Delete local branch
                printf ">> Deleted branch: %s (Stale, last commit: %s)\n" "$branch_name" "$last_commit_date" >> "$LOG_FILE"
                branch_deleted_count=$((branch_deleted_count + 1))
                DELETED_BRANCH_COUNT=$((DELETED_BRANCH_COUNT + 1))
                if [ "$DELETED_BRANCH_COUNT" -ge "$MAX_BRANCH_DELETIONS" ]; then
                    echo "Reached maximum branch deletion limit of $MAX_BRANCH_DELETIONS" >> "$LOG_FILE"
                    break
                fi
            else
                printf "   Skipped branch: %s (Branch not stale, last commit: %s)\n" "$branch_name" "$last_commit_date" >> "$LOG_FILE"
            fi
        else
            printf "   Skipped branch: %s (Only deleting branches with prefix of: %s)\n" "$branch_name" "${DELETABLE_PREFIXES[*]}" >> "$LOG_FILE"
        fi
    done

    # Final summary for the repository
    echo "$repo_path: $branch_analyzed_count branches analyzed, $branch_deleted_count branches deleted" >> "$LOG_FILE"
    echo >> "$LOG_FILE"

    return 0
}

# Main loop: iterate through all 'code*' directories
for code_dir in ~/code*; do
    if [ -d "$code_dir" ]; then
        echo "Scanning directory: $code_dir" >> "$LOG_FILE"
        for project_dir in "$code_dir"/*; do
            if [ -d "$project_dir" ]; then
                process_repository "$project_dir"
                if [ "$DELETED_BRANCH_COUNT" -ge "$MAX_BRANCH_DELETIONS" ]; then
                    break 2
                fi
            fi
        done
    fi
done

# Finalize log with summary
echo "Script finished at: $(date "+%Y-%m-%d %H:%M:%S")" >> "$LOG_FILE"
echo "Total branches deleted: $DELETED_BRANCH_COUNT" >> "$LOG_FILE"
echo >> "$LOG_FILE"
echo "Summary of repositories checked:" >> "$LOG_FILE"
for repo in $(grep "Processing repository" "$LOG_FILE" | cut -d':' -f2-); do
    grep "$repo" "$LOG_FILE" | grep "branches analyzed" >> "$LOG_FILE"
done

# Open log in TextEdit
open -a TextEdit "$LOG_FILE"
