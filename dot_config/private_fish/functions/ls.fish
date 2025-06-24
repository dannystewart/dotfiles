function ls --description 'Smart ls with eza or fallback'
    if command -q eza
        eza -bg $argv
    else
        command ls --color=auto $argv
    end
end
