# dotfiles
- stores all config and settings files

# Setup
- run the `install.sh` script
- if a file already exits on the machine
    1. first run `install.sh --adopt` 
        - this will bring in the system settings into the repo and create symlinks
    2. then run `git reset --hard` to bring the repo back to its intended state
    3. then run `install.sh` again to stow the correct files


# Merging from other branches
- Each branch will diverage as they are all for specific machines
1. use `git ls-remote --sort=committerdate` to get the latest commit hash from another branch
    - or use `git log origin/[branch-name] --oneline` to get all commit history
2. use `git cherry-pick [commit-hash]` to merge only the commit you want from that branch



