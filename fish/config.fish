if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
	cowfortune | lolcat
	printf "\n"
end
