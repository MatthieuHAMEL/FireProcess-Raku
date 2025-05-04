use lib <lib>;      # or 'lib' if script is at the root
use FireProcess;

fire-process(<notepad.exe>);

fire-process(('C:\Program Files\WinMerge\WinMergeU.exe', 'C:\tmp\foo.txt', 'C:\tmp\foo.txt'));

fire-process(<cmd.exe /c echo Hello>);

