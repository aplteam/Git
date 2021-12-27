# Git


## Overview

`Git` comes with a small range of functions supporting the APL programmer when working on projects with both Cider and Git.


## Philosophy

Experience tells that trying to support all sorts of Git commands from within APL is a recipe for trouble. For exampe, `Checkout` should not be performed from an APL session. 

More complex stuff like `Merge`, `Push` and `Pull` can easily run into a problem without the user doing anything wrong, and when you are then stuck in the middle of something within the call that executed a Git command, well, good luck.

For that reason `Git` offers only a pretty limited number of commands that are useful from within APL while working on a project. For anything else we suggest to use GitBash. `Git` makes this easy because `]OpenGitShell` opens a Git Bash within the current project (if there is just one open) or in the selected project.

## Preconditions and assumptions

* The Git bash must be installed and available on the Windows environment variable `%PATH%`.
* `Git` assumes that any project is managed by the project manager 
  [Cider](https://github.com/aplteam/Cider).
* `Git` assumes that you host your project on GitHub.
