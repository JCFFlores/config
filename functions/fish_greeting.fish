function fish_greeting
    if command -s fortune > /dev/null 2>&1
        set_color brgreen
        fortune
        set_color normal
    end
end
