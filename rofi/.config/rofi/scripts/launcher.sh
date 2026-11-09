#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
COMMANDS_FILE="$SCRIPT_DIR/commands.conf"

trim() {
    printf '%s' "$1" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g'
}

url_encode() {
    python3 -c 'import sys, urllib.parse; print(urllib.parse.quote_plus(sys.argv[1]))' "$1"
}

read_commands() {
    [[ -f "$COMMANDS_FILE" ]] || {
        rofi -e "Missing commands.conf"
        exit 1
    }

    while IFS='|' read -r trigger match action target description category extra; do
        trigger="$(trim "$trigger")"

        # Ignore comments and empty lines.
        [[ -z "$trigger" || "$trigger" == \#* ]] && continue

        match="$(trim "$match")"
        action="$(trim "$action")"
        target="$(trim "$target")"
        description="$(trim "$description")"
        category="$(trim "$category")"

        # Basic validation.
        if [[ -z "$match" || -z "$action" || -z "$description" ]]; then
            printf 'Invalid command definition: %s\n' "$trigger" >&2
            continue
        fi

        # Return the parsed values to the caller.
        printf '%s\034%s\034%s\034%s\034%s\034%s\n' \
            "$trigger" "$match" "$action" "$target" "$description" "$category"

    done < "$COMMANDS_FILE"
}

show_help() {
    printf '\0prompt\x1fHelp\n'
    printf '\0message\x1fAvailable commands\n'

    while IFS=$'\034' read -r trigger match action target description category; do
        IFS=',' read -ra aliases <<< "$trigger"

        for alias in "${aliases[@]}"; do
            alias="$(trim "$alias")"

            if [[ "$match" == "prefix" ]]; then
                alias="$alias ..."
            fi

            printf '%-18s %s\n' "$alias" "$description"
        done

    done < <(read_commands)

    # printf '%-12s  —  %s\n' "!help" "Show this help"
    # printf '%-12s  —  %s\n' ">" "Run in background"
    # printf '%-12s  —  %s\n' ">t" "Run in terminal (Kitty)"
    #
    # while IFS='|' read -r prefix action target label; do
    #     [[ -z "$prefix" || "$prefix" == \#* ]] && continue
    #     printf '%-12s  —  %s\n' "$prefix" "$label"
    # done < "$COMMANDS_FILE"
}

web_search() {
    local url="$1"
    local query="$2"
    local encoded
    encoded="$(url_encode "$query")"

    xdg-open "${url}${encoded}" >/dev/null 2>&1 &
}

# Run a graphical / background command
background_command() {
  local command="$1"
  [[ -z "$command" ]] && return 1
  setsid -f zsh -lic "$command" >/dev/null 2>&1
}

# Run an interactve command in a new Kitty window
terminal_command() {
    local command="$1"
    [[ -z "$command" ]] && return 1
    local wrapped

    printf -v wrapped '%s\n%s' "$command" 'status=$?; printf "\nExit code: %s\n" "$status"; printf "Press Enter to close..."; read -r'
    setsid -f env -u KITTY_LISTEN_ON kitty --title "Rofi Command" zsh -lic "$wrapped" >/dev/null 2>&1
}

execute_action() {
    local action="$1"
    local target="$2"
    local query="$3"
    local command

    case "$action" in

        web)
            web_search "$target" "$query"
            ;;

        background)
            command="$target"
            [[ -n "$query" ]] && command="${command:+$command }$query"
            background_command "$command"
            ;;

        terminal)
            command="$target"
            [[ -n "$query" ]] && command="${command:+$command }$query"
            terminal_command "$command"
            ;;

        help)
            show_help
            ;;

        *)
            rofi -e "Unknown action: $action"
            return 1
            ;;
    esac
}

handle_input() {
    local input="$1"
    local trigger match action target description category
    local alias query

    [[ -z "$input" ]] && exit 0

    # Load registry and check every command.
    while IFS=$'\034' read -r trigger match action target description category; do

        IFS=',' read -ra aliases <<< "$trigger"

        for alias in "${aliases[@]}"; do
            alias="$(trim "$alias")"

            query=""

            case "$match" in

                exact)
                    [[ "$input" == "$alias" ]] || continue
                    ;;

                prefix)
                    [[ "$input" == "$alias "* ]] || continue

                    query="${input#"$alias"}"
                    query="$(trim "$query")"
                    ;;

                *)
                    continue
                    ;;
            esac

            execute_action "$action" "$target" "$query"
            exit 0

        done

    done < <(read_commands)

    # No registered command matched.
    rofi -e "Unknown command. Type !help for available commands."
    exit 0
}

case "${ROFI_RETV:-0}" in
    0)
        printf '\0prompt\x1fLauncher\n'
        printf '\0message\x1fSearch applications or type !help\n'
        printf ' !help  Help\0info\x1fhelp\n'
        ;;

    1)
        if [[ "${ROFI_INFO:-}" == "help" ]]; then
            show_help
        else
            handle_input "${1:-${ROFI_INPUT:-}}"
        fi
        ;;

    2)
        handle_input "${ROFI_INPUT:-${1:-}}"
        ;;
esac

