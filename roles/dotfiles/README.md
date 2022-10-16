Role Name
=========

This role uses a wrapper around GNU stow to back up any existing dotfiles and then symlink the desired folders from the dotfiles repo. It can run as a single unprivileged user, or set up multiple user accounts.

Requirements
------------

This role installs GNU stow. A dotfiles git repo is required with various application dotfiles separated into folders and listed in the dotf_stow_list var.
A dotfiles stow repo example:
```
dotfiles
├── bash
│   ├── .bash_aliases
│   ├── .bash_fedora
│   ├── .bash_osx
│   ├── .bash_profile
│   ├── .bashrc
│   └── .bash_root_aliases
├── dig
│   └── .digrc
├── git
│   ├── .gitconfig
│   └── .gitignore_global
├── mongodb
│   └── .mongorc.js
├── rpmbuild
│   └── .rpmmacros
├── sakura
│   └── .config
│       └── sakura
│           └── sakura.conf
└── vim
    └── .vimrc
```

Role Variables
--------------

This role requires setting a valid git repo URL and vaulted key_vault attribute in the dotf_git_repo_default dict,  
as well as the desired folders to stow in stow_folder_list. If dotf_multi_user is true then any users listed in  
dotf_git_repo_users will be set up, optionally with individual repo, key, folder, etc. settings.

License
-------

BSD

Author Information
------------------

https://github.com/herd-the-cats
