# Day 14 Assignment: Enterprise Docker Pipeline in GitHub Actions

## Architecture Topology Diagram
```text
[ Developer Push ]
       │
       ▼
┌─────────────────────────────────────────┐
│ Job 1: run-unit-tests                   │
│ ──► Lint Python & Static Compile Check  │
└───────────────────┬─────────────────────┘
                    │ (needs: pass)
                    ▼
┌─────────────────────────────────────────┐
│ Job 2: build-test-scan                  │
│ ──► Buildx Compile Image                │
│ ──► Trivy Vulnerability Scan Gate       │
│ ──► Docker Hub Immutable Tag Push       │
└─────────────────────────────────────────┘
```

## Key Concept Explanations
* **Fail-Fast Job Splitting:** Python syntax checks execute inside a lightweight isolation worker before triggering Docker compilation layers. This avoids infrastructure billing waste on broken application files.
* **Immutable Registry Tagging:** Containers are signed directly using the immutable Git Commit SHA alongside a clean `v1.0.0` semantic version tag, eliminating reliance on shifting `latest` indicators.
* **Trivy Compliance Gating:** The delivery stage uses an automated security vulnerability scanning scanner configured with `exit-code: 1` to halt code pushes if critical security flaws are introduced.

## Operational Deployment & Rollback Playbook
If an active service incident occurs during production orchestration, restoration relies strictly on immutable artifact swapping rather than code patches:

### Manual Rollback Procedure
1. Pull the targeted, historical known-good deployment identifier from the remote registry store:
   ```bash
   docker pull YOUR_DOCKERHUB_USERNAME/winter-arc-app:PREVIOUS_GOOD_SHA
   ```
2. Destroy the malfunctioning runtime instance immediately:
   ```bash
   docker rm -f winter-app || true
   ```
3. Instantiate the validated secure historical revision layer back into operational status:
   ```bash
   docker run -d --name winter-app -p 5000:5000 --restart unless-stopped YOUR_DOCKERHUB_USERNAME/winter-arc-app:PREVIOUS_GOOD_SHA
   ```

## Production Troubleshooting Ledger
* **Symptom: Workflow Initialization Blocked**
  * *Resolution Criteria:* Ensure accurate directory mappings conform precisely to `.github/workflows/docker-ci.yml`.
* **Symptom: Trivy Action Step Interrupted (`Set up job` error)**
  * *Resolution Criteria:* Deprecated structural tags from dependency drifts resolved completely by updating resource tags from legacy `0.28.0` formats to stable `v0.35.0` parameters.
