Custom Shell Implementation in C
================================

Overview
--------
In this project, you will develop a simple command-line interpreter, or shell, named `myshell.c`. This custom shell will handle basic Linux commands like `ls`, `cat`, and `sleep`, without supporting pipes or complex commands. The shell will be implemented in C using `fork()` and `exec()`.

Objectives
----------
* Implement a custom shell in C that can execute basic Linux commands using `fork()` and `exec()`. Pipes and complex commands are not required.
* Implement specific shell commands (`history`, `cd`, `pwd`, `exit`) without using the default Unix implementations.
* Ensure all commands run in the foreground and handle errors appropriately. The parent process should wait for the child process to complete. (if failed just print `perror("X failed")` X might be fork, wait and etc.. and exit.)
* When the compiled program is initially run, it should accept any number of arguments consisting only of paths that may contain executable commands (e.g., `./a.out /root/custom_folder /root/another_folder`). Any executable program within those folders should be recognized by the shell.

Unix Commands:
* The program should allow the user to enter any known (and simple) Unix command with any number of arguments. Assume the command entered is in a directory passed as an argument when the program is started (e.g., `./a.out /root/custom_folder /root/another_folder`) or in a directory already in the `PATH` variable.

Environment Variables
---------------------
* The shell should accept any number of command-line arguments (paths).
* The shell should recognize any executable in those directories or in the directories already in the `$PATH` variable.
* Ensure that when the shell exits, the environment variables remain unchanged from their state prior to running the shell.

Custom Commands
---------------
You need to implement the following shell commands without using the Unix defaults:
* **`history`**: Display the list of commands that have been entered during the session (history prints in FIFO and includes the history command itself).
* **`cd`**: Change the current directory within the shell environment (use `chdir()`).
* **`pwd`**: Print the current working directory (use `getcwd()`).
* **`exit`**: Exit the shell.
These commands should be implemented using appropriate system calls and library functions available in C.

Command Execution
-----------------
* Commands should be executed in the foreground using `exec()` in a forked process.
* For commands not explicitly handled (`history`, `cd`, `pwd`, `exit`), NO EXEC OR FORK ARE NEEDED!
* Use `strtok()` with a space delimiter to parse the command into its core components.

Error Handling
--------------
* If a system call fails, the shell should use `perror()` to print an error message indicating which system call failed, e.g., `perror("fork failed")`.

Output Specifications
---------------------
* The shell should not print anything except the required output from commands or error messages.
* The prompt should be displayed as follows:
```c
printf("$ ");
fflush(stdout);
```

Assumptions
-----------
* The shell will handle up to 100 commands, with each command's length also limited to 100 characters.
* There are no spaces in the names of directories and files passed as arguments to the shell.

Restrictions
------------
* Adding new environment variables for command execution should not affect the existing ones prior to running the program.
* Changes to the current directory (`cd`) within the shell should not affect the working directory after the shell is closed.