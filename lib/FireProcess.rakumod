unit module FireProcess;

constant $special-chars = Set.new(':', '%', '|', '&', '(', ')', '!', '^', '<', '>');

# I implemented what this article says about "cmd.exe" escaping
# https://learn.microsoft.com/en-gb/archive/blogs/twistylittlepassagesallalike/everyone-quotes-command-line-arguments-the-wrong-way
sub cmd-quote-str(Str:D $raw --> Str:D) is export
{
    my $out = '';

    for $raw.comb -> $ch {
        given $ch {
            when '"' {
                $out ~= ｢\^"｣;
            }
            when * ∈ $special-chars {
                $out ~= "^$ch";
            }
            default  {
                $out ~= $ch;
            }
        }
    }

    # Enclose the whole arg if it contains spaces
    if $raw ~~ /\s/ || $raw eq '' {
        $out = '^"' ~ $out ~ '^"';
    }
    return $out;
}

sub cmd-quote-argv(@args --> Str:D) is export {
    return @args.map(&cmd-quote-str).join(' ');
}

#| Runs the process (whose name is the first argument of @command) without blocking
#| execution. The process is "detached" i.e. it can outlive the Raku interpreter.
sub fire-process(*@command) is export {
    if $*DISTRO.is-win {
        # Windows-specific detached process launching
        run 'cmd', '/c', 'start', '""', '/b', cmd-quote-argv(@command), :win-verbatim-args;
    }
    else {
        # Not implemented on *nix,
	# probably need to combine nohup and shell background (&)
    }
}
