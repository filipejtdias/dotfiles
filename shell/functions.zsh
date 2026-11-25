# Create new directories and enter the first one
mkd() {
    if [ -n "$*" ]; then
        mkdir -p "$@" && cd "$@"
    fi
}

# Delete files that match a certain pattern from the current directory
delete-files() {
    local q="${1:-*.DS_Store}"
    find . -type f -name "$q" -ls -delete
}

# Get gzip information (gzipped file size + reduction size)
gz() {
    if [ -f "$1" ]; then
        if [ -s "$1" ]; then
            local orig=$(wc -c < "$1")
            local gzipped=$(gzip -c "$1" | wc -c)
            printf "orig:  %d bytes\n" "$orig"
            printf "gzip:  %d bytes\n" "$gzipped"
            printf "saved: %.1f%%\n" "$(echo "scale=1; 100-$gzipped*100/$orig" | bc)"
        else
            printf "\"%s\" is empty.\n" "$1"
        fi
    else
        printf "\"%s\" is not a file.\n" "$1"
    fi
}
