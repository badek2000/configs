function fish_prompt
    printf (set_color 008067)"$USER"(set_color FF9000)"@"(set_color 008067)(basename $PWD)
    printf (set_color FF9000)" >>> "
end
