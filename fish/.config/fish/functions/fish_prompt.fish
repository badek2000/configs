# Only define fish_prompt if it doesn’t already exist—this helps when venv activation
# wants to back up your current prompt.
if not functions -q fish_prompt
    function fish_prompt
        # Save the exit status of the last command
        set last_status $status

        ####################################################################
        # Base color names (hex or named colors)
        ####################################################################
        set user_color 008067
        set dir_color 008067
        set prompt_symbol_color FF9000

        ####################################################################
        # Change color for error (nonzero exit status)
        ####################################################################
        if test $last_status -ne 0
            set at_color red
            set prompt_symbol_color red
        else
            set at_color FF9000
            set prompt_symbol_color FF9000
        end

        ####################################################################
        # Git color definitions (store as color names, not escape codes)
        ####################################################################
        set symbol_clean_color 008067        # For a “clean” branch
        set symbol_dirty_color FF9000        # For the dirty marker (✱)
        set branch_name_color brblack        # Gray branch name
        set op_color 9B59B6                  # Purple – Git operation indicator

        ####################################################################
        # Build Git info segment (if in a Git repo)
        ####################################################################
        set git_segment ""
        if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set branch (command git symbolic-ref --quiet --short HEAD 2>/dev/null)
            set is_dirty (command git status --porcelain 2>/dev/null)

            if test -n "$branch"
                if test -n "$is_dirty"
                    set git_segment (printf "%s%s%s" (set_color $branch_name_color) $branch (set_color $symbol_dirty_color) ✱)
                else
                    set git_segment (printf "%s%s" (set_color $branch_name_color) $branch)
                end

                # Show commits ahead/behind the remote, if available
                set ahead_behind (command git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null | awk '{print $1 "↑ " $2 "↓"}')
                if test -n "$ahead_behind"
                    set git_segment "$git_segment $ahead_behind"
                end

                # Display count of staged and unstaged changes
                set staged (command git diff --cached --numstat | wc -l | string trim)
                set unstaged (command git diff --numstat | wc -l | string trim)
                if test $staged -gt 0
                    set git_segment "$git_segment $staged+"
                end
                if test $unstaged -gt 0
                    set git_segment "$git_segment $unstaged!"
                end
            end

            # Show currently running Git operations in a subtle manner
            set git_dir (command git rev-parse --git-dir 2>/dev/null)
            if test -e "$git_dir/rebase-merge" -o -e "$git_dir/rebase-apply"
                set git_segment "$git_segment "(set_color $op_color)"(rebase)"(set_color normal)
            else if test -e "$git_dir/MERGE_HEAD"
                set git_segment "$git_segment "(set_color $op_color)"(merge)"(set_color normal)
            else if test -e "$git_dir/CHERRY_PICK_HEAD"
                set git_segment "$git_segment "(set_color $op_color)"(cherry-pick)"(set_color normal)
            else if test -e "$git_dir/BISECT_LOG"
                set git_segment "$git_segment "(set_color $op_color)"(bisect)"(set_color normal)
            end
        end

        ####################################################################
        # Print the complete prompt
        ####################################################################
        # Print Git info segment, if available:
        if test -n "$git_segment"
            printf "%s " "$git_segment"
        end

        # Main prompt: Username, @, current dir, >>> symbol
        printf "%s%s" (set_color --bold $user_color) $USER
        printf "%s@" (set_color --bold $at_color)
        printf "%s%s " (set_color --bold $dir_color) (basename $PWD)
        printf "%s>>> " (set_color --bold $prompt_symbol_color)

        # Reset terminal color
        set_color normal
    end
end

