unit module FireProcess;

## TODO: Algorithm is not correct right now. I must implement : 
# first CLTA quoting 
# then cmd quoting 
# not cmd quoting with a vague enclosing by "" and \" escaping !

constant $special-chars = Set.new(':', '%', '|', '&', '(', ')', '!', '^', '<', '>', '"');

# I implemented what this article says about CLTA and "cmd.exe" escaping
# https://learn.microsoft.com/en-gb/archive/blogs/twistylittlepassagesallalike/everyone-quotes-command-line-arguments-the-wrong-way

sub argv-quote(Str:D $arg, Bool :$force = False --> Str:D) {
    # If not forced and the argument does not contain special characters, return as-is
    unless $force or $arg ~~ /<[\s \t \n \v \"]>/ {
        return $arg;
    }

    my $command-line = '"';
    my $i = 0;
    while $i < $arg.chars {
        my $num-backslashes = 0;

        # Count backslashes
        while $i < $arg.chars && $arg.substr($i,1) eq Q[\] {
            ++$i;
            ++$num-backslashes;
        }

        # Check if we've reached the end
        if $i == $arg.chars {
            # Escape all backslashes before closing quote
            $command-line ~= '\\' x ($num-backslashes * 2);
            last;
        }

        my $char = $arg.substr($i,1);

        if $char eq '"' {
            # Escape all backslashes and the double quote
            $command-line ~= '\\' x ($num-backslashes * 2 + 1);
            $command-line ~= $char;
        } else {
            # Normal character: add backslashes and the character
            $command-line ~= '\\' x $num-backslashes;
            $command-line ~= $char;
        }

        ++$i;
    }

    $command-line ~= '"';
    return $command-line;
}

sub cmd-quote(Str:D $raw --> Str:D) {
    my $out = '';
    for $raw.comb -> $ch {
	if $ch ∈ $special-chars {
            $out ~= '^';
        }
        $out ~= $ch;
    }
    return $out;
}

sub cmd-quote-argv(@args --> Str:D) is export {
    return @args.map(&cmd-quote o &argv-quote).join(' ');
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
