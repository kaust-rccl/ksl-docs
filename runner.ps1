param(
    [switch]$c,
    [switch]$u,
    [switch]$h,
    [string]$Message
)

function Show-Help {
    Write-Output "Usage: .\docs.ps1 [-h] [-c] [-u] [-Message 'your commit message']"
    Write-Output " -c    Start a development environment for writing documentation"
    Write-Output " -u    Update and push new code to GitHub in dev branch. Please create a PR to upstream to main branch"
    exit
}

if ($h) {
    Show-Help
}

if (-not $Message) {
    $Message = "Update by $(git config --get user.name)"
}

if ($c) {
    Write-Output "Creating the docker container for development"
    git pull origin dev
    git checkout dev

    $existingContainer = docker ps -aq -f "name=ksl-docs"
    if ($existingContainer) {
        docker stop ksl-docs | Out-Null
        docker rm ksl-docs | Out-Null
    }

    docker pull krccl/ksl-docs:latest

    # Resolve absolute path and convert to Docker-friendly format
    $pwdPath = (Get-Location).Path -replace '\\','/'
    docker run --rm -ti --name ksl-docs -v "${pwdPath}:/workdir" -w /workdir/docs krccl/ksl-docs:latest
}

if ($u) {
    Write-Output "Committing and pushing codebase to GitHub in dev branch."
    git checkout dev
    git add docs/source/*
    git commit -m "$Message"
    git push -u origin dev
}