# ------INDEX--------
# 1. Prompt
# 2. Path alterations
# 3. Aliases
# 4. NVM
# 5. AWS
# -------------------

# 1. PROMPT
# ========

# colors
GREEN=$(tput setaf 2);
YELLOW=$(tput setaf 3);
RESET=$(tput sgr0);

function git_branch {
  # Shows the current branch if in a git repository
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \(\1\)/';
}

# default prompt
DISPLAY_DIR='$(dirs)'
DISPLAY_BRANCH='$(git_branch)'
PROMPT="${YELLOW}${DISPLAY_DIR}${GREEN}${DISPLAY_BRANCH}${RESET}"$'\n'"$ ";

# allow substitution in PS1
setopt promptsubst

# 2. PATH ALTERATIONS
# ===================

# Composer
export PATH=$PATH:~/.composer/vendor/bin

# 3. ALIASES
# ==========

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias c="cd ~/code";

# 4. NVM
# ======

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# 5. AWS
# ======

export PATH="$HOME/.amplify/bin:$PATH"
export AWS_PROFILE=default
export AWS_REGION=eu-central-1