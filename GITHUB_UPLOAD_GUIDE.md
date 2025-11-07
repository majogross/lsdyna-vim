# GitHub Upload Guide for LS-DYNA Vim Plugin

This guide provides step-by-step instructions for uploading the LS-DYNA Vim plugin to your GitHub account.

## Prerequisites

Before you begin, ensure you have:
- A GitHub account (create one at https://github.com if you don't have one)
- Git installed on your system
- Command line access to your project directory

## Step 1: Create a New GitHub Repository

1. Go to GitHub.com and log in
2. Click the "+" icon in the top-right corner
3. Select "New repository"
4. Fill in the repository details:
   - Repository name: `lsdyna-vim` (or your preferred name)
   - Description: "Comprehensive Vim plugin for LS-DYNA input files with syntax highlighting, completion, and snippets"
   - Choose "Public" (recommended for open source) or "Private"
   - DO NOT initialize with README, .gitignore, or license (we already have these)
5. Click "Create repository"

## Step 2: Prepare Your Local Repository

Open your terminal and navigate to your project directory:

```bash
cd /proj/cae_muc/q667207/70_scripts
```

## Step 3: Initialize Git Repository

Initialize the git repository in your project directory:

```bash
git init
```

This creates a new Git repository in your current directory.

## Step 4: Configure Git (First Time Only)

If this is your first time using Git, configure your identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Replace "Your Name" and "your.email@example.com" with your actual name and email.

## Step 5: Add Files to Git

Add all the plugin files to the Git staging area:

```bash
git add .gitignore
git add README.md
git add LICENSE
git add GITHUB_UPLOAD_GUIDE.md
git add lsdyna.vim
git add lsdyna_ftdetect.vim
git add lsdyna_abbrev.vim
git add lsdyna_complete.vim
git add lsdyna_help.vim
git add lsdyna.snippets
git add LSDYNA_VIM_README.md
git add INSTALL.md
git add USAGE_GUIDE.md
git add ABBREVIATIONS_GUIDE.md
git add install.sh
git add check_vim_setup.sh
```

If you want to include the lsdyna directory with Python scripts:

```bash
git add lsdyna/
```

Verify what files are staged:

```bash
git status
```

## Step 6: Create Initial Commit

Commit the added files with a descriptive message:

```bash
git commit -m "Initial commit: LS-DYNA Vim plugin with syntax highlighting, completion, and snippets"
```

## Step 7: Connect to GitHub Repository

Add your GitHub repository as a remote (replace YOUR_USERNAME with your actual GitHub username):

```bash
git remote add origin https://github.com/YOUR_USERNAME/lsdyna-vim.git
```

For example, if your GitHub username is "johndoe":
```bash
git remote add origin https://github.com/johndoe/lsdyna-vim.git
```

Verify the remote was added correctly:

```bash
git remote -v
```

## Step 8: Push to GitHub

Push your code to GitHub:

```bash
git branch -M main
git push -u origin main
```

You will be prompted for your GitHub credentials:
- Username: Your GitHub username
- Password: Your GitHub personal access token (NOT your GitHub password)

Note: GitHub requires personal access tokens for authentication. If you don't have one:
1. Go to GitHub Settings > Developer settings > Personal access tokens
2. Click "Generate new token (classic)"
3. Select scopes: at minimum check "repo"
4. Generate and copy the token
5. Use this token as your password when pushing

## Step 9: Verify Upload

1. Go to your GitHub repository URL: `https://github.com/YOUR_USERNAME/lsdyna-vim`
2. You should see all your files listed
3. The README.md will be displayed automatically on the repository homepage

## Alternative: Using SSH (Recommended for Frequent Users)

If you prefer SSH authentication:

1. Generate an SSH key (if you don't have one):
```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
```

2. Add the SSH key to your GitHub account:
```bash
cat ~/.ssh/id_ed25519.pub
```
Copy the output and add it to GitHub: Settings > SSH and GPG keys > New SSH key

3. Use SSH remote URL instead:
```bash
git remote add origin git@github.com:YOUR_USERNAME/lsdyna-vim.git
```

4. Push as normal:
```bash
git push -u origin main
```

## Making Updates After Initial Upload

When you make changes to your plugin:

1. Check what files have changed:
```bash
git status
```

2. Add the modified files:
```bash
git add filename1 filename2
```
Or add all changes:
```bash
git add .
```

3. Commit the changes:
```bash
git commit -m "Description of changes made"
```

4. Push to GitHub:
```bash
git push
```

## Quick Reference Commands

```bash
# View current status
git status

# Add all changes
git add .

# Commit changes
git commit -m "Your commit message"

# Push to GitHub
git push

# Pull latest changes from GitHub
git pull

# View commit history
git log

# View remote repositories
git remote -v

# Create a new branch
git checkout -b branch-name

# Switch branches
git checkout branch-name
```

## Common Issues and Solutions

### Issue: Permission denied (publickey)

Solution: You need to set up SSH keys or use HTTPS with a personal access token.

### Issue: Remote origin already exists

Solution: Remove the existing remote and add it again:
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/lsdyna-vim.git
```

### Issue: Failed to push some refs

Solution: Pull the latest changes first:
```bash
git pull origin main --rebase
git push
```

### Issue: Large files being tracked

Solution: Use the .gitignore file (already created) to exclude large or unnecessary files.

## Creating a Release

To create a tagged release:

1. Create and push a tag:
```bash
git tag -a v1.0.0 -m "Version 1.0.0 - Initial release"
git push origin v1.0.0
```

2. On GitHub, go to your repository
3. Click "Releases" > "Create a new release"
4. Select your tag and add release notes

## Adding a Repository Description and Topics

On your GitHub repository page:

1. Click the gear icon next to "About"
2. Add a description: "Comprehensive Vim plugin for LS-DYNA input files"
3. Add topics: `vim`, `vim-plugin`, `lsdyna`, `syntax-highlighting`, `finite-element-analysis`, `cae`
4. Add website (if you have documentation hosted elsewhere)
5. Save changes

## Recommended Next Steps

After uploading:

1. Add repository topics for better discoverability
2. Enable Issues for user feedback
3. Consider adding a CONTRIBUTING.md file
4. Add GitHub Actions for automated testing (optional)
5. Share your repository with the LS-DYNA community

## Complete Command Sequence

Here's the complete sequence of commands for quick copy-paste:

```bash
# Navigate to your project
cd /proj/cae_muc/q667207/70_scripts

# Initialize git
git init

# Configure git (if first time)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Add all plugin files
git add .gitignore README.md LICENSE GITHUB_UPLOAD_GUIDE.md
git add lsdyna.vim lsdyna_ftdetect.vim lsdyna_abbrev.vim
git add lsdyna_complete.vim lsdyna_help.vim lsdyna.snippets
git add LSDYNA_VIM_README.md INSTALL.md USAGE_GUIDE.md ABBREVIATIONS_GUIDE.md
git add install.sh check_vim_setup.sh
git add lsdyna/

# Check status
git status

# Commit
git commit -m "Initial commit: LS-DYNA Vim plugin with syntax highlighting, completion, and snippets"

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/lsdyna-vim.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Getting Help

- Git documentation: https://git-scm.com/doc
- GitHub documentation: https://docs.github.com
- GitHub Support: https://support.github.com

## Congratulations

Your LS-DYNA Vim plugin is now on GitHub and available to the community!

Share your repository URL with colleagues and the LS-DYNA community to help others improve their workflow.