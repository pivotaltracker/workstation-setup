echo
echo "Creating Tracker git aliases"

git config --global alias.ci "duet-commit"
git config --global alias.dci "duet-commit"
git config --global alias.mg "duet-merge"
git config --global alias.dmg "duet-merge"
git config --global alias.dsff "!f() { [ "" != "" ] && cd ; git diff --color  | diff-so-fancy | less --tabs=4 -RFX; }; f"
git config --global alias.bdr "for-each-ref --sort=-committerdate refs/remotes/ --format='%(committerdate:short) %1B[0;31m%(refname:short)%1B[m'"
git config --global alias.bdl "for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %1B[0;31m%(refname:short)%1B[m'"
git config --global alias.please "push --force-with-lease"
