---
name: github-release-notes
description: Generate release notes and changelogs from GitHub deployments. Use this skill whenever the user asks to create release notes, changelogs, deployment summaries, or wants to know what was included in a release. Triggers include phrases like "generate release notes", "what was deployed", "create a changelog", "what's in this release", "summarise the deployment", or any reference to tracking changes between deployments or releases.
---

# GitHub Release Notes Generator

Generate comprehensive release notes by analysing the commits, pull requests, and changes between GitHub deployments.

## Prerequisites

The GitHub CLI (`gh`) must be authenticated. Verify with:

```bash
gh auth status
```

If not authenticated, run `gh auth login` first.

## Workflow Overview

1. **Identify the deployment range** - Find the two points to compare (e.g., last two prod deployments)
2. **Fetch commits between deployments** - Get all commits in the range
3. **Enrich with PR data** - Link commits to their pull requests for better context
4. **Categorise changes** - Group by type (features, fixes, chores, etc.)
5. **Generate formatted output** - Create markdown release notes

## Step-by-Step Instructions

### Step 1: Identify the Repository

Ask the user for the repository if not already known. Format: `owner/repo`

```bash
# Verify repo access
gh repo view {owner}/{repo} --json name,owner
```

### Step 2: Get Deployment History

Fetch recent deployments for the target environment:

```bash
# List recent deployments to an environment (e.g., prod, staging)
gh api repos/{owner}/{repo}/deployments \
  --jq '[.[] | select(.environment == "prod")] | .[0:5] | .[] | {id, sha, created_at: .created_at, environment}'
```

If the repo uses tags instead of deployments:

```bash
# List recent tags
gh api repos/{owner}/{repo}/tags --jq '.[0:5] | .[] | {name, sha: .commit.sha}'
```

### Step 3: Compare Two Points

Once you have two commit SHAs (or refs), compare them:

```bash
# Get commits between two SHAs
gh api repos/{owner}/{repo}/compare/{base_sha}...{head_sha} \
  --jq '.commits | .[] | {sha: .sha[0:7], message: .commit.message, author: .author.login, date: .commit.author.date}'
```

### Step 4: Enrich with Pull Request Data

For each commit, find the associated PR (if any):

```bash
# Find PR for a commit
gh api repos/{owner}/{repo}/commits/{sha}/pulls \
  --jq '.[] | {number, title, labels: [.labels[].name], author: .user.login}'
```

Or fetch all merged PRs in a date range:

```bash
# Get merged PRs between dates
gh pr list --repo {owner}/{repo} \
  --state merged \
  --base main \
  --json number,title,labels,author,mergedAt,body \
  --jq '.[] | select(.mergedAt >= "{start_date}" and .mergedAt <= "{end_date}")'
```

### Step 5: Categorise Changes

Group changes by conventional commit type or PR labels:

| Prefix/Label | Category | Emoji |
|--------------|----------|-------|
| `feat:` / `feature` | Features | ✨ |
| `fix:` / `bug` | Bug Fixes | 🐛 |
| `docs:` / `documentation` | Documentation | 📚 |
| `chore:` / `maintenance` | Maintenance | 🔧 |
| `refactor:` | Refactoring | ♻️ |
| `test:` | Tests | 🧪 |
| `perf:` / `performance` | Performance | ⚡ |
| `ci:` | CI/CD | 🔄 |
| `breaking` | Breaking Changes | 💥 |

### Step 6: Generate Release Notes

Format the output as markdown. Use this template:

```markdown
# Release Notes - {version or date}

**Deployment:** {environment}
**Date:** {deployment_date}
**Commits:** {base_sha[0:7]}...{head_sha[0:7]}

## Summary

{Brief 1-2 sentence summary of the release}

## What's Changed

### ✨ Features
- {PR title} (#{pr_number}) @{author}

### 🐛 Bug Fixes
- {PR title} (#{pr_number}) @{author}

### 🔧 Maintenance
- {PR title} (#{pr_number}) @{author}

## Contributors

{List of unique authors}

## Full Changelog

{link to GitHub compare view}
```

## Example Usage

**User prompt:** "Generate release notes for the last prod deployment"

**Execution:**

```bash
# 1. Get last two prod deployments
gh api repos/GetAddie/app/deployments \
  --jq '[.[] | select(.environment == "prod")] | .[0:2]'

# 2. Extract SHAs and compare
gh api repos/GetAddie/app/compare/{older_sha}...{newer_sha} \
  --jq '.commits'

# 3. Get associated PRs
gh pr list --repo GetAddie/app --state merged --json number,title,labels,author,mergedAt

# 4. Format and output
```

## Handling Edge Cases

### No Deployments Found

If the repo doesn't use GitHub deployments, fall back to:

- Git tags (for versioned releases)
- Merged PRs to main/master branch
- Recent commits to the default branch

### Private Repositories

Ensure the `gh` CLI is authenticated with appropriate permissions:

```bash
gh auth status
gh auth refresh -s repo
```

### Large Releases

For releases with many changes (50+ commits), consider:

- Grouping by component/area (if detectable from file paths)
- Highlighting the most significant changes
- Providing a summary with link to full diff

## Output Formats

The skill can generate release notes in several formats:

1. **Markdown** (default) - For GitHub releases, documentation
2. **Slack message** - Concise format for team notifications

Specify the desired format when invoking the skill.

## Quick Reference

```bash
# List environments
gh api repos/{owner}/{repo}/environments --jq '.environments[].name'

# Get latest deployment per environment
gh api repos/{owner}/{repo}/deployments --jq 'group_by(.environment) | .[] | .[0] | {environment, sha, created_at}'

# Compare branches
gh api repos/{owner}/{repo}/compare/main...staging --jq '.commits | length'

# Get PR details
gh pr view {number} --repo {owner}/{repo} --json title,body,labels,mergedAt
```
