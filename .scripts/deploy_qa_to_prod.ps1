Write-Host "=== Starting governed QA → PROD deployment ==="

# ------------------------------------------------------------
# 1. Verify current branch is 'qa'
# ------------------------------------------------------------
$branch = git branch --show-current

if ($branch -ne "qa") {
    Write-Host "ERROR: Production deployments must be run from the 'qa' branch."
    exit 1
}

Write-Host "Current branch: $branch"

# ------------------------------------------------------------
# 2. Push QA branch
# ------------------------------------------------------------
git push --set-upstream origin $branch

# ------------------------------------------------------------
# 3. Create or fetch PR (qa → main)
# ------------------------------------------------------------
$prNumber = gh pr view $branch --json number --jq ".number" 2>$null

if (-not $prNumber) {
    Write-Host "No PR found. Creating PR from qa → main..."
    gh pr create --fill --base main --head qa
    $prNumber = gh pr view $branch --json number --jq ".number"
}

Write-Host "PR number: $prNumber"

# ------------------------------------------------------------
# 4. Run Slim CI simulation (QA environment)
# ------------------------------------------------------------
Write-Host "=== Running Slim CI simulation in QA ==="

dbt build `
    --target qa `
    --target-path "target/qa" `
    --select "state:modified+" `
    --state "target/prod" `
    --defer

$slimExit = $LASTEXITCODE

if ($slimExit -eq 0) {
    gh pr comment $prNumber --body "Slim CI (QA): **SUCCESS**"
    gh pr edit $prNumber --add-label "slim-ci-success"
    gh pr edit $prNumber --remove-label "slim-ci-failed"
} else {
    gh pr comment $prNumber --body "Slim CI (QA): **FAILED**"
    gh pr edit $prNumber --add-label "slim-ci-failed"
    gh pr edit $prNumber --remove-label "slim-ci-success"
    exit 1
}

# ------------------------------------------------------------
# 5. Run governed production deployment
# ------------------------------------------------------------
Write-Host "=== Deploying to PROD ==="

dbt build --target prod --target-path "target/prod"
$prodExit = $LASTEXITCODE

if ($prodExit -eq 0) {
    gh pr comment $prNumber --body "Deployment to PROD: **SUCCESS**"
    gh pr edit $prNumber --add-label "prod-success"
    gh pr edit $prNumber --remove-label "prod-failed"
} else {
    gh pr comment $prNumber --body "Deployment to PROD: **FAILED**"
    gh pr edit $prNumber --add-label "prod-failed"
    gh pr edit $prNumber --remove-label "prod-success"
    exit 1
}

Write-Host "=== QA → PROD deployment complete ==="