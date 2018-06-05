# CONTRIBUTING

This repo configures an OS X machine for Pivotal Tracker development. It was originally
forked from [Pivotal/workstation-setup](https://github.com/Pivotal/workstation-setup).

Please follow the guidelines in this doc when modifying it, to stay up-to-date with the upstream and miminize the chances of merge conflicts.

# Original upstream `pivotal-workstation` goals and anti-goals

* [original upstream goals here.](README.md#goals)
* [original upstream anti-goals here.](README.md#anti-goals)

# Tracker-specific goals, anti-goals, and principles

* TODO: Add our own custom goals/antigoals/etc from the inception

## How to make changes to this repo

### Guiding Principles

Principles when maintaining/changing this repo, to minimize merge conflicts when rebasing:

1. Make only absolutely necessary changes to upstream.  If it installs something we
   don't use, but it doesn't hurt anything, leave it alone.
1. If you do need to make changes, make them minimal and in a way that minimizes
   the chance of merge conflicts (e.g. this is a separate readme, rather than modifying
   the original one).

### Git workflow

1. Add the upstream as a remote to your repo: `git remote add upstream https://github.com/pivotal-legacy/workstation-setup`
1. Always ensure the upstream remote is up to date before doing anything: `git fetch --all`
1. Keep commits minimal and clean via `git rebase -i $(git merge-base HEAD upstream/master)`.  E.g., if you have five
   updates to the README_TRACKER.md in a row, squash 'em down.
1. `git push --force-with-lease`   
1. Rebase against the upstream often, and before changes: `git rebase upstream/master`
1. `git push --force-with-lease`   
