# Kubernetes Rolling Updates

## Concepts
- **Deployment**: Manages the rollout.
- **ReplicaSet**: Ensures Pod count.
- **RollingUpdate**: `maxSurge` and `maxUnavailable` control the update speed.

## Commands
- `kubectl set image deployment/<name> <container>=<image>`: Update image.
- `kubectl rollout status deployment/<name>`: Watch the update.
- `kubectl rollout undo deployment/<name>`: Instant rollback.
- `kubectl rollout history deployment/<name>`: View versions.

## What I Learned
- Zero-downtime deployments are native to K8s.
- If a new version fails to start, K8s keeps the old version running.
