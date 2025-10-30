#
# Oh My Zsh Theme: anonymous
#
# =========================================================
# 1. Colors Setup (Customize these variables easily)
# =========================================================

# Zsh Escape Codes:
# %F{...} : Start foreground color
# %f      : End foreground color
# %B      : Start bold
# %b      : End bold

# Structure
SEP_COLOR="%F{237}"         # Light Grey/White-like for separator
PROMPT_CHAR_COLOR="%F{red}" # Color for the '❯' command prompt

# Data
TIME_COLOR="%F{blue}"
USER_COLOR="%F{green}"
PWD_COLOR="%F{yellow}"
GIT_COLOR="%F{magenta}"

SEP_START="*"
SEP_END="*"
SEP="*"

# =========================================================
# 2. Git Status Function (Returns formatted string or nothing)
# =========================================================

function custom_git_status() {
  # Check if we are inside a git repository
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    # Get the current branch name
    local branch_name
    branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    
    # Check for uncommitted changes ('!' for dirty repo)
    local dirty_symbol=""
    if ! git diff --quiet --exit-code --ignore-submodules --no-ext-diff; then
      dirty_symbol="!"
    fi
    
    # Return the formatted string: [GIT_BRANCH!] 
    echo "${SEP_COLOR} - ${GIT_COLOR}${branch_name}${dirty_symbol}]%f"
  else
    echo "${USER_COLOR}]"
  fi
}

# =========================================================
# 3. Prompt Variable Definition
# =========================================================

# Clear PROMPT/RPROMPT to start fresh
PROMPT=""
RPROMPT=""

# --- Line 1: Separator Line (Dotted Underline Simulation) ---
    NEWLINE=$'\n'
    PROMPT+="${PROMPT_CHAR_COLOR}${SEP_START}${SEP_COLOR}$(/usr/bin/printf '%.s'${SEP}'' $(/usr/bin/seq 3 $(tput cols)))${PROMPT_CHAR_COLOR}${SEP_END}${NEWLINE}"

# --- Line 2: The Core Information Line ---
# Original format requested: [time in 12hr] [username {git ? "- git branch"}] [pwd with ~] [points]
# Replicating your new format: [%n@%m] [%t] [%w %~]
# Combining with Git: [%t] [%n] [GIT] [%w] 
# NOTE: The %t (24h) and %T (12h) codes are different. Using %T for 12hr AM/PM.

# [Time: 12hr AM/PM]
PROMPT+="${TIME_COLOR}[%D{%d-%m-%Y\ %I:%M%p}]" 

# [Username]
PROMPT+=" ${USER_COLOR}[%n@%m%f" 

# [Git Branch] - **This is the main integration point**
PROMPT+="\$(custom_git_status)" 

# [Current Directory: Full Path (%w) and Home Abbreviated (%~)]
# The original code had both %w and %~, which can be redundant.
# Using only %~ (home abbreviation) for cleanliness.
PROMPT+=" ${PWD_COLOR}[%~]%f"           

# [Points: Zsh Prompt Char]
# PROMPT+=" ${SEP_COLOR}[%#]%f"         

# --- Line 3: The Command Input Line ---
PROMPT+=$NEWLINE
PROMPT+="${PROMPT_CHAR_COLOR}❯ %f"    # -> command prompt symbol