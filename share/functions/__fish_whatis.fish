# localization: skip(private)

# uses `whatis` if available to describe a command

function __fish_whatis
    set -l cmd $argv[1]
    set -l fallback
    if set -q argv[2]
        set fallback $argv[2]
    end

    set -l description (whatis $cmd 2>/dev/null | string replace -r '.*? - ' '')[1]
    if string match -qr -- "." "$description"
        yield $description
    else if not string match -q -- "$fallback" ""
        yield $fallback
    else
        return 1
    end
end
