# Welcome !
Want to contribute to Image Gallery? There are a few things you need to know.

- [Anchor](#anchor)
- [Code of Conduct](#conduct)
- [Semantic versionning](#versionning)
- [Guidelines](#guidelines)
- [Bugs](#bugs)

## Author
We are hetic student, to get mail address go in [AUTHOR.md](https://github.com/HETIC-MT-P2021/aio-group6-proj01/blob/markdown/AUTHOR.md)

## Code of Conduct
Please read and follow our Code of Conduct in [CODE_OF_CONDUCT.md](https://github.com/HETIC-MT-P2021/aio-group6-proj01/blob/markdown/CODE_OF_CONDUCT.md).

## Semantic Versionning
Every significant change is documented in the changelog file in CHANGELOG.md.

## Guidelines

### Coding Rules
- All features or bug fixes must be tested by one or more specs (unit-tests).
- All public API methods must be documented.
- All methods from the backend should contains annotations
- All API routes should be documented thanks to [api-platform](https://api-platform.com/)

### Existing branches
- master
- dev

"dev" branch contains the following branches :
- feat      : New feature.
- bug       : Code changes linked to a known issue.
- hotfix    : Quick fixes to the codebase.
- junk      : Experiments (will never be merged).

### Commit Conventions
Each commit message consists of a **header**, a **body** and a **footer**. The **header** has a special format that includes a **type** and a **subject** :

$type: $subject

BLANK LINE

$body

BLANK LINE

$footer

#### Type
Must be one of the following:

- build: Changes that affect the build system or external dependencies
- ci: Changes to our CI configuration files and scripts (example scopes: Circle, BrowserStack, SauceLabs)
- docs: Documentation only changes
- feat: A new feature
- fix: A bug fix
- perf: A code change that improves performance
- refactor: A code change that neither fixes a bug nor adds a feature
- style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- test: Adding missing tests or correcting existing tests

#### Subject
The subject contains a succinct description of the change:

- use the imperative, present tense: "change" not "changed" nor "changes"
- don't capitalize the first letter
- no dot (.) at the end

#### Body
Just as in the subject, use the imperative, present tense: "change" not "changed" nor "changes". The body should include the motivation for the change and contrast this with previous behavior.

#### Footer
Place to reference GitHub issues that this commit Closes.

## Bugs
### Where to Find Known Issues
We are using GitHub Issues for our public bugs. We keep a close eye on this and try to make it clear when we have an internal fix in progress. Before filing a new task, try to make sure your problem doesn’t already exist. For the moment you can't contribute with us, it will be possible after V1.0.0.

### Reporting New Issues
The best way to get your bug fixed is to provide a reduced test case. This [JSFiddle](https://jsfiddle.net/) template is a great starting point.

### How to Get in Touch
You can find our mail address in [AUTHOR.md](https://github.com/HETIC-MT-P2021/aio-group6-proj01/blob/markdown/AUTHOR.md). We will give you an answer as soon as possible.

### Proposing a change
If you intend to change the API, or make any non-trivial changes to the implementation, we recommend filing an issue. This lets us reach an agreement on your proposal before you put significant effort into it.

If you’re only fixing a bug, it’s fine to submit a pull request right away but we still recommend to file an issue detailing what you’re fixing. This is helpful in case we don’t accept that specific fix but want to keep track of the issue.

## Submitting a Pull Request (PR)
- Search GitHub for an open or closed PR that relates to your submission. You don't want to duplicate effort.

- Be sure that an issue describes the problem you're fixing, or documents the design for the feature you'd like to add. Discussing the design up front helps to ensure that we're ready to accept your work.

- Fork the repo.

- Make your changes in a new git branch:

    ```git checkout -b my-fix-branch master```

- Create your patch, **including appropriate unit test**.

- Follow our Coding Rules.

- Run the application, please refer to [README.md](https://github.com/HETIC-MT-P2021/aio-group6-proj01/blob/master/README.md)

- Commit your changes using a descriptive commit message that follows our commit message conventions. Adherence to these conventions is necessary because release notes are automatically generated from these messages.

    ```git commit -a```

    Note: the optional commit -a command line option will automatically "add" and "rm" edited files.

- Push your branch to GitHub:

    ```git push origin my-fix-branch```

- In GitHub, send a pull request to master
    If we suggest changes then:
    
    1/ Make the required updates.

    2/ Re-run the Angular test suites to ensure tests are still passing.

    3/ Rebase your branch and force push to your GitHub repository (this will update your Pull Request):

    ```git rebase master -i```
    ```git push -f```

    Nice you did it! Thank you for your contribution!
