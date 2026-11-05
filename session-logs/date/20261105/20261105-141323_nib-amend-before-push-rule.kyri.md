format session-log-v1
stamp 20261105.141323
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Seat single-clone nib amend-before-push pattern in rule
prompt Keaton observed force-push is unnecessary when amend happens before push on a single-clone send; update the rule for declarative reproducibility
think The existing rule 2 describes the amend happening after the final rebase, with an implicit push-then-amend-then-force-push sequence shaped by fleet sends where peers can land mid-send. On a single-clone send with no rebase, HEAD~1 is known immediately after the commit, the amend rewrites only a local commit, and one push sends the final form -- no force-push needed.
think Added clause 2a to both .claude/rules/remember-git-nib.md and .cursor/rules/remember-git-nib.mdc with the single-clone pattern: commit -> update nib to HEAD~1 -> amend -> push once. The fleet pattern (push-then-amend-then-force-push) stays for contested sends where a rebase may intervene.
obs This is the pattern we have already been following on this clone. The rule now matches the practice, and the practice is declaratively reproducible from the repo rules.
[.claude/rules/remember-git-nib.md](../../.claude/rules/remember-git-nib.md) added clause 2a seating single-clone amend-before-push pattern
[.cursor/rules/remember-git-nib.mdc](../../.cursor/rules/remember-git-nib.mdc) Cursor twin updated with same clause 2a
recommend kg -- pull DJINN's grain-www emulator updates, then Orbit 13 multi-hart boot
