**Windows only for now!**

- Run a process by giving it an array (argv), just like [run](https://docs.raku.org/routine/run) does
- ... process is ran without blocking the script execution (just like what Proc::Async does)
- **process does not die when the raku interpreter exits**

I created this module because I didn't find any Raku function answering the need expressed above. 

Internally, it makes use of ```cmd /c```, thus it implements cmd quoting. Though, a clean solution using CreateProcess internally would not need that layer at all!

See the "examples" folder for real use cases.

