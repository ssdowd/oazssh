# OAZ SSH Plugin

Functions for using ssh into Azure VMs.

## Install

```
git clone git@github.com:ssdowd/oazssh.git  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/oazssh
```

Then add `oazssh` to your OMZ plugin list in your ~/.zshrc:

```
plugins=(... oazssh)
```

To get automatic updates of this plugin, install https://github.com/Pilaton/OhMyZsh-full-autoupdate:

```
git clone https://github.com/Pilaton/OhMyZsh-full-autoupdate.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ohmyzsh-full-autoupdate
plugins=(... ohmyzsh-full-autoupdate)
```

O'R functions:

## oazssh - ssh connection - uses your ~/.ssh/id_rsa key.

Accepts 2 args: env and vm short name:

```
oazssh dev ap0
```

Connects to the app-0 host in the dev environment.

## oazssht - ssh tunnel

```
# in one shell:
oazssht dev ap0 

# in another:
ssh -p 5555 adminuser@localhost
# or
scp -P 5555 adminuser@127.0.0.1:file file
```
