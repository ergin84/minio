# Storvia Pro — Services Catalogue

> Commercial support and professional services for Storvia Object Storage.
> Contact: [erginmehmeti@gmail.com](mailto:erginmehmeti@gmail.com) · [erginmehmeti.it](https://erginmehmeti.it)

---

## Table of Contents

1. [Email SLA Support](#1-email-sla-support)
2. [Deployment Assistance](#2-deployment-assistance)
3. [Configuration & Performance Tuning](#3-configuration--performance-tuning)
4. [Security Hardening Review](#4-security-hardening-review)
5. [Architecture Review](#5-architecture-review)
6. [Integration Support](#6-integration-support)
7. [Upgrade Assistance](#7-upgrade-assistance)
8. [Custom Builds & Patches](#8-custom-builds--patches)
9. [Monitoring & Observability Setup](#9-monitoring--observability-setup)
10. [Compliance Documentation Package](#10-compliance-documentation-package)
11. [Team Training & Onboarding](#11-team-training--onboarding)
12. [Private CVE Notifications](#12-private-cve-notifications)

---

## 1. Email SLA Support

**What it is:** Priority email support with guaranteed response times from the maintainer who knows the codebase.

**Tiers:**

| Tier | Response Time (P0) | Response Time (General) | Price |
|---|---|---|---|
| Standard | < 8 h | < 48 h | **€199/month** |
| Pro | < 4 h | < 24 h | **€399/month** |
| Enterprise | < 1 h | < 8 h | **€899/month** |

P0 = service down, data inaccessible, or data integrity concern.

**What's included:**
- Unlimited email tickets
- Private Slack channel (Pro and above)
- 2 × 30-minute video calls/month (Pro), 4 × 1-hour (Enterprise)
- Access to internal issue tracker with priority labels

**How to get started:**
1. Send an email to [erginmehmeti@gmail.com](mailto:erginmehmeti@gmail.com) with subject `[Storvia Pro] Support Subscription`
2. Describe your environment (single node / distributed, OS, Storvia version)
3. Receive a support agreement and onboarding within 1 business day
4. Use the dedicated private Slack channel or email alias for all tickets

---

## 2. Deployment Assistance

**What it is:** Hands-on help getting Storvia running in your environment — bare metal, VM, Docker, or Kubernetes.

**Price:** **€350 flat fee** per deployment (up to 4 hours of sessions)

**What's covered:**
- Pre-deployment checklist (OS, filesystem, network)
- Docker Compose or Kubernetes Helm chart setup
- TLS certificate configuration
- MINIO_ROOT_USER / IAM initial setup
- Smoke-test validation (health endpoints, bucket creation, upload/download)

**Tutorial — Docker single-node:**
```bash
# 1. Pull the image
docker pull erginmehmeti/storvia:latest

# 2. Create a data directory on a volume with sufficient free space
mkdir -p /mnt/data

# 3. Run
docker run -d \
  --name storvia \
  -p 9000:9000 \
  -p 9001:9001 \
  -v /mnt/data:/data \
  -e MINIO_ROOT_USER=admin \
  -e MINIO_ROOT_PASSWORD=changeme \
  erginmehmeti/storvia:latest \
  storvia server /data --console-address ":9001"

# 4. Verify
curl http://localhost:9000/minio/health/live   # → 200 OK
```

**Tutorial — Kubernetes (Helm):**
```bash
helm install storvia oci://ghcr.io/ergin84/storvia \
  --version 1.2.0 \
  --set auth.rootUser=admin \
  --set auth.rootPassword=changeme \
  --set persistence.size=100Gi \
  --set service.type=LoadBalancer
```

---

## 3. Configuration & Performance Tuning

**What it is:** A structured session reviewing your Storvia configuration and tuning it for your specific workload (throughput-heavy, small-object-heavy, archival, AI/ML datasets, etc.).

**Price:** **€450 flat fee** (includes 2-hour video session + written report)

**What's covered:**
- Drive and filesystem selection (XFS recommended, direct I/O)
- Environment variable tuning (`MINIO_CACHE_*`, `MINIO_API_*`)
- Erasure coding set sizing (drives per set vs. redundancy vs. throughput)
- Network MTU and NIC bonding recommendations
- Benchmark baseline with `warp` or `s3bench`

**Tutorial — quick benchmark before/after:**
```bash
# Install warp (S3 benchmark tool)
go install github.com/minio/warp@latest

# Run a PUT benchmark (replace endpoint/keys)
warp put \
  --host=localhost:9000 \
  --access-key=admin \
  --secret-key=changeme \
  --bucket=benchmark \
  --obj.size=64MiB \
  --duration=60s \
  --concurrent=8

# Run a GET benchmark
warp get \
  --host=localhost:9000 \
  --access-key=admin \
  --secret-key=changeme \
  --bucket=benchmark \
  --duration=60s \
  --concurrent=8
```

**Key environment variables to tune:**
```bash
# Increase API concurrency for high-throughput workloads
MINIO_API_REQUESTS_MAX=10000
MINIO_API_REQUESTS_DEADLINE=10m

# Enable read-ahead for large sequential reads
MINIO_CACHE_DRIVES=/mnt/cache
MINIO_CACHE_EXPIRY=72
MINIO_CACHE_QUOTA=80
```

---

## 4. Security Hardening Review

**What it is:** A one-time review of your Storvia deployment's security posture with a written remediation report.

**Price:** **€599 flat fee** (includes 2-hour session + written report with remediation steps)

**What's covered:**
- TLS configuration audit (cipher suites, certificate validity, HSTS)
- IAM policy review (least privilege, service account hygiene)
- Network exposure audit (port exposure, firewall rules, VPC/VLAN isolation)
- Bucket policy review (public buckets, anonymous access)
- Encryption at rest (SSE-S3 / SSE-KMS / SSE-C)
- Audit log review
- MINIO_* environment variable secrets management (vault, k8s secrets)

**Tutorial — enable TLS:**
```bash
# 1. Generate or obtain a cert (example with self-signed for dev)
openssl req -x509 -newkey rsa:4096 -keyout private.key \
  -out public.crt -days 365 -nodes \
  -subj "/CN=storvia.yourdomain.com"

# 2. Place in Storvia certs dir
mkdir -p ~/.storvia/certs
cp public.crt ~/.storvia/certs/public.crt
cp private.key ~/.storvia/certs/private.key

# 3. Restart — Storvia auto-detects the certs
storvia server /data --console-address ":9001"
# API now at https://localhost:9000
```

**Tutorial — enforce IAM least privilege:**
```bash
# Create a read-only policy
cat > readonly-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["s3:GetObject", "s3:ListBucket"],
    "Resource": ["arn:aws:s3:::mybucket", "arn:aws:s3:::mybucket/*"]
  }]
}
EOF

mc admin policy create local readonly-policy readonly-policy.json
mc admin user add local readonly-user secret123
mc admin policy attach local readonly-policy --user readonly-user
```

---

## 5. Architecture Review

**What it is:** A consulting session designing the right Storvia topology for your use case before you build it.

**Price:** **€750 flat fee** (3-hour session + written architecture document)

**Topologies covered:**
- Single-node (dev/test, small teams)
- Multi-drive single-node (JBOD, up to 32 drives)
- Distributed multi-node (erasure coding across nodes)
- Active-active site replication (two datacenters)
- Hybrid: on-prem primary + cloud tier via lifecycle policies

**Tutorial — distributed 4-node setup:**
```bash
# On each of 4 nodes, run:
export MINIO_ROOT_USER=admin
export MINIO_ROOT_PASSWORD=changeme

storvia server \
  http://node1/mnt/data{1...4} \
  http://node2/mnt/data{1...4} \
  http://node3/mnt/data{1...4} \
  http://node4/mnt/data{1...4} \
  --console-address ":9001"

# This creates a 16-drive erasure set with N/2 redundancy (8 data, 8 parity)
# The cluster tolerates up to 8 drive failures before data loss
```

**Capacity planning formula:**
```
Usable capacity = Total raw capacity × (data shards / total shards)

Example: 16 × 4 TB drives, 8+8 erasure coding
Usable = 64 TB × (8/16) = 32 TB usable
```

---

## 6. Integration Support

**What it is:** Help connecting your applications, pipelines, or tools to Storvia's S3-compatible API.

**Price:** **€299/integration** (up to 3 hours per integration)

**Common integrations:**
- Python (boto3)
- Node.js (AWS SDK v3)
- Java (AWS SDK v2)
- Go (minio-go)
- Terraform (S3 backend)
- Rclone (sync/mirror)
- Restic (backup)
- Spark / Hadoop (s3a connector)
- PostgreSQL (pg_dump to S3)

**Tutorial — Python (boto3):**
```python
import boto3

s3 = boto3.client(
    "s3",
    endpoint_url="http://localhost:9000",
    aws_access_key_id="admin",
    aws_secret_access_key="changeme",
    region_name="us-east-1",   # Storvia accepts any region string
)

# Create bucket
s3.create_bucket(Bucket="my-bucket")

# Upload
s3.upload_file("local_file.txt", "my-bucket", "remote_file.txt")

# Download
s3.download_file("my-bucket", "remote_file.txt", "downloaded.txt")

# List
for obj in s3.list_objects_v2(Bucket="my-bucket")["Contents"]:
    print(obj["Key"], obj["Size"])
```

**Tutorial — Terraform S3 backend:**
```hcl
terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "prod/terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://storvia.yourdomain.com:9000"
    access_key                  = "admin"
    secret_key                  = "changeme"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
```

---

## 7. Upgrade Assistance

**What it is:** Guided upgrade from your current Storvia (or MinIO community) version to the latest, with a rollback plan.

**Price:** **€299 flat fee** per upgrade event

**What's covered:**
- Pre-upgrade health check (`mc admin info`, disk usage, replication lag)
- Compatibility check (format.json, xl.meta, MINIO_* env vars)
- Blue-green upgrade procedure (zero-downtime for distributed deployments)
- Post-upgrade validation
- Written rollback procedure in case of failure

**Tutorial — upgrade procedure (single-node Docker):**
```bash
# 1. Pre-upgrade health check
mc admin info local
mc admin heal local --recursive --dry-run

# 2. Pull the new image
docker pull erginmehmeti/storvia:v1.2.0

# 3. Stop the old container (graceful drain)
docker stop -t 30 storvia

# 4. Start the new one (same volume, same env)
docker run -d \
  --name storvia-new \
  -p 9000:9000 -p 9001:9001 \
  -v /mnt/data:/data \
  -e MINIO_ROOT_USER=admin \
  -e MINIO_ROOT_PASSWORD=changeme \
  erginmehmeti/storvia:v1.2.0 \
  storvia server /data --console-address ":9001"

# 5. Post-upgrade validation
curl http://localhost:9000/minio/health/live
mc ls local/   # verify all buckets visible
mc admin info local

# 6. Rollback if needed
docker stop storvia-new
docker start storvia   # back to old container
```

---

## 8. Custom Builds & Patches

**What it is:** A build of Storvia with specific patches, backports, or compile-time options applied for your environment.

**Price:** **€499 flat fee** per custom build (includes binary + Docker image + 30-day support for that build)

**Use cases:**
- Backport a security fix to an older version you're pinned to
- Apply a performance patch not yet in the upstream release
- Build with FIPS-compliant crypto (requires Go FIPS toolchain)
- Strip features you don't need to reduce attack surface
- Custom User-Agent string or branding for OEM purposes

**Tutorial — build from source with custom ldflags:**
```bash
git clone https://github.com/ergin84/storvia.git
cd storvia

# Custom version string
VERSION="v1.2.0-acme-custom"
COMMIT=$(git rev-parse HEAD)

go build -mod=vendor -tags kqueue -trimpath \
  -ldflags "-s -w \
    -X github.com/ergin84/storvia/cmd.Version=${VERSION} \
    -X github.com/ergin84/storvia/cmd.ReleaseTag=${VERSION} \
    -X github.com/ergin84/storvia/cmd.CommitID=${COMMIT}" \
  -o storvia .

./storvia --version
# storvia version v1.2.0-acme-custom
```

---

## 9. Monitoring & Observability Setup

**What it is:** End-to-end Prometheus + Grafana monitoring setup for your Storvia deployment.

**Price:** **€399 flat fee** (includes setup session + pre-built dashboard JSON)

**What's covered:**
- Enable Storvia Prometheus metrics endpoint
- Prometheus scrape config
- Pre-built Grafana dashboard (request rate, latency P99, disk usage, error rate, replication lag)
- Alert rules: disk > 80%, error rate spike, node down

**Tutorial — enable metrics:**
```bash
# 1. Create a Prometheus scrape user
mc admin user add local prometheus-user secret123
mc admin policy attach local prometheus --user prometheus-user

# 2. Get the bearer token
mc admin prometheus generate local

# 3. Add to prometheus.yml
scrape_configs:
  - job_name: storvia
    bearer_token: "<token-from-step-2>"
    metrics_path: /minio/v2/metrics/cluster
    scheme: http
    static_configs:
      - targets: ["localhost:9000"]
```

**Key metrics to alert on:**

| Metric | Alert threshold | Meaning |
|---|---|---|
| `minio_cluster_disk_free_bytes` | < 20% of total | Disk running low |
| `minio_s3_requests_errors_total` | rate > 1/s | Client error spike |
| `minio_cluster_nodes_offline_total` | > 0 | Node down |
| `minio_replication_sent_bytes` | stalled > 5 min | Replication lag |

---

## 10. Compliance Documentation Package

**What it is:** A written evidence package to support your internal SOC 2 or ISO 27001 audit, scoped to Storvia as your object storage component.

**Price:** **€799 flat fee** (one-time, updated on request with subscription)

**What's included:**
- Data flow diagram showing how objects enter/leave Storvia
- Encryption controls narrative (in-transit TLS, at-rest SSE)
- Access control description (IAM, bucket policies, audit logs)
- Backup and recovery procedure document
- Incident response runbook for storage layer
- Vendor risk assessment questionnaire (pre-filled for Storvia/AGPL)
- Evidence checklist mapped to SOC 2 Trust Service Criteria (CC6, CC7, A1)
- Evidence checklist mapped to ISO 27001 Annex A controls (A.8, A.12, A.14)

**Tutorial — enable audit logging (required for SOC 2 CC6.2):**
```bash
# Configure audit log to a webhook endpoint
mc admin config set local audit_webhook:compliance \
  endpoint="https://your-siem.example.com/storvia-audit" \
  auth_token="Bearer your-token" \
  client_cert="" \
  client_key=""

# Restart and verify
mc admin service restart local
mc admin info local | grep audit

# Each S3 API call now emits a structured JSON audit event:
# {"time":"...","api":{"name":"PutObject","bucket":"...","object":"..."},
#  "requestID":"...","remoteHost":"...","userAgent":"..."}
```

---

## 11. Team Training & Onboarding

**What it is:** Live training sessions for your team covering S3 concepts, Storvia administration, and day-2 operations.

**Price:**

| Format | Duration | Price |
|---|---|---|
| 1-on-1 session | 1 hour | **€150** |
| Team session (up to 8 people) | 3 hours | **€499** |
| Full-day workshop (up to 15 people) | 6 hours | **€999** |

**Topics available:**
- S3 fundamentals (buckets, objects, presigned URLs, multipart upload)
- Storvia administration (users, groups, policies, quotas)
- Bucket lifecycle policies (tiering, expiration)
- Versioning and object locking (WORM)
- Site replication concepts
- Developer integration (boto3, AWS SDK, mc CLI)
- Day-2 operations (monitoring, upgrades, disaster recovery)

**Tutorial — mc CLI quickstart (covered in all sessions):**
```bash
# Install mc
curl -LO https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc && sudo mv mc /usr/local/bin/

# Configure alias
mc alias set local http://localhost:9000 admin changeme

# Basic operations
mc mb local/my-bucket                          # create bucket
mc cp file.txt local/my-bucket/               # upload
mc ls local/my-bucket/                        # list
mc cat local/my-bucket/file.txt               # read
mc rm local/my-bucket/file.txt                # delete
mc du local/my-bucket/                        # disk usage

# Generate a presigned URL (expires in 7 days)
mc share download --expire=168h local/my-bucket/file.txt
```

---

## 12. Private CVE Notifications

**What it is:** Early notification of security vulnerabilities affecting Storvia before they are publicly disclosed, giving you time to patch or mitigate before attackers know.

**Price:** **€99/month** (standalone) · **Included** in all SLA Support tiers

**What's included:**
- Email notification within 24 h of a CVE being identified that affects Storvia
- Severity assessment (CVSS score, exploitability in your configuration)
- Mitigation steps or workaround while a patch is prepared
- Priority access to patched builds before public release

**Typical notification format:**
```
Subject: [Storvia Security] CVE-2026-XXXXX — HIGH — affects v1.x.x

Affected versions: v1.0.0 – v1.2.0
Component: <component name>
CVSS: 8.1 (HIGH)
Vector: AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:H

Summary:
  <brief description without exploitation details>

Impact on Storvia:
  <whether default config is affected, attack prerequisites>

Mitigation (until patch is available):
  <environment variable, firewall rule, or config change>

Patch ETA: <date>
Patched build: Available to subscribers at <link>
```

---

## Summary Pricing Table

| Service | Price |
|---|---|
| Email SLA Support — Standard | €199/month |
| Email SLA Support — Pro | €399/month |
| Email SLA Support — Enterprise | €899/month |
| Deployment Assistance | €350 flat |
| Configuration & Performance Tuning | €450 flat |
| Security Hardening Review | €599 flat |
| Architecture Review | €750 flat |
| Integration Support | €299/integration |
| Upgrade Assistance | €299 flat |
| Custom Builds & Patches | €499 flat |
| Monitoring & Observability Setup | €399 flat |
| Compliance Documentation Package | €799 flat |
| Team Training — 1-on-1 (1h) | €150 |
| Team Training — Team session (3h) | €499 |
| Team Training — Full-day workshop (6h) | €999 |
| Private CVE Notifications (standalone) | €99/month |

All prices are excluding VAT. Volume discounts available for multi-service engagements.
Contact [erginmehmeti@gmail.com](mailto:erginmehmeti@gmail.com) to discuss a custom package.
