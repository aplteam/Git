# Git


## Overview

`Git` comes with a small range of functions supporting the APL programmer when working on projects with both Cider and Git.


## Philosophy

Experience tells that trying to support all sorts of Git commands from within APL is a recipe for trouble. For exampe, `Checkout` should not be performed from an APL session. 

More complex stuff like `Merge`, `Push` and `Pull` can easily run into a problem without the user doing anything wrong, and when you are then stuck in the middle of something within the call that executed a Git command, well, good luck.

For that reason `Git` offers only a pretty limited number of commands that are useful from within APL while working on a project. For anything else we suggest to use GitBash. `Git` makes this easy because `]OpenGitShell` opens a Git Bash within the current project (if there is just one open) or in the selected or the default project.

As a result most of the commands just provide information about the given project, or an object within that project.

Noticeable exceptions are the methods `Add` and `Commit`. Note that you can execute `Add` implicitly when executing `Commit`; see there.

All functions are also available via an API which lives in `⎕SE.Git`. However, the API calls are mor basic. For example, the  `Commit` API function just does that: executing `git commit`. The user command on the other hand first checks whether the project is currently dirty, and if it is it asks the user whether `git add .` should be executed first. 

Also, it opens an edit window for the user to create a message in case the `-m=` option wa not set.

## Preconditions and assumptions

* The Git bash must be installed, and available on the Windows environment variable `%PATH%`.
* `Git` assumes that any project is managed by the project manager 
  [Cider](https://github.com/aplteam/Cider).
