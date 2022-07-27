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

Usage: `oazssh [-e <env>] [-k keyfile] [-s srv || -S servername]`

You can supply a short name, like ap0 or db1 with `-s` or a full name with `-S`.  Short name implies a linux server.  A full means you supply the complete VM name and it has to match the environment (default: dev).

You can also provide the filename of a different ssh key (assumed to be located in `~/.ssh`) using `-k keyfile`.

```
oazssh -e dev -s ap0
```

Connects to the app-0 host in the dev environment.

## oazssht - ssh tunnel

Usage: `oazssht [-e <env>] [-k keyfile] [-s srv || -S servername][ -w | -l] [-l local_port] [-r remote_port]`

```
# in one shell:
oazssht -e dev -s ap0 

# in another:
ssh -p 5555 adminuser@localhost
# or
scp -P 5555 adminuser@127.0.0.1:file file
```

Or for an RDP connection to a windows box:

```
oazssht -e d -S az1dwepcmepcad1 -r 3389 -l 3389
```

Then use your RDP client to connect to localhost.


## Retrieve a password from keyvault

Example to retrieve the admin_user password for dev:

```
az keyvault secret show \
    --name "passwd-cus-dev-epc-mepc-adobe-server" \
    --vault-name "kv-cus-dev-epc-mepc" \
    --query "value" --output tsv \
    | pbcopy
```
