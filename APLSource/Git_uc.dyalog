:Class Git_uc
⍝ User Command class for the project manager "Git"
⍝ Kai Jaeger ⋄ APL Team Ltd
⍝ Version 0.30.0

    ⎕IO←1 ⋄ ⎕ML←1 ⋄ ⎕WX←3
    MinimumVersionOfDyalog←'18.0'

    ∇ r←List;c ⍝ this function usually returns 1 or more namespaces (here only 1)
      :Access Shared Public
      r←⍬
      :If AtLeastVersion⊃(//)⎕VFI MinimumVersionOfDyalog
     
          c←⎕NS''
          c.Name←'Add'
          c.Desc←'Execute the git "Add" commands'
          c.Group←'Git'
          c.Parse←'1 -project='
          c._Project←0
          r,←c
     
          c←⎕NS''
          c.Name←'ChangeLog'
          c.Desc←'Takes an APL name and list all commits the object was part of'
          c.Group←'Git'
          c.Parse←'1 -project='
          c._Project←0
          r,←c
     
          c←⎕NS''
          c.Name←'Commit'
          c.Desc←'Performs a commit on the current branch'
          c.Group←'Git'
          c.Parse←'1s -m='
          c._Project←1
          r,←c
     
          c←⎕NS''
          c.Name←'CurrentBranch'
          c.Desc←''
          c.Group←'Git'
          c.Parse←'1s'
          c._Project←1
          r,←c
     
          c←⎕NS''
          c.Name←'GoToGitHub'
          c.Desc←'Opens project page on GitHub'
          c.Group←'Git'
          c.Parse←'1s'
          c._Project←1
          r,←c
     
          c←⎕NS''
          c.Name←'IsDirty'
          c.Desc←'Reports uncommited changes'
          c.Group←'Git'
          c.Parse←'1s'
          c._Project←1
          r,←c
     
          c←⎕NS''
          c.Name←'IsGitProject'
          c.Desc←'Returns "yes" or "no" depending on whether there is a ./.git folder'
          c.Group←'Git'
          c.Parse←'1s'
          c._Project←1
          r,←c
     
          c←⎕NS''
          c.Name←'ListBranches'
          c.Desc←'List all branches for a Git-managed project'
          c.Group←'Git'
          c.Parse←'1s'
          c._Project←1
          r,←c
     
          :If 0
              c←⎕NS''
              c.Name←'Log'
              c.Desc←''
              c.Group←'Git'
              c.Parse←'1s'
              c._Project←1
              r,←c
          :EndIf
     
          :If 0
              c←⎕NS''
              c.Name←'LogForBranch'
              c.Desc←''
              c.Group←'Git'
              c.Parse←'1 -project='
              c._Project←0
              r,←c
          :EndIf⍝
     
          c←⎕NS''
          c.Name←'OpenGitShell'
          c.Desc←'Open a Git Shell for a Git managed project'
          c.Group←'Git'
          c.Parse←'1s'
          c._Project←1
          r,←c
     
          c←⎕NS''
          c.Name←'SetDefaultProject'
          c.Desc←'Specify the project all commands use in case no project is specified'
          c.Group←'Git'
          c.Parse←'1s'
          c._Project←1
          r,←c
     
          c←⎕NS''
          c.Name←'Status'
          c.Desc←'Returns the current status'
          c.Group←'Git'
          c.Parse←'1s -short'
          c._Project←1
          r,←c
     
          c←⎕NS''
          c.Name←'Version'
          c.Desc←'Returns name, version number and version date as a three-element vector'
          c.Group←'Git'
          c.Parse←''
          c._Project←0
          r,←c
      :EndIf
    ∇

    ∇ r←Run(Cmd Args);folder;G;space
      :Access Shared Public
      r←0 0⍴''
      ('Git needs at least version ',MinimumVersionOfDyalog,' of Dyalog APL')Assert AtLeastVersion⊃(//)⎕VFI MinimumVersionOfDyalog
      G←LoadGitCode ⍬
      :If ({⍵⊃⍨⍸⍵.Name≡¨⊂Cmd}List)._Project
      :AndIf 0≢Args._1
          (space folder)←GetSpaceAndFolder Args._1
      :ElseIf 2=Args.⎕NC'project'
      :AndIf 0<≢Args.project
          (space folder)←GetSpaceAndFolder Args.project
      :Else
          (space folder)←G.EstablishProject''
      :EndIf
      'Could not identify the given project'⎕SIGNAL 11/⍨0=≢space,folder
      :Select ⎕C Cmd
      :Case ⎕C'Add'
          r←Add space folder Args
      :Case ⎕C'ChangeLog'
          r←ChangeLog space folder Args
      :Case ⎕C'Commit'
          r←Commit space folder Args
      :Case ⎕C'CurrentBranch'
          r←CurrentBranch space folder Args
      :Case ⎕C'GoToGitHub'
          :If 0=⎕NC'space'
              r←GoToGitHub Args
          :Else
              r←space GoToGitHub Args
          :EndIf
      :Case ⎕C'IsDirty'
          r←IsDirty space folder Args
      :Case ⎕C'IsGitProject'
          r←IsGitProject space folder Args
      :Case ⎕C'ListBranches'
          r←ListBranches space folder Args
      :Case ⎕C'Log'
          ∘∘∘
      :Case ⎕C'LogForBranch'
          ∘∘∘
      :Case ⎕C'RefLog'
          ∘∘∘
      :Case ⎕C'OpenGitShell'
          r←OpenGitShell space folder Args
      :Case ⎕C'Status'
          r←⍪Status space folder Args
      :Else
          ∘∘∘ ⍝ Huh?!
      :EndSelect
    ∇

    ∇ r←Add(space folder args);filter
      'Not a URL on GitHub'Assert 0<≢args._1
      filter←args._1
      'Invalid filter'Assert 0<≢filter
      r←filter G.Add space
    ∇

    ∇ r←{space}GoToGitHub args
      'Not a URL on GitHub'Assert 0<≢args._1
      :If 0=⎕NC'space'
          r←⎕SE.Git.GoToGitHub args._1
      :Else
          r←⎕SE.Git.GoToGitHub space
      :EndIf
    ∇

    ∇ r←ChangeLog(space folder args);msg;name
      name←args._1
      :If ~(⊃name)∊'#⎕'
          ∘∘∘
      :EndIf
      ('Not an APL object: ',name)Assert 0<⎕NC name
      r←folder ⎕SE.Git.ChangeLog name
    ∇

    ∇ r←GoToGithub(space folder args);msg
      r←⎕SE.Git.GoToGithub folder msg
    ∇

    ∇ r←IsDirty(space folder args)
      r←(1+⎕SE.Git.IsDirty folder)⊃'no' 'yes'
    ∇

    ∇ r←IsGitProject(space folder args)
      r←(1+⎕SE.Git.IsGitProject folder)⊃'no' 'yes'
    ∇

    ∇ r←OpenGitShell(space folder args)
      r←⎕SE.Git.OpenGitShell folder
    ∇

    ∇ r←CurrentBranch(space folder args)
      r←⎕SE.Git.CurrentBranch folder
    ∇

    ∇ r←Commit(space folder args);msg;ref;branch;rc;data
      :If ⎕SE.Git.IsDirty space
          branch←⎕SE.Git.CurrentBranch folder
          :If 1 YesOrNo'Branch "',branch,'" is dirty - excute Git''s "Add ." command?'
              (rc msg data)←folder ⎕SE.Git.##.U.RunGitCommand'add .'
              msg Assert 0=rc
          :Else
              r←'Cancelled by user'
              :Return
          :EndIf
      :EndIf
      :If 0<≢Args.m
          msg←Args.m
      :Else
          ref←⎕NS''
          ref.msg←'' ''
          ref.⎕ED'msg'
      :EndIf
      r←msg ⎕SE.Git.Commit folder
    ∇

    ∇ r←Status(space folder args);short
      short←Args.Switch'short'
      r←short G.Status folder
    ∇

    ∇ r←ListBranches(space folder args)
      r←⍪G.ListBranches folder
    ∇

    ∇ r←level Help Cmd;ref
      :Access Shared Public
      r←''
      :Select level
      :Case 0
          :Select ⎕C Cmd
          :Case ⎕C'Add'
              r,←⊂']Git.add <filter>'
          :Case ⎕C'ChangeLog'
              r,←⊂']Git.ChangeLog <APL-object> -project'
          :Case ⎕C'Commit'
              r,←⊂']Git.Commit [project] -m='
          :Case ⎕C'CurrentBranch'
              r,←⊂']Git.CurrenBranch [project]'
          :Case ⎕C'GoToGitHub'
              r,←⊂']Git.OpenGitHub [project]'
          :Case ⎕C'IsDirty'
              r,←⊂']Git.IsDirty [project]'
          :Case ⎕C'IsGitProject'
              r,←⊂']Git.IsGitProject [project]'
          :Case ⎕C'ListBranches'
              r,←⊂']Git.ListBranches [project]'
          :Case ⎕C'Log'
              r,←⊂''
          :Case ⎕C'LogForBranch'
              r,←⊂''
          :Case ⎕C'OpenGitShell [project]'
              r,←⊂']Git.OpenGitShell'
          :Case ⎕C'SetDefaultProject'
              r,←⊂']Git.SetDefaultProject [space|file://folder]'
          :Case ⎕C'Status'
              r,←⊂']Git.Status -short -path= -ns='
          :Else
              ∘∘∘ ⍝ Huuh?
          :EndSelect
          :If 'Version'≢Cmd
              r,←''(']Git.',Cmd,' -?? ⍝ Enter this for more information ')
          :EndIf
     
      :Case 1
          :Select ⎕C Cmd
          :Case ⎕C'Commit'
              r,←⊂'Record changes to the repository.'
              r,←⊂'The branch must not be dirty (see ]Git.IsDirty) but if it is anyway the user will be'
              r,←⊂'asked whether she wants to add all files first.'
              r,←⊂''
              r,←⊂'-m=  If this is specified it is accepted as the message.'
              r,←⊂'     If it is not specified then the command will open an edit window for the message.'
              r,←⊂''
              r,←⊂'Note that a message is required for main (or the now deprecated master) branch but might'
              r,←⊂'be empty for other branches. Empty messages will become "...".'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'CurrentBranch'
              r,←⊂'Returns the name of the current branch'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'GoToGitHub'
              r,←⊂'Opens project in your default browser as, say:'
              r,←⊂'https://github.com/aplteam/Git'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'IsDirty'
              r,←⊂'Returns:'
              r,←⊂'Project <name> (<path) is [not] dirty'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'IsGitProject'
              r,←⊂'Returns:'
              r,←⊂'Project <name> (<path) is [not] managed by Git'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'ListBranches'
              r,←⊂'List all branches'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'Log'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'LogForBranch'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'RefLog'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'OpenGitShell'
              r,←⊂'Opens a Git Bash shell'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Case ⎕C'SetDefaultProject'
              r,←⊂'Use this to specify a default project.'
              r,←⊂'Commands that require a project will act on the default project in case it was set.'
          :Case ⎕C'Status'
              r,←⊂'Reports the status from Git''s perspective.'
              r,←⊂'By default a verbose report is printed.'
              r,←⊂'Specify -short for getting just the essentials.'
              r,←⊂''
              r,←AddProjectOptions ⍬
          :Else
              ∘∘∘ ⍝ Huh?!
          :EndSelect
      :Case 2
          r,←⊂'There is no additional help available'
      :EndSelect
    ∇

    ∇ r←AddProjectOptions dummy
      r←''
      r,←⊂'By default a user command will act on the currently opened Cider project if there is just one.'
      r,←⊂'If there are multiple open Cider projects the user will be asked which one to act on.'
      r,←⊂''
      r,←⊂'Once a default project got established and there are several Cider projects opened the user will'
      r,←⊂'be asked if she wants to act on the default project. If she refuses a list with all opened Cider'
      r,←⊂'projects will be presented to her.'
      r,←⊂''
      r,←⊂'You may specify a project for a command by setting -project=. It must be one of:'
      r,←⊂' * The fully qualified path to a namespace that is an opened Cider project'
      r,←⊂' * The path to a git-managed folder'
      r,←⊂'   In this case it does not have to be an open Cider project, and not even a closed one.'
      r,←⊂'   It must start with file://'
    ∇

    ∇ r←AtLeastVersion min;currentVersion
      :Access Public Shared
      ⍝ Returns 1 if the currently running version is at least `min`.\\
      ⍝ If the current version is 17.1 then:\\
      ⍝ `1 1 1 0 ←→ AtLeastVersion¨16 17 17.1 18`\\
      ⍝ You may specify a version different from the currently running one via `⍺`:\\
      ⍝ `1 1 0 0 ←→ 17 AtLeastVersion¨16 17 17.1 18`
      currentVersion←{⊃⊃(//)⎕VFI ⍵/⍨2>+\⍵='.'}2⊃'.'⎕WG'aplversion'
      'Right argument must be length 1'⎕SIGNAL 11/⍨1≠≢min
      r←⊃min≤currentVersion
    ∇

    Assert←{⍺←'' ⋄ (,1)≡,⍵:r←1 ⋄ ⍺ ⎕SIGNAL 1↓(⊃∊⍵),11}

    ∇ r←r AddTitles titles
    ⍝ `r` is a matrix with data. `titles` is put on top of that matrix, followed by a row with `-` matching the lengths of each title
      r←⍉↑(⊂¨titles),¨' ',¨↓⍉r
      r[2;]←(≢¨r[1;])⍴¨'-'
    ∇

    ∇ path←AddSlash path
      path,←(~(¯1↑path)∊'/\')/'/'
    ∇

    ∇ G←LoadGitCode dummy;res;folder;msg
      :If 0=⎕SE.⎕NC'_Git'
          G←'_Git'⎕SE.⎕NS''
          folder←¯1↓1⊃⎕NPARTS ##.SourceFile,'APLSource'
          res←({⍵.overwrite←1 ⋄ ⍵}⎕NS'')⎕SE.Link.Import G folder
          'Could not import the Git application code'Assert∨/'Imported:'⍷res
          ⎕SE.Git←⎕SE._Git.APLSource.API          ⍝ Establish the API
          {}⎕SE.Git.InitializeGit''
      :EndIf
      G←⎕SE.Git
    ∇

    ∇ yesOrNo←{default}YesOrNo question;isOkay;answer;add;dtb;answer2
    ⍝ Ask a simple question and allows just "Yes" or "No" as answers.
    ⍝ You may specify a default via the optional left argument which when specified
    ⍝ rules what happens when the user just presses <enter>.
    ⍝ `default` must be either 1 (yes) or 0 (no).
    ⍝ Note that this function does not work as expected when traced!
      isOkay←0
      default←{0<⎕NC ⍵:⍎⍵ ⋄ ''}'default'
      isOkay←0
      :If 0≠≢default
          'Left argument must be a scalar'⎕SIGNAL 11/⍨1≠≢default
      :AndIf ~default∊0 1
          'The left argument. if specified, must be a Boolean or empty'⎕SIGNAL 11
      :EndIf
      :If 0=≢default
          add←' (y/n) '
      :Else
          :If default
              add←' (Y/n) '
          :Else
              add←' (y/N) '
          :EndIf
      :EndIf
      :If 1<≡question
          ((≢question)⊃question)←((≢question)⊃question),add
          question←⍪question
      :Else
          question←question,add
      :EndIf
      :Repeat
          ⍞←question
          answer←⍞
          :If answer≡question                        ⍝ Did...  (since version 18.0 trailing blanks are not removed anynmore)
          :OrIf (≢answer)=¯1+≢question               ⍝ ..the ...
          :OrIf 0=≢answer                            ⍝ ...user just...
              dtb←{⍵↓⍨-+/∧\' '=⌽⍵}
              answer2←dtb answer
          :OrIf answer2≡((-≢answer2)↑(⎕UCS 10){~⍺∊⍵:⍵ ⋄ ' ',dtb ⍺{⌽⍵↑⍨1+⍵⍳⍺}⌽⍵}question)   ⍝ ...press <enter>?
              :If 0≠≢default
                  yesOrNo←default
                  isOkay←1
              :EndIf
          :Else
              answer←¯1↑{⍵↓⍨-+/∧\' '=⌽⍵}answer
              :If answer∊'YyNn'
                  isOkay←1
                  yesOrNo←answer∊'Yy'
              :EndIf
          :EndIf
      :Until isOkay
    ∇


    ∇ index←{x}Select options;flag;answer;question;value;bool;⎕ML;⎕IO;manyFlag;mustFlag;caption
    ⍝ Presents `options` as a numbered list and allows the user to select either exactly one or multiple ones.\\
    ⍝ One is the default.\\
    ⍝ The optional left argument allows you to specify more options:
    ⍝ * `manyFlag` defaults to 0 (meaning just one item might be selected) or 1, in which case multiple items can be specified.
    ⍝ * `mustFlag` forces the user to select at least one  option.
    ⍝ * `caption` is shown above the options.
    ⍝ `options` must not have more than 999 items.
    ⍝ If the user aborts by entering nothing or a "q" (for "quit") `index will be `⍬`.
      x←{0<⎕NC ⍵:⊆⍎⍵ ⋄ ''}'x'
      (caption manyFlag mustFlag)←x,(⍴,x)↓'' 0 0
      ⎕IO←1 ⋄ ⎕ML←1
      manyFlag←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'manyFlag'
      'Invalid right argument; must be a vector of text vectors.'⎕SIGNAL 11/⍨2≠≡options
      'Right argument has more than 999 items'⎕SIGNAL 11/⍨999<≢options
      flag←0
      :Repeat
          ⎕←{⍵↑'--- ',caption,((0≠≢caption)/' '),⍵⍴'-'}⎕PW-1
          ⎕←⍪{((⊂'. '),¨⍨(⊂3 0)⍕¨⍳⍴⍵),¨⍵}options
          ⎕←''
          question←'Select one ',(manyFlag/'or more '),'item',((manyFlag)/'s'),' '
          question,←((manyFlag∨~mustFlag)/'('),((~mustFlag)/'q=quit'),((manyFlag∧~mustFlag)/', '),(manyFlag/'a=all'),((manyFlag∨~mustFlag)/')'),' :'
          :If 0<≢answer←⍞,0/⍞←question
              answer←(⍴question)↓answer
              :If 1=≢answer
              :AndIf answer∊'Qq',manyFlag/'Aa'
                  :If answer∊'Qq'
                      :If 0=mustFlag
                          index←⍬
                          flag←1
                      :EndIf
                  :Else
                      index←⍳≢options
                      flag←1
                  :EndIf
              :Else
                  (bool value)←⎕VFI answer
                  :If ∧/bool
                  :AndIf manyFlag∨1=+/bool
                      value←bool/value
                  :AndIf ∧/value∊⍳⍴options
                      index←value
                      flag←0≠≢index
                  :EndIf
              :EndIf
          :EndIf
      :Until flag
      index←{1<≢⍵:⍵ ⋄ ⊃⍵}⍣(⍬≢index)⊣index
    ∇

    ∇ (space folder)←GetSpaceAndFolder data
      :If 'file://'{⍺≡(≢⍺)↑⍵}data
          folder←(≢'file://')↓data
          space←G.GetProjectFromPath folder
      :Else
          space←data
          folder←G.GetPathFromProject space
      :EndIf
    ∇

:EndClass
