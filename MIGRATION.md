# Migration Guide

This document covers migrating to Storvia from previous distributions.

---

## 1. Migrating from upstream `minio/minio`

The upstream `minio/minio` repository was archived in April 2026. Storvia is a
direct continuation of the community edition codebase.

**Your data is safe.** Storvia reads the same on-disk format.

### Docker

```sh
# Stop the old container
docker stop minio

# Start Storvia using your existing volume
docker run -d \
  --name storvia \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=<existing-root-user> \
  -e MINIO_ROOT_PASSWORD=<existing-root-password> \
  -v <existing-volume>:/data \
  erginmehmeti/storvia:latest \
  server /data --console-address ":9001"
```

### Binary

Replace the `minio` binary with the `storvia` binary from
[GitHub Releases](https://github.com/ergin84/storvia/releases).

All `MINIO_*` environment variables, configuration files, and data directories
are unchanged — no migration is required.

```sh
# Old
minio server /data --console-address ":9001"

# New
storvia server /data --console-address ":9001"
```

---

## 2. Migrating from `erginmehmeti/minio`

This is an in-place rename. Replace the image name and binary name only.

```sh
docker pull erginmehmeti/storvia:latest
```

Use your existing data volumes and environment variables unchanged.

---

## 3. Environment variables

All `MINIO_*` environment variables are preserved without any changes.

| Variable | Status |
|---|---|
| `MINIO_ROOT_USER` | Unchanged — fully supported |
| `MINIO_ROOT_PASSWORD` | Unchanged — fully supported |
| `MINIO_VOLUMES` | Unchanged — fully supported |
| `MINIO_SERVER_URL` | Unchanged — fully supported |
| `MINIO_BROWSER_REDIRECT_URL` | Unchanged — fully supported |
| All other `MINIO_*` variables | Unchanged — fully supported |

---

## 4. Migrating a Helm installation

> **Important:** The Storvia Helm chart (`helm/storvia`) is a new chart with
> a new chart name. It is not an in-place upgrade of the `minio` chart.
> Changing chart names, resource names, or selector labels can disconnect
> existing PVCs and cause data loss.

### Approach A — Fresh install alongside existing (recommended for production)

1. Install the Storvia chart as a new release in a different namespace.
2. Use [MinIO Mirror](https://min.io/docs/minio/linux/reference/minio-mc/mc-mirror.html) (`mc mirror`) to replicate data.
3. Switch traffic to the new release.
4. Decommission the old release.

### Approach B — In-place chart upgrade (development/testing only)

> Only safe if you understand that selector labels will change and PVCs may
> be recreated. Do NOT use this approach in production without a tested backup.

```sh
# Export data first
mc mirror old-alias/ backup/

# Uninstall old chart (PVCs will remain by default if reclaimPolicy=Retain)
helm uninstall minio -n <namespace>

# Install Storvia chart
helm install storvia oci://ghcr.io/ergin84/storvia \
  --version <version> \
  --namespace <namespace> \
  --set rootUser=<root-user> \
  --set rootPassword=<root-password>

# Restore data if needed
mc mirror backup/ new-alias/
```

---

## 5. Rollback

Storvia makes no changes to on-disk format. Rolling back to a previous MinIO
or `erginmehmeti/minio` image requires only reverting the container image tag.

```sh
docker run -d \
  --name minio \
  -v <existing-volume>:/data \
  erginmehmeti/minio:latest \
  server /data
```

---

## 6. S3 client compatibility

All S3-compatible clients continue to work without any configuration changes.
The S3 API endpoints, headers, and authentication mechanisms are unchanged.

---

## 7. Compatibility identifiers that are intentionally unchanged

The following internal identifiers are preserved to ensure data compatibility:

| Identifier | Value | Why kept |
|---|---|---|
| Metadata bucket | `.minio.sys` | On-disk format identifier |
| Config directory | `.minio` | Configuration path |
| Object metadata | `xl.meta` | Per-object metadata file |
| Storage format | `format.json` | Erasure set format descriptor |
| Environment variables | `MINIO_*` | Drop-in compatibility |

Modifying any of these would make existing data directories unreadable.
