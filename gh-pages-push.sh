#!/usr/bin/env bash
set -Eeuo pipefail

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

git stash
git checkout master

git ls-files -z | xargs -0 rm -f
cp -a docs/. .

git add -u
git commit -m "medco-documentation compiled HTML update from script"
git push

git checkout "${CURRENT_BRANCH}"
git stash pop

# todo: some folders are not pushed?
# todo: what happens if push rejected?
