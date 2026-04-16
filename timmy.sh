#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ================================================================
# MARKER: TIMMY INTRO BLOCK
# ================================================================
#
#  timmy.sh
#  "Timmy's Time Table"
#
#  PURPOSE:
#  --------
#  Fast, ten-key-friendly time calculator for hh:mm:ss math.
#
#  CORE FEATURES:
#  --------------
#  • Accepts:
#      hh:mm:ss
#      mm:ss
#      ss
#
#  • Ten-key input:
#      "." is treated as ":"
#      Example:
#          1.02.30  ->  1:02:30
#          45.15    ->  45:15
#
#  • Operations:
#      ADD / SUBTRACT
#
#  • Internals:
#      Converts all time → total seconds → math → back to hh:mm:ss
#
#  • Design Philosophy:
#      Permissive parsing (sexagesimal-style, base-60 behavior)
#      Example:
#          1:75:90 → valid → normalized via math
#
#  • House Style:
#      - Colored prompts
#      - ">" prefix
#      - q / 0. exit tokens
#      - Looping calculator mode
#
# ================================================================


# ================================================================
# MARKER: COLOR DEFINITIONS
# ================================================================
RED="\033[1;31m"
GR='\033[1;32m'
YE='\033[1;33m'
CY='\033[1;36m'
NC='\033[0m'

# ================================================================
# MARKER: EXIT TOKEN HELPER
# ================================================================
is_exit_token() {
    local v="${1,,}"
    [[ "$v" == "q" || "$v" == "0." ]]
}


# ================================================================
# MARKER: NORMALIZE INPUT
# ================================================================
normalize_time_input() {
    local raw="${1:-}"

    raw="${raw// /}"
    raw="${raw//./:}"

    printf '%s\n' "$raw"
}


# ================================================================
# MARKER: VALIDATE TOKEN
# ================================================================
is_valid_time_token() {
    local value="${1:-}"
    [[ -n "$value" ]] || return 1
    [[ "$value" =~ ^[0-9]+(:[0-9]+){0,2}$ ]]
}


# ================================================================
# MARKER: TIME → SECONDS
# ================================================================
time_to_seconds() {
    local input
    input="$(normalize_time_input "${1:-}")"

    local h=0 m=0 s=0

    is_valid_time_token "$input" || {
        echo -e "${RED}> Invalid time: '$1'${NC}"
        return 1
    }

    local colon_count
    colon_count="$(grep -o ":" <<< "$input" | wc -l || true)"
    colon_count="${colon_count// /}"

    case "$colon_count" in
        0)
            s=$((10#$input))
            ;;
        1)
            IFS=':' read -r m s <<< "$input"
            m=$((10#$m))
            s=$((10#$s))
            ;;
        2)
            IFS=':' read -r h m s <<< "$input"
            h=$((10#$h))
            m=$((10#$m))
            s=$((10#$s))
            ;;
        *)
            echo -e "${RED}> Too many ':' in '$1'${NC}"
            return 1
            ;;
    esac

    printf '%s\n' $(( h*3600 + m*60 + s ))
}


# ================================================================
# MARKER: SECONDS → TIME
# ================================================================
seconds_to_time() {
    local total="${1:-0}"
    local sign=""

    if (( total < 0 )); then
        sign="-"
        total=$(( -total ))
    fi

    local h=$(( total / 3600 ))
    local m=$(( (total % 3600) / 60 ))
    local s=$(( total % 60 ))

    printf '%s%02d:%02d:%02d\n' "$sign" "$h" "$m" "$s"
}


# ================================================================
# MARKER: ASK OPERATION
# ================================================================
ask_operation() {
    echo >&2
    echo -e "${CY}====================${NC}" >&2
    echo -e "${CY} TIMMY'S TIME TABLE ${NC}" >&2
    echo -e "${CY}====================${NC}" >&2
    echo >&2
    echo -e "${YE}>1) Add Time${NC}" >&2
    echo -e "${YE}>2) Subtract Time${NC}" >&2
    echo >&2
    echo -e "${CY}>(q / 0.) Return${NC}" >&2
    echo >&2

    echo -ne "${CY}>Choose [1-2]: ${NC}" >&2
    read -r choice

    is_exit_token "$choice" && return 1

    case "$choice" in
        1) printf '%s\n' "add" ;;
        2) printf '%s\n' "sub" ;;
        *) printf '%s\n' "" ;;
    esac
}


# ================================================================
# MARKER: ASK TIME INPUT
# ================================================================
ask_time_value() {
    local label="$1"

    echo -ne "${CY}> ${label}${NC}  ${YE}(*.* 10key ok): ${NC}" >&2
    read -r val

    is_exit_token "$val" && return 1

    printf '%s\n' "$val"
}

# ================================================================
# MARKER: MAIN LOOP
# ================================================================
run_timmy() {
    while true; do
        local op
        op="$(ask_operation)" || break

        [[ -n "$op" ]] || continue

        local t1 t2 s1 s2 result

        t1="$(ask_time_value " FIRST")" || break
        t2="$(ask_time_value "SECOND")" || break

        s1="$(time_to_seconds "$t1")" || continue
        s2="$(time_to_seconds "$t2")" || continue

        case "$op" in
            add) result=$(( s1 + s2 )) ;;
            sub) result=$(( s1 - s2 )) ;;
        esac

        echo
        echo -e "${GR}> RESULT: $(seconds_to_time "$result")${NC}"
        echo
        #echo -e "${CY}> Press Enter To Continue...${NC}"
        #read -r _
    done
}


# ================================================================
# MARKER: ENTRY POINT
# ================================================================
run_timmy
