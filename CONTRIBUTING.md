# Contributing to Storvia

[![Slack](https://img.shields.io/badge/slack-storvia-blue?logo=slack)](https://storvia.slack.com)
[![Docker Pulls](https://img.shields.io/docker/pulls/erginmehmeti/storvia.svg?maxAge=604800)](https://hub.docker.com/r/erginmehmeti/storvia)

The Storvia community welcomes your contribution. To make the process as seamless as possible, please read this guide before opening a pull request.

## Community

Join us on Slack: **[storvia.slack.com](https://storvia.slack.com)**

Use Slack for questions, ideas, and real-time discussion. Use GitHub Issues for reproducible bugs and feature requests that warrant tracking.

## Development Workflow

Start by forking the repository, make changes in a branch, and then send a pull request. We encourage pull requests to discuss code changes.

### 1. Fork and clone

Fork [ergin84/storvia](https://github.com/ergin84/storvia/fork), then clone your fork:

```sh
git clone https://github.com/<your-username>/storvia
cd storvia
go install -v
ls $(go env GOPATH)/bin/storvia
```

### 2. Add the upstream remote

```sh
git remote add upstream https://github.com/ergin84/storvia
git fetch upstream
git merge upstream/master
```

### 3. Create a feature branch

```sh
git checkout -b my-new-feature
```

### 4. Make your changes

- Add test cases for new code. If you have questions, ask on [Slack](https://storvia.slack.com).
- Run `make verifiers` to check formatting and linting.
- Run `make test` and `make build` to verify correctness.
- Squash your commits into a single logical commit (`git rebase -i`). It's fine to force-update your pull request branch.

### 5. Commit

Write a clear commit message — [this post](https://chris.beams.io/posts/git-commit/) explains what makes a good one.

```sh
git commit -am 'Add some feature'
```

### 6. Push and open a pull request

```sh
git push origin my-new-feature
```

Then open a pull request from your fork against `ergin84/storvia:master`. After peer review and approval it will be merged.

## FAQs

### How does Storvia manage dependencies?

Storvia uses `go mod`.

```sh
# Add a dependency
go get foo/bar

# Remove a dependency
# 1. Remove the import from source
# 2. Then run:
go mod tidy
```

### What are the coding guidelines?

Storvia follows standard Go style. See [Effective Go](https://go.dev/doc/effective_go) and the [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments). If you spot offending code, feel free to send a pull request or raise it on [Slack](https://storvia.slack.com).

### Compatibility constraints

Please preserve the following on-disk identifiers — changing them would break existing data volumes:

| Identifier | Must stay |
|---|---|
| `.minio.sys` bucket | unchanged |
| `xl.meta` format | unchanged |
| `format.json` | unchanged |
| `MINIO_*` environment variables | unchanged |

See [MIGRATION.md](MIGRATION.md) for the full compatibility table.
