# this mode is intended for individual language functionality
# whether that be (c)ompiling, (a)nalyzing, or (r)unning
# this also just sets other arbitratry language specific shit

declare-user-mode language

# these 2 luau-lune functions require external lune scripts for servig and
# analysis! why? idfk it just feels nice LOL
define-command luau-lune-serve %{
	nop %sh{
		tmux new-window "lune run serve"
	}
}

define-command luau-lune-analyze %{
	nop %sh{
		tmux split-window "while true; do lune run analyze; read -s -k '?Press any key to reanalyze'; clear; done"
	}
}

define-command c-compile %{
	nop %sh{
		tmux split-window "while true; do gcc $kak_buffile; echo '\n'; read -s -k '?Press any key to rerun'; clear; done"
	}
}

define-command c-compile-and-run %{
	nop %sh{
		tmux split-window "while true; do gcc $kak_buffile; ./a.out; echo '\n'; read -s -k '?Press any key to rerun'; clear; done"
	}
}

define-command cpp-compile %{
	nop %sh{
		tmux split-window "while true; do g++ $kak_buffile; echo '\n'; read -s -k '?Press any key to rerun'; clear; done"
	}
}

define-command cpp-compile-and-run %{
	nop %sh{
		tmux split-window "while true; do g++ $kak_buffile; ./a.out; echo '\n'; read -s -k '?Press any key to rerun'; clear; done"
	}
}

hook global WinSetOption filetype=c %{
	set-option buffer comment_line '//'

	map -docstring 'compile' buffer language c ':c-compile<ret>'
	map -docstring 'compile and run' buffer language r ':c-compile-and-run<ret>'
}

hook global BufCreate .*[.](cpp) %{
	set-option buffer filetype cpp
	set-option buffer comment_line '//'

	map -docstring 'compile' buffer language c ':cpp-compile<ret>'
	map -docstring 'compile and run' buffer language r ':cpp-compile-and-run<ret>'
}

hook global BufCreate .*[.](luau) %{
	set-option buffer filetype luau
	set-option buffer comment_line '--'

	map -docstring 'runs lune analyze script' buffer language a ':luau-lune-analyze<ret>'
	map -docstring 'runs lune analyze script' buffer language s ':luau-lune-serve<ret>'
}

hook global BufCreate .*[.](asciidoc) %{
	set-option buffer filetype asciidoc
}

hook global BufCreate .*[.](toml) %{
	set-option buffer filetype toml
}

hook global BufCreate .*[.](nix) %{
	set-option buffer filetype nix
}
