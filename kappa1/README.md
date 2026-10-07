# Branch `kappa1`

espanso `dev` plus a few fixes, used daily on macOS 26 and tested to start on macOS 27. Version string: `2.4.1-kappa1`.
Each change is offered upstream as a separate pull request; once merged, this branch is no longer needed.

| Change | Issue |
|---|---|
| New option `undo_backspace_presses: 2` — revert an expansion only on two quick Backspace presses (≤ 400 ms, key released in between; auto-repeat never counts). Default `1` = unchanged behaviour | #1665 |
| Backspace right after an expansion clears the match buffer instead of popping back into the typed trigger (next word trigger fired no more) | #1643 |
| Option/Ctrl/Cmd+Backspace clear the buffer and never trigger an undo | #1496, #2784 |
| Undo no longer re-types the left separator of word triggers; undo backspaces counted in graphemes | #1081, #1157 |
| `auto_restart` also watches symlink targets inside the config dir (match/config linked into a git repo) | #2249, #923 |
| `base.yml` is only seeded into an empty match directory | — |
| Included upstream PRs: buffer invalidation on modifier shortcuts, macOS paste modifier flags, worker respawn | #2818, #2763, #2725 |

Build (macOS): `cargo build --no-default-features --features modulo,native-tls --release && bash scripts/create_bundle.sh target/release/espanso && codesign --force --deep -s - target/mac/Espanso.app`.
`install.sh` / `revert.sh` swap `/Applications/Espanso.app` with a backup of the original. An ad-hoc signed build needs
the Accessibility permission again after every rebuild (the scripts reset the stale entry with `tccutil`).
