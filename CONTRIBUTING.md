# Contributing to Project Name

First off, thank you for taking the time to contribute! All forms of contributions are valued, from bug reports and feature suggestions to code changes.

This guide will walk you through the process of contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [I Have a Question](#i-have-a-question)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Your First Code Contribution](#your-first-code-contribution)
- [The Contribution Workflow](#the-contribution-workflow)
  - [Step 1: Fork the Project](#step-1-fork-the-project)
  - [Step 2: Work on Your Fork](#step-2-work-on-your-fork)
    - [Option A: Web-Based Editing](#option-a-web-based-editing-perfect-for-quick-docs-fixes)
    - [Option B: Local Development](#option-b-local-development-recommended-for-code-changes)
  - [Open a Pull Request (PR)](#open-a-pull-request-pr)
- [Style Guides](#style-guides)
  - [Commit Messages](#commit-messages)

## Code of Conduct

By participating in this project, you are expected to uphold a standard of respect and fairness towards all contributors. Be kind and constructive.

## I Have a Question

Before asking a question, please check the project's [README.md](./README.md) and the existing [GitHub Issues](https://github.com/Prathamesh-Godse/wordpress-server-scripts/issues) to see if your question has already been answered.

If your question is unique, you can open a new issue. Please use a clear title and description.

## How Can I Contribute?

### Reporting Bugs

- **Use the GitHub Issues search** to check if the bug has already been reported.
- If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/Prathamesh-Godse/wordpress-server-scripts/issues/new).
- **Be specific** in your report. Include:
  - Your operating system.
  - Steps to reproduce the bug.
  - What you expected to happen vs. what actually happened.
  - Screenshots or error messages, if possible.

### Suggesting Enhancements

- Check the issues list to see if the enhancement has already been suggested.
- Open a new issue and clearly describe the enhancement:
  - Why should this feature be added?
  - How should it work?
  - Any examples or mockups, if applicable.

### Your First Code Contribution

Unsure where to begin? Look for issues labeled `good first issue`. These are typically well-defined and easier to tackle for new contributors.

## The Contribution Workflow

This project uses a **Forking Workflow**. This means you will work on your own personal copy of the project. All changes must be submitted via a Pull Request (PR). You can follow these steps using the **command line** or **GitHub's web interface**.

### Step 1: Fork the Project

**Web Interface (Recommended for beginners):**
1.  Navigate to the main project page: `https://github.com/prathamesh-godse/wordpress-server-scripts`
2.  Click the **Fork** button in the top-right corner.
    

3.  On the "Create a new fork" screen, leave all defaults and click **Create fork**.
4.  You will be redirected to your personal copy of the repository at `https://github.com/[YOUR_USERNAME]/wordpress-server-scripts`.

> **In this Case:** If your GitHub username is `johndoe`, your fork will be at `https://github.com/johndoe/wordpress-server-scripts`

### Step 2: Work on Your Fork

You have two main paths now: **Web-Based Editing** (beginner friendly) or **Local Development**.

#### Option A: Web-Based Editing (Perfect for beginners)

This method allows you to make changes directly on GitHub without cloning.

1.  **Navigate to the File:** On your fork's page (`https://github.com/YOUR_USERNAME/wordpress-server-scripts`), browse to the file you want to edit.
2.  **Edit the File:** Click the pencil (**✏️**) icon in the top-right corner of the file view.
    

3.  **Make Your Changes:** Edit the file in the built-in editor.
4.  **Commit to a New Branch:** **This is the crucial step.** In the commit form at the bottom:
    *   Write a short, descriptive commit message (e.g., "Fix typo in README").
    *   **Select the option: "Create a new branch for this commit and start a pull request."**
    *   Give the branch a name (e.g., `patch-1` or `fix-typo`).
    

5.  **Click "Propose changes"**. This will take you directly to the **Step 8: Open a Pull Request** screen.

#### Option B: Local Development

**Step 2B: Clone Your Fork**
Clone your forked repository to your local machine to work on it.

**Command Line:**
```bash
git clone https://github.com/[YOUR_USERNAME]/wordpress-server-scripts.git
cd wordpress-server-scripts
```

**GitHub Desktop (GUI):**
1.  Install [GitHub Desktop](https://desktop.github.com/).
2.  Go to your fork on GitHub and click the green **Code** button, then select **Open with GitHub Desktop** to clone it.
3.  GitHub Desktop will open and guide you through choosing a local path to clone the repository.

**Step 3B: Set Upstream Remote (Sync Latest Changes)**
It's good practice to sync your local clone with the original project to avoid conflicts.

**Command Line:**
```bash
git remote add upstream https://github.com/[MY_USERNAME]/wordpress-server-scripts.git
```

**Step 4B: Create a Feature Branch**
**Always create a new branch for your work.**

**Command Line:**
```bash
git checkout -b feat/my-new-feature
```

**GitHub Desktop (GUI):**
1.  Click the **Current Branch** button in the top toolbar.
2.  Click **New Branch**.
3.  Enter a descriptive name (e.g., `fix-login-bug`) and click **Create Branch**.
    

**Step 5B: Make Your Changes**
Make your code or documentation changes on your new branch. Test them thoroughly.

**Step 6B: Commit Your Changes**

**Command Line:**
```bash
git add .
git commit -m "feat: add a new cool feature"
```

**GitHub Desktop (GUI):**
1.  All changes will appear in the left sidebar.
2.  Check the boxes next to the files you want to commit.
3.  Write a descriptive summary (commit message) at the bottom left.
4.  Click **Commit to [your-branch-name]**.
    

**Step 7B: Push to Your Fork**
Push your new branch to your forked repository on GitHub.

**Command Line:**
```bash
git push origin feat/my-new-feature
```

**GitHub Desktop (GUI):**
1.  Click the **Push origin** button in the top toolbar.
    

### Open a Pull Request (PR)

This step is the same regardless of how you made your changes.

1.  Go to **your fork** on GitHub (`https://github.com/YOUR_USERNAME/wordpress-server-scripts`).
2.  You will often see a yellow banner suggesting your recently pushed branch. Click **Compare & pull request**.
    

3.  **Alternatively,** you can:
    *   Go to the **Pull requests** tab.
    *   Click **New pull request**.
    *   Click **compare across forks**.
    *   Set the **base repository** to `ORIGINAL_PROJECT/main`.
    *   Set the **head repository** to `YOUR_FORK/your-feature-branch`.
4.  Ensure the PR is set up correctly. Fill in the title and description. Use the magic words **"Closes #123"** to link and close the issue you worked on.
5.  Click **Create pull request**.

The project maintainer will then review your PR. Thank you for your contribution!

## Style Guides

### Commit Messages

We follow the [Conventional Commits](https://www.conventionalcommits.org/) style. This helps automate generating changelogs.

- **Format:** `<type>(<scope>): <subject>`
- **Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
  
| Type     | Purpose                                                                                           | Example Commit Message                                 |
| :------- | :------------------------------------------------------------------------------------------------ | :----------------------------------------------------- |
| **`feat`**   | **A new feature** for the user, not a new feature for the build script. It's something that adds value. | `feat: add user profile page`                          |
| **`fix`**    | **A bug fix** for the user. This patches a problem in the existing codebase.                      | `fix: prevent crashing on invalid login attempt`       |
| **`docs`**   | **Documentation only changes.** Anything that affects the README, contributing guide, or code comments. | `docs: update API usage examples in README`            |
| **`style`**  | **Changes that do not affect the meaning of the code.** This is about formatting, white space, semi-colons, etc. | `style: format code with prettier`                     |
| **`refactor`** | **A code change that neither fixes a bug nor adds a feature.** It's restructuring code to make it better without changing its behavior. | `refactor: simplify user authentication logic`         |
| **`test`**   | **Adding missing tests or correcting existing tests.** This is about the test suite, not production code. | `test: add unit tests for calculateTotal function`     |
| **`chore`**  | **Updating build tasks, package manager configs, etc.; no production code change.** Maintenance tasks. | `chore: update GitHub Actions workflow` `chore: add new dependency` |

- **Example:**
  - `feat(auth): add login with Google OAuth`
  - `fix(api): correct user data validation error`
  - `docs: update installation instructions in README`
 <img width="1025" height="803" alt="image" src="https://github.com/user-attachments/assets/ca11111a-e8ae-454e-ac59-ef2cbb09a868" />
 


---

Thank you again for your contribution! Your effort makes the open-source community an amazing place.

---
