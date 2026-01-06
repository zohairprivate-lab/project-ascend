# How to Push Your Code

The error `Repository not found` means the repository has not been created on the GitHub website yet.

### Step 1: Create Repository
1.  Open your browser and sign in to GitHub.
2.  Go to: [https://github.com/new](https://github.com/new)
3.  **Repository name**: `project-ascend`
4.  **Privacy**: Public (Private works too, but Public is easier).
5.  **Initialize**: Do **NOT** check "Add a README", "Add .gitignore", or "Choose a license". Leave them all unchecked.
6.  Click **Create repository**.

### Step 2: Push Code
Once created, come back to this terminal and run:

```powershell
git push -u origin main
```

### Step 3: Get Your APK
1.  Click on the **Actions** tab in your new repository.
2.  Select **Android Release**.
3.  Wait for the build (Green checkmark).
4.  Download the **app-release** from the Artifacts section.
