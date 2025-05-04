- Run a process by giving it an array (argv), just like [run](https://docs.raku.org/routine/run) does
- ... process is ran without blocking the script execution (just like what Proc::Async does)
- **process does not die when the raku interpreter exits**

See the "examples" folder for real use cases.
