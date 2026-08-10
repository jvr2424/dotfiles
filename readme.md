# dotfiles
- stores all config and settings files, apps, and system setup for every machine (2 Macs + 2 Ubuntu servers) via a single branch
- GNU Stow symlinks the dotfiles; Ansible (`ansible/`) installs packages/toolchains and drives Stow, with per-machine differences expressed as Ansible facts/vars instead of divergent git branches

# Setup
- copy `ansible/inventory.ini.example` to `ansible/inventory.ini` (gitignored — real hostnames aren't checked into version control) and fill in each machine's real `hostname -s` output
- if a machine needs to override a default (e.g. the one Mac that still needs Python 3.12), copy `ansible/host_vars/example-hostname.yml.example` to `ansible/host_vars/<hostname>.yml` (gitignored, filename must match its alias in `inventory.ini`) and edit it
- copy `.env.example` to `.env` and fill in values (`OBSIDIAN_DIR`, service catalog URLs) before running, if this machine uses Obsidian or the service-catalog scripts
- run `./install.sh` on the machine you're setting up
    - bootstraps Ansible itself if missing, then runs `ansible-playbook` limited to this machine's hostname (`ansible/site.yml`, inventory in `ansible/inventory.ini`)
    - safe to re-run any time — every task converges to the desired state rather than erroring on repeat runs

## Adopting existing files on a machine that already has them
If a file Stow wants to manage already exists on disk (e.g. setting up a machine that had manual dotfiles before), pull it into the repo first instead of letting Ansible clobber it silently:
```
cd ~/.dotfiles
stow -R --adopt <package>   # e.g. bash, nvim, tmux — repeat per conflicting package
git diff                    # review what got pulled in from the live system
git checkout -- .           # discard the adopted version (repo's version wins), or
git add -p && git commit    # ...keep it, if the live system's version should win instead
./install.sh                # normal run, now safe since files match
```
This is a one-time, per-machine, semi-destructive operation — Ansible never runs `stow --adopt` itself.

# How machine differences are handled
All 4 machines (2 Macs, 2 Ubuntu servers) run off the same branch. Ansible decides what applies where:
- **OS-based**: `ansible_facts['os_family']` gates Mac-only tasks (Aerospace/iTerm2/VS Code Stow packages, Homebrew + `Brewfile`, `macos.sh`-equivalent `defaults write` calls, Obsidian symlinks) vs Ubuntu-only tasks (`apt` packages) — see `ansible/tasks/`.
- **Host-based**: `ansible/host_vars/<hostname>.yml` overrides variables for one specific machine — e.g. one Mac pins Python 3.12 (and keeps 3.9 available, unpinned) via `python_default_version`/`python_extra_versions`, while every other machine defaults to 3.14 with no extra versions (set in `ansible/group_vars/all.yml`).
- Run `ansible-playbook ansible/site.yml -i ansible/inventory.ini --limit <hostname> --tags <tag>` directly (bypassing `install.sh`) to target just one part of the setup (e.g. `--tags stow` to only restow dotfiles) — remember `--limit`, since `site.yml` targets `hosts: all` and every inventory host is `ansible_connection=local`.

There is no more branch-per-machine / cherry-pick workflow. `main`, `mac_stow`, and `ubuntu` branches are retired once all 4 machines are verified against this branch.
