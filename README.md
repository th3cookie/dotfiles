# dotfiles

## Git Workflow for this repo

<b>This is a work in progress</b>

it's a special repo, this one, because I use branches to track dotfiles per machine. I use master to ensure all branches have consistent changes so that I can rebase off master and merge any global changes I wish to have for all machines.
> :warning: For any changes made to any global file (like readme and bash_aliases), I use development as a starting branch to test the changes on. Then once tested, merge these global changes into master. From master, I checkout my machine branch and rebase master to keep them up to date and manually fix conflicts.

> If I Accidentally forget to start on development/master before making changes to global files, I would save my changes that I wanted to put into master, then `git checkout master` to get onto my master branch locally (`git merge origin/master` to ensure to conflict from origin before proceeding. Then `git merge device_branch` and manually fix all conflicts (NOTE: This includes removing any contents of the files that are supposed to be empty in master such as .basrc.extras which will be completely deleted as it's different on each device.. I haven't quite figured the best way to deal with this other than to `git diff origin/device_name` and grab that extras file or even `git diff device_name` local branch if it's there). Then push master back to origin with `git push origin master`.

I don't think this part is required (keeping here in case it is in the future)?
> Then `git checkout device_branch`, `git merge origin/master` & `git diff origin/device_branch` and fix conflicts, then `git push`. I will do this for all other machines with branches in this repo. That is the best way i've found to manage these...

If you make any mistakes in your machine branches, just reset them with:
```script
git reset --hard origin/device_branch
```

For the machine branches, I have created a git attribute that excludes files from merging if they are added in the ".gitattributes" file of this repo and given the merge strategy "ours". Also, because master essentially acts as a global configuration that should be layed out across all of my machines, these machine branches will contain more configs than master because they have extra files based on how I use the machine. My workflow to essentially keep these branches up to date with master is:

Update local branch
```shell
git checkout development
```

Fetch all remote changes to bring branches and their commits in
```shell
git fetch --all
```

Merge the changes from master into local (I use merge rather than pull because I want to retain the branches local changes in the  and manually fix any conflicts)
```shell
git merge origin/development
```

Make any changes you wish to test in the global configs. merge this to master once tested and you like the changes
```shell
git add .
git commit -m "message here"
git push origin development
# Do this in git or merge via cli with:
git checkout master
git diff origin/development
git merge development
# fix any conflicts.. there really shouldn't be any if dev and master are used correctly as they should essentially be similar
git add .
git commit -m "message"
git push origin master
```

Then to merge these files into each device branch, check out the branch you want to merge into
```shell
git checkout <feature-branch>
```

Merge your (now updated) master branch into your feature branch to update it with the latest changes from your global configs.
```shell
git merge master
```

Fix any conflicts and push back to the devices branch
```shell
git add .
git commit -m "message"
git push origin
```
> :warning: The below needs more testing

Optionally, you may want to merge the commits into master to keep the HEAD up to date on master, but you need to specify the "ours" merge strategy as defined in the .gitattributes file. To do this, the command is (on master branch):
```shell
git merge -s ours office-pc
```

Fix any conflicts that arise and push back to github.

## How to install.

The files in this repository must be symlinked to their respective paths in the `$HOME` folder. We can do this manually or using [GNU Stow](https://www.gnu.org/software/stow/). Since GNU Stow can automatically manage symlinked files, it is the recommended tool for setting up the dotfiles.

The first step is to clone this repository in your `$HOME` folder (can use ssh or https):

```shell
git clone --recursive https://github.com/th3cookie/dotfiles.git ~/dotfiles
```

### 1. Simulate changes

> :warning: **If you are wanting to import all of these packages at once without importing the files in the parent directory (e.g. README.md, etc), use a trailing slash at the end as such: `stow -nvt ~ */`**

The first step is to run GNU Stow in simulation mode. This would warn about all
possible errors without making any changes in the filesystem. If you do not specify the target flat and directory (-t), it will default to using your users home directory.

You can do this with the following commands:

```shell
cd ~/dotfiles
git checkout <device_branch>	# Your devices branch
stow -nv bash 			# For bash configuration
stow -nv git 			# For git configuration
```

We may get some warning messages like the following one.

```shell
WARNING! stowing git would cause conflicts:
  * existing target is neither a link nor a directory: .gitconfig
All operations aborted.
```

This means that the file `.gitconfig` exists before the symlinking. We need to manually change its name so GNU Stow can create the symlink. My recommendation is to rename these conflicts:

```shell
[[ -e ~/.gitconfig ]] && mv ~/.gitconfig{,.old}
[[ -e ~/.bash_aliases ]] && mv ~/.bash_aliases{,.old}
[[ -e ~/.bashrc ]] && mv ~/.bashrc{,.old}
[[ -e ~/.config/htop/htoprc ]] && mv ~/.config/htop/htoprc{,.old}
```

### 2. Make changes

After all conflicting files have been renamed, we should not get any warnings:

```shell
LINK: .bash_aliases => dotfiles/bash/.bash_aliases
LINK: .bashrc => dotfiles/bash/.bashrc
WARNING: in simulation mode so not modifying filesystem.
```

We can now write the changes to disk removing the `-n` modifier:

```shell
cd ~/dotfiles
stow -v bash
stow -v git
```
