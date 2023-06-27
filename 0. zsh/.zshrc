# Add these to PATH
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/.pyenv/scripts:$PATH" #to be able to run python scripts from whatever directory
export PATH=$PYENV_ROOT/bin:$PATH
export PYENV_ROOT="$HOME/.pyenv"

# Custom prompt for terminal
PROMPT='%(?.%F{green}Diego.%F{red}ERROR?)%f %B%F{240}%1~%f%b
%# '

# %(?.%F{green}Diego.%F{red}?%?): This part of the prompt is responsible for displaying a symbol that indicates the success or failure of the previous command. It uses the conditional %? to check the exit status of the last command. If the exit status is 0 (success), it will display "Diego" in green using %F{green}, otherwise, it will display a question mark in red using %F{red}.
# %f: This resets the text color to the default.
# %B: This enables bold text formatting.
# %F{240}: This sets the foreground (text) color to a specific value. In this case, 240 represents a gray color.
# %1~: This displays the current working directory. %1 limits the directory to just the last component (e.g., "Documents" instead of "/home/user/Documents"), and ~ is used as a replacement for the home directory path.
# %f: This resets the text color to the default.
# %b: This disables any text formatting (bold, underline, etc.) that was previously enabled.
# %#: This displays a # if the current user is root (admin), indicating a privileged prompt. Otherwise, it displays a $ for a regular user.

# Custom prompt for Git https://git-scm.com/book/sv/v2/Bilaga-A%3A-Git-in-Other-Environments-Git-in-Zsh
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{yellow}%b%f'


HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS # Ignores duplicated commands history list
setopt SHARE_HISTORY        # When working in parallel sessions this shares history
alias history='history 1'   # https://stackoverflow.com/questions/26846738/zsh-history-is-too-short

# PYENV Configurations
eval "$(pyenv init --path)" # This only sets up the path stuff.
eval "$(pyenv init -)" # This makes pyenv work in the shell.
eval "$(pyenv virtualenv-init -)" # Enabling virtualenv so it works natively.
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
alias virtualenv="pyenv virtualenv"

# https://github.com/pyenv/pyenv-virtualenv/issues/135#issuecomment-712534748 turn off deprecated pyenv prompt

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export BASE_PROMPT=$PS1
function updatePrompt {
    if [[ "$(pyenv version-name)" != "system" ]]; then
        # the next line should be double quote; single quote would not work for me
        export PS1="($(pyenv version-name)) "$BASE_PROMPT
    else
        export PS1=$BASE_PROMPT
    fi
}
export PROMPT_COMMAND='updatePrompt'
precmd() { eval '$PROMPT_COMMAND' } # this line is necessary for zsh

function cd() {
  builtin cd "$@"

  if [[ ! -z "$VIRTUAL_ENV" ]] ; then
    # If the current directory is not contained
    # within the venv parent directory -> deactivate the venv.
    cur_dir=$(pwd -P)
    venv_dir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$cur_dir"/ != "$venv_dir"/* ]] ; then
      source deactivate
    fi
  fi

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    # If config file is found -> activate the vitual environment
    venv_cfg_filepath=$(find . -maxdepth 2 -type f -name 'pyvenv.cfg' 2> /dev/null)
    if [[ -z "$venv_cfg_filepath" ]]; then
      return # no config file found
    fi

    venv_filepath=$(cut -d '/' -f -2 <<< ${venv_cfg_filepath})
    if [[ -d "$venv_filepath" ]] ; then
      source "${venv_filepath}"/bin/activate
    fi
  fi
}
