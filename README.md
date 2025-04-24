# Scripts

### Install Brew and basic software basic programs

```
curl -fsSL https://raw.githubusercontent.com/maxoverhere/Scripts/refs/heads/main/setup_brew.sh | bash
```

This will install x-code brew and the basic tools like git and such

### Get Pretty Terminal (ZSH)

```
curl -fsSL https://raw.githubusercontent.com/maxoverhere/Scripts/refs/heads/main/setup_terminal.sh | zsh
```

This will set up your terminal to have syntax highlighting ect

### Delete old branches
```
curl -fsSL https://raw.githubusercontent.com/maxoverhere/Scripts/refs/heads/main/delete_old_branch.sh | bash
```

This will delete up to 10 branches that have not had a commit in over 90 days and have a branch prefix of ("refactor" "feat" "new" "bugfix" "fix" "hotfix")


```
curl -fsSL https://raw.githubusercontent.com/maxoverhere/Scripts/refs/heads/main/delete_old_branch_limit_10.sh | bash -s -- 5
```
This will do the same but delete a custom number of branches, in the example above it is deleting only 5 branches.
