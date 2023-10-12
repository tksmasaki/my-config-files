########## common settings ##########
bindkey -e

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups
setopt share_history
setopt auto_pushd
setopt pushd_ignore_dups
setopt ignoreeof
setopt noclobber

export EDITOR="vim"
export LESS='-giXRMS'
export PAGER=less

alias ls='ls -FG'
alias la='ls -AFG'
alias ll='ls -lFG'
alias lla='ls -lAFG'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias rmf='rm -fr'
alias mkdir='mkdir -p'
alias grep='grep --color'
alias echopath='echo $PATH'
alias viz='vi ~/.zshrc'
alias cz='c ~/.zshrc'
alias vigc='vi ~/.gitconfig'
alias cgc='c ~/.gitconfig'
alias sz='source ~/.zshrc'

# git
alias g='git'
alias gb='git branch'
alias gbd='git branch -D'
alias gbv='git branch -vv'
alias gpulr='git pull --rebase'
alias gpulrmain='git pull --rebase origin main'
alias gpulrmaster='git pull --rebase origin master'
alias gpusf='git push --force-with-lease'
alias gs='git status'
alias gsw='git switch'
alias gswc='git switch -c'
alias gco='git checkout'
alias glgo='git log --graph --oneline'
alias glog='git log'
alias glogg='git log -G'
alias glogs='git log -S'
alias glogdeletefile='git log --diff-filter=D --name-status --'

# ruby
alias gemclean='gem uninstall -I -a -x --user-install --force'
alias be='bundle exec'
alias bi='bundle install'

########## addtional ##########
# rbenv: https://github.com/rbenv/rbenv
eval "$(rbenv init - zsh)"

# nvm: https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# pure: https://github.com/sindresorhus/pure
fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure

# ghq & peco setting: https://zenn.dev/obregonia1/articles/e82868e8f66793
# brew install go
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey ';;' peco-src

# VSCode: https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
alias c='code'
alias cn='code -n'
alias cr='code -r'
# NODE_OPTIONS をいじらないと code コマンドが動かないときがあった（詳細忘れた）
# alias c='env NODE_OPTIONS= code'
# alias cn='env NODE_OPTIONS= code -n'
# alias cr='env NODE_OPTIONS= code -r'
