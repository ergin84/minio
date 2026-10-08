# Fork Status

This is **ergin84/minio**, a community-maintained fork of [minio/minio](https://github.com/minio/minio).

## Why this fork exists

The upstream `minio/minio` repository was declared unmaintained in late 2025 and archived on **April 25, 2026**. MinIO Inc. moved to a commercial product (AIStor) and stopped accepting community contributions to the open-source edition.

This fork keeps the AGPLv3 community edition alive with:
- Security patches and dependency updates
- Bug fixes from the 36 PRs orphaned at archival time
- A working release pipeline (Docker Hub + binary releases)

## Module path

The Go module was renamed from `github.com/minio/minio` to `github.com/ergin84/minio`.

Install from source:
```sh
go install github.com/ergin84/minio@latest
```

Docker:
```sh
docker pull ergin84/minio:latest
```

## Maintenance commitment

| Area | Policy |
|---|---|
| Security fixes | Applied as soon as practical |
| Upstream orphaned PRs | Evaluated and merged on a rolling basis |
| Go version | Kept current with upstream requirements |
| Dependencies | Updated when security advisories are published |
| New features | Accepted via PR; reviewed on best-effort basis |

Supported Go version: **1.25+**

## What diverges from upstream

### Infrastructure changes
- Module path renamed: `github.com/minio/minio` → `github.com/ergin84/minio`
- 18 CI workflows replaced with 4 lean ones (ci, release, sync-upstream, depsreview)
- Trivy security scanning added (filesystem scan on PR, image scan on release)
- Multi-arch Docker release pipeline (linux/amd64, linux/arm64) via `Dockerfile.fork`
- Binary releases for linux, darwin, windows (amd64 + arm64) on every tag
- Daily upstream sync workflow (now a no-op since upstream is archived)

### Bug fixes cherry-picked from orphaned upstream PRs

| Our commit | Upstream PR | Description |
|---|---|---|
| `7f0a4771` | [#21580](https://github.com/minio/minio/pull/21580) | `joinErrs()` always returned `""` — iterated over empty string instead of error slice |
| `7f0a4771` | [#21742](https://github.com/minio/minio/pull/21742) | Server shutdown returns 503 instead of 499 (client disconnected) |
| `7f0a4771` | [#21391](https://github.com/minio/minio/pull/21391) | Peers falsely marked offline when context deadline exceeded |
| `7f0a4771` | [#21482](https://github.com/minio/minio/pull/21482) | Disabling a user incorrectly required `EnableUser` permission |
| `7f0a4771` | [#21501](https://github.com/minio/minio/pull/21501) | `mc quota clear` called Update instead of Delete — quota clear never worked |

### Dependency updates from orphaned upstream PRs

| Package | Before | After | Upstream PR |
|---|---|---|---|
| `golang.org/x/crypto` | 0.37.0 | 0.49.0 | [#21701](https://github.com/minio/minio/pull/21701) |
| `github.com/go-jose/go-jose/v4` | 4.1.0 | 4.1.4 | [#21749](https://github.com/minio/minio/pull/21749) |
| `github.com/Azure/go-ntlmssp` | pseudo-version | 0.1.1 | [#21748](https://github.com/minio/minio/pull/21748) |
| `github.com/nats-io/nats-server/v2` | 2.11.1 | 2.11.15 | [#21750](https://github.com/minio/minio/pull/21750) |
| `github.com/eclipse/paho.mqtt.golang` | 1.5.0 | 1.5.1 | [#21713](https://github.com/minio/minio/pull/21713) |
| `go.opentelemetry.io/otel/sdk` | 1.35.0 | 1.43.0 | [#21751](https://github.com/minio/minio/pull/21751) |
| minimum Go version | 1.24 | 1.25 | (required by otel + nats) |

## Orphaned upstream PRs — status

The following PRs were open when upstream was archived. Evaluated and tracked here.

### Pending evaluation

| PR | Description | Status |
|---|---|---|
| [#21492](https://github.com/minio/minio/pull/21492) | Add disable-ssl flag for bucket replication | Blocked — needs madmin-go v3.0.111 (latest stable: v3.0.110) |

### Helm chart improvements (merged in `fa16a3c09`)

| PR | Description |
|---|---|
| [#21738](https://github.com/minio/minio/pull/21738) | Fix typos: `pof` → `pod`, `Additational` → `Additional` |
| [#21689](https://github.com/minio/minio/pull/21689) | Warning in NOTES.txt when existingClaim is ignored in distributed mode |
| [#21556](https://github.com/minio/minio/pull/21556) | Custom labels on Service, ConsoleService, ServiceAccount, PVC, post-job |
| [#21578](https://github.com/minio/minio/pull/21578) | Liveness / readiness / startup probes (disabled by default) |
| [#21591](https://github.com/minio/minio/pull/21591) | Move bearerTokenSecret to correct level in Probe spec |
| [#21245](https://github.com/minio/minio/pull/21245) | PDB supports minAvailable + uses templated name |
| [#21392](https://github.com/minio/minio/pull/21392) | automountServiceAccountToken control on ServiceAccount |
| [#21045](https://github.com/minio/minio/pull/21045) | domain parameter appended to all ingress hosts |
| [#20853](https://github.com/minio/minio/pull/20853) | Configurable ingress pathType (default: Prefix) |
| [#20795](https://github.com/minio/minio/pull/20795) | global.storageClass parameter overrides persistence.storageClass |
| [#18577](https://github.com/minio/minio/pull/18577) | Single-replica fix — no invalid `{0...0}` range syntax |
| [#21728](https://github.com/minio/minio/pull/21728) | OpenShift flag — disables SCC + omits user/group IDs from securityContext |

### Applied from pending evaluation (merged in `51417d00d`)

| PR | Author | Description |
|---|---|---|
| [#20784](https://github.com/minio/minio/pull/20784) | allanrogerr | Add SiteName to internal and external audit logs |
| [#21393](https://github.com/minio/minio/pull/21393) | dormanze | Make minimum part size configurable via `MINIO_MIN_PART_SIZE` env var |
| [#21664](https://github.com/minio/minio/pull/21664) | dormanze | AMQP notifications support TLS/mTLS |
| [#21255](https://github.com/minio/minio/pull/21255) | cmyrsh | STS X.509 authentication: use SAN URI instead of Common Name |
| [#21585](https://github.com/minio/minio/pull/21585) | mannreis | Federation functional test suite + Makefile `test-federation` target |

### Already merged or superseded

| PR | Status |
|---|---|
| [#21701](https://github.com/minio/minio/pull/21701) / [#21700](https://github.com/minio/minio/pull/21700) / [#21699](https://github.com/minio/minio/pull/21699) | Merged via dep update |
| [#21749](https://github.com/minio/minio/pull/21749) / [#21748](https://github.com/minio/minio/pull/21748) / [#21750](https://github.com/minio/minio/pull/21750) / [#21751](https://github.com/minio/minio/pull/21751) / [#21713](https://github.com/minio/minio/pull/21713) | Merged via dep update |
| [#21739](https://github.com/minio/minio/pull/21739) | Superseded — workflows replaced entirely |
| [#21580](https://github.com/minio/minio/pull/21580) / [#21742](https://github.com/minio/minio/pull/21742) / [#21391](https://github.com/minio/minio/pull/21391) / [#21482](https://github.com/minio/minio/pull/21482) / [#21501](https://github.com/minio/minio/pull/21501) | Cherry-picked |
| [#21560](https://github.com/minio/minio/pull/21560) | Superseded — upstream release script, not applicable to fork's release pipeline |
| [#21660](https://github.com/minio/minio/pull/21660) | Superseded — README typo already correct in fork |

## How to contribute

This fork follows the same contribution model as upstream. See [CONTRIBUTING.md](CONTRIBUTING.md).

To report security vulnerabilities, email **erginmehmeti@gmail.com** — see [SECURITY.md](SECURITY.md).

## Relationship to upstream

The last upstream commit included in this fork is `7aac2a2c5` (April 2026).
All commits after that point are fork-specific.

Upstream: https://github.com/minio/minio (archived, read-only)
