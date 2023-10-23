# Colormap:
# 0: -
# 31(red): temp
# 32(green): environment
# 33(yellow): -
# 34(blue): branch
# 35(magenta): -
# 36(cyan): IP
# 91: ✖
# 92: ✔
# 93: user, hostname
# 94: city, prec
# 95: duration
# 96: pwd

. "${HOME}/.local/share/git-prompt.sh"

function ms_to_human_friendly(){
    local ms="${1}"

    # I add 500ms to round to the closest second 
    local s="$(( ("${ms}"+500)/1000 ))"
    local m="$(( ("${s}"+30)/60 ))"
    local h="$(( ("${m}"+30)/60 ))"
    local d="$(( ("${h}"+12)/24 ))"
    if [ "${d}" -gt "0" ]; then
        local human_friendly="${d}d"
    elif [ "${h}" -gt "0" ]; then
        local human_friendly="${h}h"
    elif [ "${m}" -gt "0" ]; then
        local human_friendly="${m}m"
    elif [ "${s}" -gt "0" ]; then
        local human_friendly="${s}s"
    else
        local human_friendly="${ms}ms"
    fi

    printf "%s" "${human_friendly}"
}

function print_cmd_info(){
    # Get $? ASAP
    local exit_code="${?}"
    if [ "${exit_code}" -eq "0" ]; then
        local exit_code_decorated=$'\x1b[92m'"${exit_code}"$'✔\x1b[0m'
    else
        local exit_code_decorated=$'\x1b[91m'"${exit_code}"$'✖\x1b[0m'
    fi

    # I assume the use of ble.sh
    local cmd_duration_human_friendly="$(ms_to_human_friendly "${_ble_exec_time_tot}")"

    local branch="$(__git_ps1 "%s")"
    local branch_decorated=$'\x1b[34;1m'"${branch}"$'\x1b[0m'
    local environment_decorated=$'\x1b[32;1m'"${CONDA_DEFAULT_ENV}"$'\x1b[0m'
    if [ -n "${branch}" ]; then
        if [ -n "${CONDA_DEFAULT_ENV}" ]; then
            local suffix=", ${branch_decorated}, ${environment_decorated}"
        else
            local suffix=", ${branch_decorated}"
        fi
    else
        if [ -n "${CONDA_DEFAULT_ENV+x}" ]; then
            local suffix=", ${environment_decorated}"
        else
            local suffix=""
        fi
    fi

    printf $'\x1b[95m%s\x1b[0m, %s, \x1b[93m%s\x1b[0m@\x1b[93m%s\x1b[0m:\x1b[96;3m%s\x1b[0m%s\n' "${cmd_duration_human_friendly}" "${exit_code_decorated}" "${USER}" "${HOSTNAME}" "${PWD}" "${suffix}"
}

function print_info(){
    local load_duration_human_friendly="$(ms_to_human_friendly "${load_duration_ms}")" 

    # Otherwise local overwrites $?
    local reply
    reply=$(python3 "${HOME}/.local/share/bashrc_utils/src/GET.py")
    if [ "${?}" -eq "0" ]; then
        local reply_array=(${reply})
        local internet=$'\x1b[36m'"${reply_array[1]}"$'\x1b[0m (\x1b[94m'"${reply_array[0]}"$'\x1b[0m-\x1b[31m'"${reply_array[2]}"$'°C\x1b[0m-\x1b[94m'"${reply_array[3]}"$'%\x1b[0m)'
    else
        local internet="${reply}"
    fi

    printf $'\x1b[95m%s\x1b[0m, %s, \x1b[93m%s\x1b[0m@\x1b[93m%s\x1b[0m:\x1b[96;3m%s\x1b[0m%s\n' "${load_duration_human_friendly}" "${internet}" "${USER}" "${HOSTNAME}" "${PWD}"
}