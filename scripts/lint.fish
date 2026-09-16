#!/usr/bin/fish

source lib/hobbylib.fish

log_info "Running linters..."

set -l error_count 0

# 1. taskfiles
log_info "Validating Taskfiles..."
if not task --dry
    log_error "Taskfile syntax validation failed!"
    set error_count (math $error_count + 1)
else
    log_debug "  OK: Taskfiles are valid"
end

# 2. shell scripts
log_info "Checking shell scripts (*.sh)..."
for file in (find config lib scripts -type f -name "*.sh")
    if not shellcheck $file
        log_error "ShellCheck failed for $file"
        set error_count (math $error_count + 1)
    else
        log_debug "  OK (shell): $file"
    end
end

# 3. fish & chroots (since chroot scripts use fish)
log_info "Checking Fish scripts (*.fish, *.hook.chroot)..."
for file in (find config lib scripts -type f \( -name "*.fish" -o -name "*.hook.chroot" \))
    if not fish -n $file
        log_error "Fish syntax error in $file"
        set error_count (math $error_count + 1)
    else
        log_debug "  OK (fish): $file"
    end
end

# 4. any errors? fail else pass
if test $error_count -gt 0
    log_error "Linting failed with $error_count error(s)."
    exit 1
else
    log_info "All files passed linting!"
    exit 0
end
