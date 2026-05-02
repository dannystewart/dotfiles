function omos
    set port (random 49152 65535)
    OPENCODE_PORT=$port opencode --port $port $argv
end
