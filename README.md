# OAZ SSH Plugin

Functions for using ssh into Azure VMs.

O'R functions:

## oazssh - ssh connection - uses your ~/.ssh/id_rsa key.

Accepts 2 args: env and vm short name:

```
oazssh dev ap0
```

Connects to the app-0 host in the dev environment.

## oazssht - ssh tunnel
