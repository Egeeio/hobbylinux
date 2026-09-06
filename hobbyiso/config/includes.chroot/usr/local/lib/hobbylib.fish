# /usr/local/lib/hobbylib.fish

function hobby_log -a level
    set -l msg $argv[2..-1]
    set -l timestamp (date "+%Y-%m-%d %H:%M:%S")

    switch $level
        case DEBUG
            set_color blue
            echo "[$timestamp] [DEBUG] $msg" >&2
            set_color normal
        case INFO
            set_color green
            echo "[$timestamp] [INFO]  $msg"
            set_color normal
        case WARN
            set_color yellow
            echo "[$timestamp] [WARN]  $msg" >&2
            set_color normal
        case ERROR
            set_color red
            echo "[$timestamp] [ERROR] $msg" >&2
            set_color normal
        case '*'
            echo "[$timestamp] [$level] $msg"
    end
end

function log_info
    hobby_log INFO $argv
end

function log_warn
    hobby_log WARN $argv
end

function log_error
    hobby_log ERROR $argv
end

function log_debug
    hobby_log DEBUG $argv
end
