# Git practice with Camp Lantern

You’re maintaining the trip plan for a camping group. The project has plain text files so you can focus on what Git does to the working tree, staging area, and history.

From the repository root, run this command to open a fresh exercise. Each run creates a new repository and prints its path. Your previous attempts remain in their own directories for the life of the machine.

```bash
lab=$(bash ./new-lab.sh basics) && cd "$lab"
git status --short
```

Replace `basics` with the exercise name to move on or repeat one. Run the commands that rewrite history only inside the generated practice repository. The remote exercise uses a local bare repository as `origin`.

## Basic

### 1. Stage and commit selectively (`basics`)

The checklist has a new line and there’s a new notes file. Inspect both with `git status --short` and use `git diff` to see the tracked change. Stage only the checklist, inspect `git diff --staged`, and commit it. Stage the notes, unstage them with `git restore --staged notes.txt`, then add and commit them separately. Create an annotated tag named `v1`.

**Check.** `git log --oneline -3` shows the two new commits, `git status --short` is empty, and `git show v1` shows the tag annotation and notes commit.

### 2. Resolve a merge conflict (`merge`)

You’re on `main`. Inspect the branch graph with `git log --all --graph --oneline`. Merge `feature/later-start` into `main`. Both branches changed the same line. Resolve the conflict by agreeing on `Meeting time: 09:30`, stage the resolution, and complete the merge.

**Check.** `git show -s --format=%P HEAD` prints two parents, and `cat schedule.txt` shows the agreed time with no conflict markers.

## Intermediate

### 3. Stash work for an urgent fix (`stash`)

You have a tracked checklist edit and an untracked notes file. Save both with `git stash push -u -m 'Packing draft'`. Switch to `main`, change the title to `Camp Lantern Weekend`, and commit the title update. Switch back to `feature/packing` and restore the draft using `git stash pop`.

**Check.** `git status --short` shows the checklist modification and untracked notes again. `git log -1 --oneline main` shows the title fix.

### 4. Fetch, inspect divergence, and integrate (`remote`)

You and a teammate each committed locally after the original push. Fetch using `git fetch origin` and inspect `git log --left-right --oneline main...origin/main`. Rebase your ranger note onto `origin/main`, then push. Inspect the teammate’s checkout at `../teammate` and bring it up to date with `git -C ../teammate pull --ff-only`.

**Check.** `git status -sb` shows no divergence, and `git rev-parse HEAD origin/main` prints the same commit twice. The teammate checkout contains both `notes.txt` and `location.txt`.

## Advanced

### 5. Clean up a feature branch (`rebase`)

Combine the flashlight and battery commits into one topical commit, replaying it on top of the current `main`. Use `git rebase -i main`. Leave the first line as `pick` and change the second to `fixup` to keep the first commit message. Switch to `main` and fast-forward with `git merge --ff-only feature/packing`.

**Check.** The resulting history has one packing commit after the location commit. Both flashlight and spare batteries appear in `checklist.txt`.

### 6. Find a regression with bisect (`bisect`)

The checklist used to include a map. Find the first commit where it stopped doing so. Start with `git bisect start bad good`, then run `git bisect run grep -qx Map checklist.txt`. Git treats a zero exit status as good and one as bad. Review the reported commit and return to your branch using `git bisect reset`.

**Check.** The first bad commit is `Simplify the checklist`. After resetting, `git branch --show-current` prints `main`.

### 7. Recover a commit, then undo it publicly (`recover`)

Start with a clean working tree and a feature branch with two packing commits. Simulate losing the tip with `git reset --hard HEAD~1`. Find the lost battery commit with `git reflog`, create a branch pointing to its hash using `git branch rescued HASH` (substitute the real hash), and fast-forward to it using `git merge --ff-only rescued`. Now assume someone else already uses this branch. Undo just the battery commit using `git revert --no-edit HEAD`.

**Check.** `git log --oneline -3` shows the revert, the recovered battery commit, and the flashlight commit. The checklist still contains the flashlight and no longer contains spare batteries. `git show rescued:checklist.txt` still shows the original battery change.
