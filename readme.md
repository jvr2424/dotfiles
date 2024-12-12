# dotfiles
- stores all config and settings files

# Setup
- create a bare git repo `git init --bare` in a folder called dotfiles
- add the git remote `git remote add origin <link to repo>`
- add the following alias to the .bashrc `alias dotgit="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"`
- run this one time config command `dotgit config --local status.showUntrackedFiles no`
  - this will disable untracked files from appearing in git status commands
  - manually add each file you'd like to track like regular git commands
    - `dotgit add .bashrc`
    - `dotgit commit -m "adding bashrc"`
    - `dotgit push`

