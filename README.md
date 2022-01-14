# Git


## Overview

`Git` comes with a small range of functions supporting the APL programmer when working on projects with both Cider and Git, though using Cider is not a requirement.


## Philosophy

Experience tells that trying to support all sorts of Git commands from within APL is a recipe for trouble. For example, `Checkout` should not be performed from an APL session. 

More complex stuff like `Merge`, `Push` and `Pull` can easily run into a problem without the user doing anything wrong, and when you are then stuck in the middle of something within the call that executed a Git command, well, good luck.

For that reason `Git` offers only a pretty limited number of commands that are useful from within APL while working on a project. For anything else we suggest to use GitBash. `Git` makes this easy because `]OpenGitShell` opens a Git Bash within the current project (if there is just one open) or in the selected or the default project.

As a result most of the commands just provide information about the given project, or an object within that project.

Noticeable exceptions are the methods `Add` and `Commit`. Note that you can execute `Add` implicitly when executing `Commit`; see there.

All functions are also available via an API which lives in `⎕SE.Git`. However, the API calls are more basic. For example, the  `Commit` API function just does that: executing `git commit`. The user command on the other hand first checks whether the project is currently dirty, and if it is it asks the user whether `git add .` should be executed first. 

Also, it opens an edit window for the user to create a message in case the `-m=` option was not set.

## Methods

```
 Add                Execute the git "Add" commands                                         
 ChangeLog          Takes an APL name and list all commits the object was part of          
 Commit             Performs a commit on the current branch                                
 CurrentBranch      Returns the name of the current branch            
 Diff               Returns files in the working dir that are different from HEAD
 GetDefaultProject  Returns namespace and folder of the current default project, if any    
 GoToGitHub         For a project "Foo/Goo" this opens https://github.com/Foo/Goo
 IsDirty            Reports whether there are uncommited changes and/or untracked files
 IsGitProject       Returns "yes" or "no" depending on whether there is a ./.git folder    
 ListBranches       Lists all branches for a Git-managed project                            
 Log                Returns the log of commits.\\
 OpenGitShell       Opens a Git shell for a Git managed project                             
 SetDefaultProject  Specifies the project to be used in case no project is specified   
 Status             Reports all untracked files and/or all uncommited changes
 Version            Returns name, version number and version date as a three-element vector
```

## Preconditions and assumptions

* The Git bash must be installed, and available on the environment variable `%PATH%`
* `]Git.GoToGitHub` requires you to host your project on GitHub, but all other commands are agnostic in this respect

Note that `]Git.*` works particularily well in conjunction with [Cider](https://github.com/aplteam/Cider), but this is not a requirement. 

However, with a project that is not managed by Cider you must always specify a folder, either as argument of a user command or by calling `]Git.SetDefaultProject`.