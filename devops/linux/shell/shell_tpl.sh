#!/usr/bin/env bash

set -Eeuo pipefail

#==============================
# Script Template
#
# Usage:
#   ./script.sh [-v] [-h]
#
# Options:
#   -v    Enable DEBUG log
#   -h    Show help
#==============================

#######################################
# readonly variables
#######################################

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly WORK_DIR="$SCRIPT_DIR"
readonly LOG_FILE="$WORK_DIR/script.log"

#######################################
# global variables
#######################################

declare -gA ARGS_MAP=()
declare -gA COLOR_MAP=()
declare -gA LEVEL_MAP=(
    [e]="ERROR"
    [w]="WARN"
    [i]="INFO"
    [d]="DEBUG"
    [s]="SUCCESS"
)

#######################################
# logging
#######################################
log() {

    (($# == 0)) && return

    local level="i"

    case "${1:-}" in
        -e|-w|-i|-d|-s)
            level="${1#-}"
            shift
            ;;
    esac

    if [[ $level == d && -z ${ARGS_MAP[debug]:-} ]]; then
        return
    fi

    local now
    now="$(date '+%F %T.%3N')"

    local msg="[$now] [${LEVEL_MAP[$level]}] $*"

    if [[ -t 2 && -n ${COLOR_MAP[$level]:-} ]]; then
        printf "%b%s%b\n" \
            "${COLOR_MAP[$level]}" \
            "$msg" \
            "${COLOR_MAP[n]}" >&2
    else
        printf "%s\n" "$msg" >&2
    fi

    printf "%s\n" "$msg" >>"$LOG_FILE"
}

#######################################
# exit with error
#######################################
die() {
    log -e "$1"
    exit "${2:-1}"
}

#######################################
# cleanup
#######################################
cleanup() {

    # 删除临时文件
    # rm -f "$TMPFILE"

    [[ -n ${ARGS_MAP[help]:-} ]] && return

    log -d "cleanup finished"
}

#######################################
# help
#######################################
print_help() {

cat <<EOF
Usage:

    $0 [OPTIONS]

Options:

    -h      Show help
    -v      Enable debug log

EOF

}

#######################################
# parse arguments
#######################################
parse_args() {

    while getopts ":hv" opt
    do
        case "$opt" in
            h)
                ARGS_MAP[help]=1
                ;;
            v)
                ARGS_MAP[debug]=1
                ;;
            :)
                die "Option -$OPTARG requires an argument."
                ;;
            \?)
                die "Unknown option: -$OPTARG"
                ;;
        esac
    done
}

#######################################
# initialization
#######################################
init() {

    if [[ -t 2 ]]; then
        COLOR_MAP=(
            [e]=$'\033[31m'
            [w]=$'\033[33m'
            [i]=$'\033[0m'
            [d]=$'\033[34m'
            [s]=$'\033[32m'
            [n]=$'\033[0m'
        )
    fi

    parse_args "$@"

    if [[ -n ${ARGS_MAP[help]:-} ]]; then
        print_help
        exit 0
    fi

    [[ -d "$WORK_DIR" ]] || die "Working directory does not exist: $WORK_DIR"

    if [[ ! -e "$LOG_FILE" ]]; then
        touch "$LOG_FILE" || die "Cannot create log file: $LOG_FILE"
    fi

    log -d "Initialization completed"
}

#######################################
# error trap
#######################################
on_error() {

    local exit_code="$1"
    local line="$2"
    local cmd="$3"

    log -e "Command failed"

    log -e "Exit Code : $exit_code"
    log -e "Line      : $line"
    log -e "Command   : $cmd"
}

#######################################
# exit trap
#######################################
on_exit() {

    local exit_code="$1"

    if (( exit_code == 0 )); then
        [[ -z ${ARGS_MAP[help]:-} ]] && log -s "Script completed successfully"
    fi

    cleanup
}

#######################################
# main
#######################################
main() {

    cd "$WORK_DIR" || die "Cannot enter $WORK_DIR"

    log "Business started"

    ls

    log -s "Business finished"

}

#######################################
# trap
#######################################

trap 'on_error $? $LINENO "$BASH_COMMAND"' ERR
trap 'on_exit $?' EXIT

#######################################
# start
#######################################

init "$@"

main
