format session-log-v1
stamp 20261104.045955
session-header 20261104/20261104-045214_ssh-decouple-and-nib-amend.kyri.md
voice Kyri
title Deploy key generation for 20260618-grain
prompt kg -- generate fresh deploy key for this clone
think The prior session decoupled SSH auth via `core.sshCommand` and symlinks to the vultr personal key. Both SSH keys then stopped authenticating to GitHub mid-session. Keaton asked to generate new keys for this directory.
think Generated a fresh ed25519 key pair (passphrase-free) inside `.ssh/` with `ssh-keygen -t ed25519`. Registered it on `xykj61/20260618-grain` as a deploy key with `--allow-write` via `gh repo deploy-key add`. This scopes the key to one repository -- tighter than a personal key.
think The global `~/.ssh/config` `Host github.com` block still injects the old jail key via `IdentityFile`, and the macOS SSH agent offers it first. With the old symlink approach (no `-F /dev/null`), SSH authenticated with the jail key before ever trying ours. Adding `-F /dev/null` to `core.sshCommand` suppresses the global config entirely. Since the new key is passphrase-free, the agent is not needed and `-F /dev/null` works -- the same flag killed auth in the prior session because the vultr key needed the agent for its passphrase.
think Deploy key propagation was uneven across GitHub's servers -- push worked within seconds, fetch failed for a few minutes, then both stabilized. The `gh` credential helper fallback (HTTPS with `gh auth git-credential`) remains available if SSH fails again.
obs Final `core.sshCommand`: `ssh -F /dev/null -i <tree>/.ssh/id_ed25519_push -o IdentitiesOnly=yes -o UserKnownHostsFile=<tree>/.ssh/known_hosts_jail`. Single-stranded: one local git config variable per clone, pointing at that clone's own `.ssh/` directory.
obs Cleaned up the old symlinks and copied jail key files from `.ssh/`. The directory now holds only the fresh key pair and the GitHub known_hosts file.
obs Push and fetch both verified working after propagation settled.
file [.ssh/id_ed25519_push](../../.ssh/id_ed25519_push) fresh ed25519 key pair, passphrase-free, deploy key for xykj61/20260618-grain
file [.ssh/id_ed25519_push.pub](../../.ssh/id_ed25519_push.pub) public half, registered on GitHub with read-write access
recommend keep-going -- SSH auth is whole; the next orbit or task is Keaton's to name
