#!/usr/bin/env bash

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
conf() (tmux show -gqv "@git-autofetch-$1")

LOGGING=$(conf "logging")
SKIP_PATHS=$(conf "skip-paths")
SCAN_PATHS=$(conf "scan-paths")
SKIP_PATHS=${SKIP_PATHS/\~/$HOME}
SCAN_PATHS=${SCAN_PATHS/\~/$HOME}
FETCH_FREQUENCY_MINS=3

log() {
    [ ! "$LOGGING" = "true" ] && return 0;
    local f=${FUNCNAME[1]}
    local r="$2"
    local l="/tmp/tmux-git-autofetch.log"
    [ "$1" = "sep" ] && echo "---" >> $l && return 0;
    [ "$f" = "path_control" ] && (echo "┌ Patterns => Skip: $SKIP_PATHS - Scan: $SCAN_PATHS") >> $l;
    local res=$([[ -n "$r" ]] && echo "true" || echo "false")
    echo "$(date +'%Y-%m-%d-%H:%M:%S') [$f] $1 => $res" >> $l;
    [ "$f" = "fetch" ] && awk '{sub("^", "├ "); print}' "$1/.git/FETCH_HEAD" >> $l;
}

fetch() {
    local res=$(cd "$1" && git fetch -q --all && echo "true")
    log "$1" "$res"&
}

path_control() {
    local pass=0
    [[ $1 =~ $SKIP_PATHS ]] && pass=1;
    [[ $1 =~ $SCAN_PATHS ]] && pass=0;
    log "sep"
    log "$1" "$([ "$pass" = 0 ] && echo "true")"
    return "$pass"
}

get_repo_root() {
    local path="$1"
    local repo_root=$(cd "$path" && git rev-parse --show-toplevel 2>/dev/null)
    echo "$repo_root"
}

# Control fetch if it's repo & time is reached
path_should_fetch() {
    repo_root_path=$(get_repo_root "$1")
    [ -z "$repo_root_path" ] && exit 1;

    id=$(echo "$repo_root_path" | sed 's|/|_|g')
    cache_path="/tmp/tmux-git-autofetch-cache/"
    time_file="$cache_path$id"
    time_file_new=false
    [ ! -d "$cache_path" ] && mkdir "$cache_path"
    [ ! -e "$time_file" ] && { touch "$time_file"; time_file_new=true; }

    now=$(date +%s)
    scanned=$(date -r "$time_file" "+%s")
    diff=$((now - scanned))
    mins_ago=$((diff / 60))
    should_fetch=$(((mins_ago && mins_ago >= FETCH_FREQUENCY_MINS) || time_file_new))

    if [ "$should_fetch" -eq 1 ]; then
        log "Checked more than $FETCH_FREQUENCY_MINS minutes ago ($mins_ago: $diff s). Should scan" $should_fetch
        touch -t "$(date +"%Y%m%d%H%M.%S")" "$time_file"
    else
        log "Checked less than $FETCH_FREQUENCY_MINS minutes ago ($mins_ago: $diff s). Skip"
    fi
    [ "$should_fetch" -eq 1 ]
}

# Check changed path
check_current() {
    path="${1-$(pwd)}"
    path_control "$path" &&
    path_should_fetch "$path" &&
    fetch "$path"
}

# Fetch current opened repositories
scan_paths() {
    tmux_panes_paths=$(tmux list-windows -F '#{pane_current_path}' | sort | uniq)
    for path in $tmux_panes_paths; do
        [ -d $path ] && check_current $path;
    done
}

# Cron job to keep scanning
add_cron_job() {
    script_file_path="$(readlink -f "$0")"
    if ! crontab -l | grep -q "$script_file_path"; then
        (crontab -l | { cat; echo "*/1 * * * * $script_file_path --scan-paths"; } | crontab -) &&
        echo "Added cron job";
    else
        echo "Cron already exists";
    fi
}

# To check when changing directory
add_shell_hook() {
    if grep -qE "^[^#]*tmux-git-autofetch/" ~/.zshrc; then
        echo "Shell hook already exists";
        return 0;
    fi
    script_file_path="$(readlink -f "$0")"
    cp ~/.zshrc ~/.zshrc.bk_tga &&
    echo "
tmux-git-autofetch() {($script_file_path --current &)}
add-zsh-hook chpwd tmux-git-autofetch
    " >> ~/.zshrc &&
    echo "Added shell hook"
}

install() {
    add_cron_job
    add_shell_hook
    echo "Install is done"
}

case "$1" in
    "--current")
        check_current ;;
    "--scan-paths")
        scan_paths ;;
    "--add-cron")
        add_cron_job ;;
    "--add-hook")
        add_shell_hook ;;
    "--install")
        install ;;
    "")
        install ;;
    *)
        echo "Invalid option: [$1]" >&2
        exit 0 ;;
esac

