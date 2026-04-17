Write-Host "=== Starting Slim CI workflow (feature → QA) ==="

# ------------------------------------------------------------
# 1. Detect current branch and enforce safety rules
# ------------------------------------------------------------
$branch = git branch --show-current

if ($branch -eq "main" -or $branch -eq "qa") {
    Write-Host "ERROR: Slim CI cannot run on 'main' or 'qa'."
    Write-Host "Run Slim CI only from a feature branch."
    exit 1
}

Write-Host "Current branch: $branch"

# ------------------------------------------------------------
# 2. Push feature branch
# ------------------------------------------------------------
git push --set-upstream origin $branch

# ------------------------------------------------------------
# 3. Create or fetch PR (feature → qa)
# ------------------------------------------------------------
$prNumber = gh pr view $branch --json number --jq ".number" 2>$null

if (-not $prNumber) {
    Write-Host "No PR found. Creating PR from $branch → qa..."
    gh pr create --fill --base qa --head $branch
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

# ------------------------------------------------------------
# 5. Update PR with Slim CI results
# ------------------------------------------------------------
if ($slimExit -eq 0) {
    gh pr comment $prNumber --body "Slim CI (feature → QA): **SUCCESS**"
    gh pr edit $prNumber --add-label "slim-ci-success"
    gh pr edit $prNumber --remove-label "slim-ci-failed"
} else {
    gh pr comment $prNumber --body "Slim CI (feature → QA): **FAILED**"
    gh pr edit $prNumber --add-label "slim-ci-failed"
    gh pr edit $prNumber --remove-label "slim-ci-success"
    exit 1
}

Write-Host "=== Slim CI workflow complete ==="