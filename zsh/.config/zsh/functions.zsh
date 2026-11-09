# Extract file
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Define word
define() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: define <word>"
    return 1
  fi
  local word="$*"
  local result=$(curl -s "https://api.dictionaryapi.dev/api/v2/entries/en/$word")
  echo
  echo "$word"
  echo "-----------------"
  echo "$result" | jq -r '
  if type == "array" then
    .[0].meanings[] | .partOfSpeech as $pos | .definitions[] | "[" + $pos + "] " + .definition
  else
    "No definitions found."
  end
  '
}

# System update & maintenance
update() {
  sudo pacman -Syu
  zplugin-update
}
maintain() {
  update
  local orphans=$(pacman -Qtdq 2>/dev/null)
  if [[ -n "$orphans" ]]; then
    sudo pacman -Rns $orphans
  fi
  sudo find /var/cache/pacman/pkg \
    \( -name "*.part" -o -name "download-*" \) \
    -delete
  sudo pacman -Sc
}

# IP helpers
ipv4() {
  ip addr show \
    | grep inet \
    | grep -v '127.0.0.1' \
    | awk '{print $2}' \
    | cut -d/ -f1
}
ipv6() {
  ip addr show \
    | grep inet6 \
    | awk '{print $2}' \
    | sed -n 2p
}

# System errors
error() { journalctl -b -p err }

# Youtube search for RMPC
yt() { 
  if [[ "$1" == "save" ]]; then
    mv /tmp/rmpc/cache/youtube/* /mnt/shared/Music/YouTube/
  else
    rmpc searchyt --interactive --limit 10 "$*"
  fi
}

# Show weather
weather() { curl wttr.in/"$1" }

# Copy one or more files' contents to clipboard
copyfiles() {
  emulate -L zsh
  local show_tree=0
  local recursive=0
  local -a files clipboard
  local arg

  while (( $# )); do
    case "$1" in
      -t|--tree)
        show_tree=1
        ;;
      -r|--recursive)
        recursive=1
        ;;
      -tr|-rt|--all)
        show_tree=1
        recursive=1
          ;;
      --)
        shift
        files+=("$@")
        break
          ;;
      -*)
        echo "Unknown option: $1"
        return 1
        ;;
      *)
        files+=("$1")
        ;;
    esac
    shift
  done

  if (( ${#files[@]} == 0 )); then
    echo "Usage; copyfiles [-t] [-r] <file/folder> ..."
    return 1
  fi
  clipboard=(wl-copy)

    # Validate paths
    for arg in "${files[@]}"; do
        if [[ ! -e "$arg" ]]; then
            echo "Not found: $arg"
            return 1
        fi
    done

    {
        # Directory tree
        if (( show_tree )); then
            echo "========== DIRECTORY TREE =========="

            for arg in "${files[@]}"; do
                if [[ -d "$arg" ]]; then
                    if (( $+commands[eza] )); then
                        eza --tree -- "$arg"
                    elif (( $+commands[tree] )); then
                        tree "$arg"
                    else
                        find "$arg" -print
                    fi
                else
                    echo "$arg"
                fi
            done

            echo
        fi

        # File contents
        for arg in "${files[@]}"; do
            if [[ -f "$arg" ]]; then
                echo "========== $arg =========="
                cat -- "$arg"
                echo

            elif [[ -d "$arg" ]] && (( recursive )); then
                while IFS= read -r -d $'\0' file; do
                    echo "========== $file =========="
                    cat -- "$file"
                    echo
                done < <(find "$arg" -type f -print0)
            elif [[ -d "$arg" ]]; then
                echo "Skipping directory (use -r): $arg"
            fi
        done
    } | "${clipboard[@]}"

    echo "Copied to clipboard."

  # local file
  # for file in "$@"; do
  #   if [[ ! -f "$file" || ! -r "$file" ]]; then
  #     echo "Error: Cannot read $file"
  #     return 1
  #   fi
  # done
  # {
  #   for file in "$@"; do
  #     printf '\n========== %s ==========\n' "$file"
  #     cat -- "$file" || exit 1
  #     printf '\n'
  #   done
  # } | "${clipboard[@]}"
  # if (( $? == 0 )); then
  #   echo "Copied $# file(s) to clipboard."
  # else
  #   echo "Clipboard operation failed."
  #   return 1
  # fi
}
