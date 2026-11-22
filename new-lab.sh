#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  basics|merge|stash|remote|rebase|bisect|recover) lesson=$1 ;;
  *) echo "Usage: bash new-lab.sh {basics|merge|stash|remote|rebase|bisect|recover}" >&2; exit 2 ;;
esac

lab=$(mktemp -d "${TMPDIR:-/tmp}/git-practice-$lesson.XXXXXXXX")
git init -q -b main "$lab/project"
cd "$lab/project"
git config user.name 'Git Practice'
git config user.email 'practice@example.invalid'
git config commit.gpgSign false
git config tag.gpgSign false

commit() {
  git add -A
  git commit -qm "$1"
}

printf 'Camp Lantern\n' > title.txt
printf 'Meeting time: 09:00\n' > schedule.txt
printf 'Water\nMap\n' > checklist.txt
commit 'Start the Camp Lantern trip plan'

case "$lesson" in
  basics)
    printf 'First-aid kit\n' >> checklist.txt
    printf 'Bring a spare battery.\n' > notes.txt
    ;;
  merge)
    git switch -qc feature/later-start
    printf 'Meeting time: 10:00\n' > schedule.txt
    commit 'Start the trip at ten'
    git switch -q main
    printf 'Meeting time: 08:30\n' > schedule.txt
    commit 'Start early to avoid traffic'
    ;;
  stash)
    git switch -qc feature/packing
    printf 'Flashlight\n' >> checklist.txt
    printf 'Confirm weather forecast.\n' > notes.txt
    ;;
  remote)
    git init -q --bare -b main "$lab/origin.git"
    git remote add origin "$lab/origin.git"
    git push -qu origin main
    git clone -q "$lab/origin.git" "$lab/teammate"
    (
      cd "$lab/teammate"
      git config user.name 'Practice Teammate'
      git config user.email 'teammate@example.invalid'
      git config commit.gpgSign false
      printf 'Trailhead car park\n' > location.txt
      commit 'Add the meeting location'
      git push -q
    )
    printf 'Leave a copy with the ranger.\n' > notes.txt
    commit 'Add a ranger note'
    ;;
  rebase)
    git switch -qc feature/packing
    printf 'Flashlight\n' >> checklist.txt
    commit 'Add a flashlight'
    printf 'Spare batteries\n' >> checklist.txt
    commit 'fixup: include batteries'
    git switch -q main
    printf 'Trailhead car park\n' > location.txt
    commit 'Add the meeting location'
    git switch -q feature/packing
    ;;
  bisect)
    git tag good
    printf 'Trailhead car park\n' > location.txt
    commit 'Add the meeting location'
    printf 'Flashlight\n' >> checklist.txt
    commit 'Add a flashlight'
    printf 'Water\nFlashlight\n' > checklist.txt
    commit 'Simplify the checklist'
    printf 'Camp Lantern Weekend\n' > title.txt
    commit 'Clarify the trip title'
    git tag bad
    ;;
  recover)
    git switch -qc feature/packing
    printf 'Flashlight\n' >> checklist.txt
    commit 'Add a flashlight'
    printf 'Spare batteries\n' >> checklist.txt
    commit 'Add spare batteries'
    ;;
esac

printf '%s\n' "$PWD"
