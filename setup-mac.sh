#!/bin/bash
set -uo pipefail

echo "==> Checking Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Press Enter after the Xcode Command Line Tools install finishes."
  read -r
fi

echo "==> Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Adding Homebrew taps"
brew tap modem-dev/tap

FORMULAE=(
  cloc
  cmake
  ffmpeg
  gh
  git-lfs
  jj
  modem-dev/tap/hunk
  pipx
  pkgconf
  tmux
  watch
)

echo "==> Installing Homebrew formulae"
for formula in "${FORMULAE[@]}"; do
  brew install "$formula" || echo "FAILED formula: $formula"
done

CASKS=(
  1password
  claude
  dbeaver-community
  docker
  ghostty
  google-chrome
  licecap
  loom
  tailscale-app
  telegram
  zed
)

echo "==> Installing Homebrew casks"
for cask in "${CASKS[@]}"; do
  brew install --cask "$cask" || echo "FAILED cask: $cask"
done

echo "==> Installing nvm and Node.js LTS"
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
. "$NVM_DIR/nvm.sh"
nvm install --lts

NPM_PACKAGES=(
  @earendil-works/pi-coding-agent
  agent-browser
  corepack
  puppeteer-core
)

echo "==> Installing global npm packages"
for pkg in "${NPM_PACKAGES[@]}"; do
  npm install -g "$pkg" || echo "FAILED npm package: $pkg"
done

echo "==> Installing Claude Code"
if [ ! -x "$HOME/.local/bin/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

echo "==> Installing OpenCode"
if [ ! -x "$HOME/.opencode/bin/opencode" ]; then
  curl -fsSL https://opencode.ai/install | bash
fi

echo "==> Setup complete"
echo "Restart your terminal, then check the FAILED lines above if any."
