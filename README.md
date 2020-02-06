[Filipe Dias][repo]’s dotfiles
==========================

These are the base dotfiles that I start with when I set up a new
environment. For more specific local needs I use the `*.local` files
described in the [`Local Settings`](#local-settings) section.

Table of Contents
-----------------

* [🔧 Setup](#setup)
* [💄 Customize](#customize)
  * [🔀 Forks](#forks)
  * [🌐 Local Settings](#local-settings)
    * [🐚 `~/.bash.local`](#bashlocal)
    * [🔁 `~/.gitconfig.local`](#gitconfiglocal)
* [↕️  Update](#update)
* [📄 License](#license)

Setup
-----

To set up the `dotfiles` run the appropriate snippet in the terminal:

(⚠️  **DO NOT** run the `setup` snippet if you do not fully understand
[what it does][setup]. Seriously, **DON'T**!)

| OS | Snippet |
|:---|:---|
| `macOS` | `bash -c "$(curl -LsS https://raw.github.com/filipejtdias/dotfiles/master/src/os/setup.sh)"` |
| `Ubuntu` | `bash -c "$(wget -qO - https://raw.github.com/filipejtdias/dotfiles/master/src/os/setup.sh)"` |

That's it! ✨

The setup process will:

* Download the dotfiles on your computer
  (by default it will suggest `~/projects/dotfiles`).
* Create some additional [directories][dirs].
* [Symlink][symlink] the [`git`][git] and [`shell`][shell] files.
* Install applications / command-line tools for
  [`macOS`][install macos] / [`Ubuntu`][install ubuntu].
* Set custom [`macOS`][preferences macos] /
  [`Ubuntu`][preferences ubuntu] preferences.

Setup process in action:

| ![Setup process on macOS][setup macos] | ![Setup process on Ubuntu][setup ubuntu] |
|:---:|:---:|
| `macOS` | `Ubuntu` |

Customize
---------

### Local Settings

The `dotfiles` can be easily extended to suit additional local
requirements by using the following files:

#### `~/.bash.local`

The `~/.bash.local` file will be automatically sourced after all
the other [`bash` related files][shell], thus, allowing its content
to add to or overwrite the existing aliases, settings, `PATH`, etc.

Here is a very simple example of a `~/.bash.local` file:

```bash
#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set local aliases.

alias g="git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

PATH="$PATH:$HOME/projects/dotfiles/src/bin"

export PATH

```

#### `~/.gitconfig.local`

The `~/.gitconfig.local` file will be automatically included after
the configurations from `~/.gitconfig`, thus, allowing its content
to overwrite or add to the existing `Git` configurations.

__Note:__ Use `~/.gitconfig.local` to store sensitive information
such as the `Git` user credentials, e.g.:

```bash
[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    gpgsign = true

[user]

    name = XXXX XXXX
    email = account@example.com
    signingkey = XXXXXXXX
```

### Forks

If you decide to [fork] this project, do not forget to substitute
my username with your own in the [`setup` snippets](#setup) and
[in the `setup` script][setup script].

Update
------

To update the dotfiles you can either run the [`setup` script][setup]
or, if you want to update one particular part, run the appropriate
[`os` script](src/os).

Screenshots
-----------

### Git

Output for `Git status`:

| ![Output for Git status on macOS][git output macos] | ![Output for Git status on Ubuntu][git output ubuntu] |
|:---:|:---:|
| `macOS` | `Ubuntu` |

Output for `Git log`:

| ![Output for Git log on macOS][git log macos] | ![Output for Git log on Ubuntu][git log ubuntu] |
|:---:|:---:|
| `macOS` | `Ubuntu` |

License
-------

The code is available under the [MIT license][license].

<!-- Link labels: -->

[dirs]: src/os/create_directories.sh
[fork]: https://help.github.com/en/github/getting-started-with-github/fork-a-repo
[git log macos]: https://cloud.githubusercontent.com/assets/1223565/10560966/e4ec08a6-7523-11e5-8941-4e12f6550a63.png
[git log ubuntu]: https://cloud.githubusercontent.com/assets/1223565/10560955/4b5e1300-7523-11e5-9e96-95ea67de9474.png
[git output macos]: https://cloud.githubusercontent.com/assets/1223565/10561038/f9f11a28-7525-11e5-8e1d-a304ad3557f9.png
[git output ubuntu]: https://cloud.githubusercontent.com/assets/1223565/8397636/3708d218-1ddb-11e5-9d40-21c6871271b9.png
[git]: src/git
[install macos]: src/os/install/macos
[install ubuntu]: src/os/install/ubuntu
[license]: LICENSE
[preferences macos]: src/os/preferences/macos
[preferences ubuntu]: src/os/preferences/ubuntu
[repo]: https://github.com/filipejtdias
[setup macos]: https://cloud.githubusercontent.com/assets/1223565/19314446/cd89a592-90a2-11e6-948d-9d75247088ba.gif
[setup script]: https://github.com/filipejtdias/dotfiles/src/os/setup.sh#L3
[setup ubuntu]: https://cloud.githubusercontent.com/assets/1223565/19048636/e23e347a-89af-11e6-853c-98616b75b6ae.gif
[setup]: src/os/setup.sh
[shell]: src/shell
[symlink]: src/os/create_symbolic_links.sh
