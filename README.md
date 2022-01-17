# ssh-tunnel salt formula

This formula creates users with limited access where only ssh tunnels can be created.
If users are already present, they will be restricted as well.


# Formulas

## ssh-tunnel

Deploys SSH users according to pillar configuration, see `pillar.example` for details.


## ssh-tunnel.ssh-salt-only

Deploys SSH users allowing to connect to port `22` of all hosts registered with `salt-master`.
