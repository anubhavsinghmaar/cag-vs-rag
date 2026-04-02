#!/bin/bash

# ============================================
# RAG vs CAG — GitHub + Netlify Setup Commands
# ============================================

# STEP 1: Create a new repo on GitHub
# Go to https://github.com/new
# Name: rag-vs-cag
# Description: RAG vs CAG live comparison tool. Same model, same data, different architecture.
# Make it PUBLIC (so Netlify can access it)
# Do NOT initialize with README (we already have one)

# STEP 2: Initialize git and push
cd rag-vs-cag

git init
git add .
git commit -m "feat: RAG vs CAG live comparison tool with Gemini 3 Flash"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/rag-vs-cag.git
git push -u origin main

# ============================================
# STEP 3: Deploy on Netlify
# ============================================
# Option A: Netlify UI (easiest)
#   1. Go to https://app.netlify.com
#   2. Click "Add new site" > "Import an existing project"
#   3. Connect GitHub > Select "rag-vs-cag" repo
#   4. Build settings:
#        Base directory: (leave empty)
#        Build command: (leave empty)
#        Publish directory: .
#   5. Click "Deploy site"
#   6. Your site is live! Grab the URL.
#
# Option B: Netlify CLI
#   npm install -g netlify-cli
#   netlify login
#   netlify init
#   netlify deploy --prod

# ============================================
# STEP 4: Update README with your actual URLs
# ============================================
# Replace YOUR_USERNAME with your GitHub username
# Replace YOUR_SITE with your Netlify subdomain
# Replace YOUR_PROFILE with your LinkedIn username

# On Mac/Linux:
# sed -i '' 's/YOUR_USERNAME/anubhavsinghmaar/g' README.md
# sed -i '' 's/YOUR_SITE/rag-vs-cag/g' README.md

# Then push the update:
# git add README.md
# git commit -m "docs: add live demo and profile links"
# git push

# ============================================
# STEP 5: Update Colab notebook link
# ============================================
# After pushing, your Colab link will be:
# https://colab.research.google.com/github/YOUR_USERNAME/rag-vs-cag/blob/main/notebook/RAG_vs_CAG_Demo.ipynb

# ============================================
# STEP 6: Take screenshots for LinkedIn post
# ============================================
# 1. Open your Netlify site
# 2. Run a comparison with the sample NovaMind data
# 3. Screenshot the latency cards
# 4. Screenshot the detailed metrics table
# 5. Screenshot the history table after 3-4 questions
# 6. Save screenshots to assets/ folder
# 7. Push: git add assets/ && git commit -m "add screenshots" && git push

echo "Setup complete!"
