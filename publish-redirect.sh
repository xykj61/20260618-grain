#!/usr/bin/env sh
# publish-redirect.sh -- force-push xykj61/grain as a redirect to the dated repo.
#
# The redirect/ directory holds the content (a README pointing at the living
# tree). This script wipes redirect/.git, inits a fresh orphan, commits
# unsigned under the maintainer's own identity, and force-pushes.
#
#   sh publish-redirect.sh            # prepare and show -- STOP before push
#   sh publish-redirect.sh --push     # the same, then force-push
#
# The pattern follows publish-seed.sh: the bare form cannot publish.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$ROOT"
[ -f construction/ITINERARY.md ] || { echo "publish-redirect: $ROOT is not the field root" >&2; exit 2; }

PUSH=no
if [ "${1:-}" = "--push" ]; then PUSH=yes; fi
if [ "${1:-}" != "--push" ] && [ -n "${1:-}" ]; then
    echo "publish-redirect: unknown argument (want --push, or nothing)" >&2; exit 2
fi

SSH_CONF="$ROOT/.git/ssh_config_jail"
[ -f "$SSH_CONF" ] || SSH_CONF="$ROOT/.git/ssh_config_urbit"
if [ ! -f "$SSH_CONF" ]; then
    echo "publish-redirect: no ssh config found at .git/ssh_config_jail or .git/ssh_config_urbit" >&2
    echo "publish-redirect: export GIT_SSH_COMMAND yourself if needed" >&2
else
    export GIT_SSH_COMMAND="ssh -F $SSH_CONF"
fi

# The target repo the redirect points at.
TARGET_REPO="xykj61/20260618-grain"
TARGET_URL="https://github.com/$TARGET_REPO"
REMOTE_URL="git@github.com:xykj61/grain.git"

echo "publish-redirect: wiping redirect/.git ..."
rm -rf redirect/.git

echo "publish-redirect: initializing orphan repo in redirect/ ..."
git init -q -b main redirect 2>/dev/null || {
    git init -q redirect
    git -C redirect symbolic-ref HEAD refs/heads/main
}

# Unsigned on purpose -- same reasoning as the seed: signing would link
# the anonymous pointer back to the maintainer's key.
git -C redirect config commit.gpgsign false
git -C redirect config user.name "Keaton Dunsford"
git -C redirect config user.email "keaton@grain-ww.com"

git -C redirect add -A
git -C redirect commit -q -m "redirect to $TARGET_URL"

HEAD_HASH=$(git -C redirect rev-parse --short=10 HEAD)
echo "publish-redirect: redirect commit $HEAD_HASH ready"
echo "publish-redirect: points at $TARGET_URL"

if [ "$PUSH" = "no" ]; then
    echo "publish-redirect: DRY RUN -- pass --push to force-push to $REMOTE_URL"
    exit 0
fi

git -C redirect remote add origin "$REMOTE_URL" 2>/dev/null || true
echo "publish-redirect: force-pushing to $REMOTE_URL ..."
git -C redirect push --force origin main 2>&1
echo "publish-redirect: done -- $REMOTE_URL now points at $TARGET_URL"
