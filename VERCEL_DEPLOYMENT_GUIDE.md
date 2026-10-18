# 🚀 Vercel Deployment Guide — Hashir Shaikh Portfolio

This personal portfolio is built using **Flutter Web** and is fully pre-configured for deployment on **Vercel** with the output directory `build/web`.

---

## Method 1: Git-Connected Deployment via Vercel Dashboard (Recommended)

1. **Push your repository to GitHub**:
   ```bash
   git remote add origin https://github.com/hashir1006/<your-repo-name>.git
   git branch -M main
   git push -u origin main
   ```

2. **Import to Vercel**:
   - Go to [vercel.com/new](https://vercel.com/new).
   - Sign in with your GitHub account.
   - Click **Import** on the `Hashir Portfolio` repository.

3. **Configure Project Settings**:
   - **Framework Preset**: Select `Other`.
   - **Build Command**: `bash vercel-build.sh` (already pre-configured in `vercel.json`).
   - **Output Directory**: `build/web` (already pre-configured in `vercel.json`).
   - Click **Deploy**.

4. **Public URL**:
   - Vercel will build and assign you a free HTTPS URL: `https://<your-project-name>.vercel.app`.
   - You can also bind a custom domain anytime in Vercel Project Settings > Domains.

---

## Method 2: Instant CLI Deployment (Pre-built Release)

If you prefer deploying your local production build in seconds without building Flutter inside Vercel's container:

1. Build the production bundle locally:
   ```bash
   flutter build web --release
   ```

2. Deploy using the Vercel CLI:
   ```bash
   npx vercel --prod
   ```

3. When prompted:
   - *Set up and deploy?* **Y**
   - *Which scope?* (Select your account)
   - *Link to existing project?* **N**
   - *What's your project's name?* `hashir-portfolio`
   - *In which directory is your code located?* `./`

Vercel will upload and publish `build/web` instantly.

---

## Build Pipeline & Verification Sequence

Before pushing to production, verify locally:
```bash
flutter pub get
flutter analyze
flutter test
flutter build web --release
```
All static analysis checks and automated tests pass with 0 warnings or errors.
