## Publish the history

Create an empty GitHub repository (no README, license or .gitignore). From the folder containing the bundle:

```sh
git -C VolunteerHub-git remote rename origin local-bundle
git -C VolunteerHub-git remote add origin https://github.com/ABDULRAHMAN-ALAATEQ/VolunteerHub.git
git -C VolunteerHub-git push -u origin main
```

To retain the historical feature branches on GitHub, run `git -C VolunteerHub-git branch -r` and for each feature branch run e.g.:

```sh
git -C VolunteerHub-git push origin refs/remotes/local-bundle/feature/opportunities:refs/heads/feature/opportunities
```

Repeat for `feature/hours-certificates`, `feature/interface-tests` and `feature/delivery` as present. If a branch is already merged, GitHub cannot create a meaningful new PR for that already-integrated change. Do not manufacture retroactive reviews. Use the next genuine work (e.g. runtime validation/fixes, instructor change or acceptance documentation) on a new feature branch.

```sh
git switch -c feature/runtime-validation
# Install dependencies, run tests, fix any actual issues, record results.
git add Gemfile.lock docs
# Also add any source files genuinely modified.
git commit -m "Validate application locally and record test results"
git push -u origin feature/runtime-validation
```

On GitHub open a pull request from this branch into main, inspect Files changed, record a self-review checklist in the PR description or comment, and request an instructor review if appropriate. GitHub does not permit authors to approve their own PR as an independent reviewer; distinguish documented self-review from independent review. Merge only when the work is checked. Repeat for the actual client change if one is supplied.
