# Contributing

We follow the [GitHub Workflow](https://guides.github.com/introduction/flow/).

## Install Hub

```bash
$ brew install hub
```

For more information regarding [Hub](hub.github.com/).

## Workflow

1. Create a new local branch for the feature/fix/chore that will address the issue.
2. Create at least one commit in that branch.
3. Push the branch to GitHub.
4. Convert the issue to a PR:

  ```bash
  hub pull-request -i 999`
  ```
  where 999 is the issue number.

_Important_: make sure your local branch is checked out and you are not in master.
