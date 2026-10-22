# CD Pipeline with Approval Gates

## Pipeline Flow
1. Build → creates Docker image
2. Deploy Staging → automatic
3. Deploy Production → requires approval

## Environments
| Environment | Approval | Secrets |
|-------------|----------|---------|
| staging | Automatic | STAGING_API_KEY |
| production | Required | PROD_API_KEY |

## Deployment Strategies
- **Rolling** — Default, updates servers one at a time
- **Blue/Green** — Documented, would require two environments
- **Canary** — Documented, would require traffic splitting

## Rollback Procedure
1. Go to Actions → Rollback workflow
2. Enter the version to rollback to
3. Approve

## Lessons Learned
- Approval gates prevent accidental production deploys
- Environment-scoped secrets prevent cross-contamination
- Rollback is as important as forward deploy
- Every deployment should be logged
