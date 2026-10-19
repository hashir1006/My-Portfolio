#!/bin/bash
set -e

echo "=== Hashir Shaikh Portfolio — Vercel Build Script ==="

# Check if flutter is already in path
if ! command -v flutter &> /dev/null; then
  echo "Flutter not detected in environment. Downloading Flutter stable SDK..."
  FLUTTER_VERSION="3.47.7"
  if [ ! -d "$HOME/flutter" ]; then
    git clone https://github.com/flutter/flutter.git --branch stable --depth 1 "$HOME/flutter"
  fi
  export PATH="$PATH:$HOME/flutter/bin"
fi

echo "Using Flutter: $(flutter --version | head -n 1)"

echo "Fetching dependencies..."
flutter pub get

echo "Running Dart static analysis..."
flutter analyze --no-fatal-warnings

echo "Building Flutter Web (Release)..."
flutter build web --release

# Ensure resume is present in web root
if [ -f "Resume_Hashir_Shaikh.pdf" ]; then
  cp Resume_Hashir_Shaikh.pdf build/web/Resume_Hashir_Shaikh.pdf || true
  cp Resume_Hashir_Shaikh.pdf build/web/Hashir_Shaikh_Resume.pdf || true
elif [ -f "assets/resume/Resume_Hashir_Shaikh.pdf" ]; then
  cp assets/resume/Resume_Hashir_Shaikh.pdf build/web/Resume_Hashir_Shaikh.pdf || true
  cp assets/resume/Resume_Hashir_Shaikh.pdf build/web/Hashir_Shaikh_Resume.pdf || true
fi

echo "=== Build Complete! Output published to build/web ==="
