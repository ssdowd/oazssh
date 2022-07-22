# OAZ SSH Plugin

Functions for using ssh into Azure VMs.

## Install

```
git clone 
git clone git@github.com:ssdowd/oazssh.git ~/.oh-my-zsh/custom/plugins/oazssh
```

Then add `oazssh` to your OMZ plugin list in your ~/.zshrc:

```
plugins=(docker ... oazssh)
```

O'R functions:

## oazssh - ssh connection - uses your ~/.ssh/id_rsa key.

Accepts 2 args: env and vm short name:

```
oazssh dev ap0
```

Connects to the app-0 host in the dev environment.

## oazssht - ssh tunnel
