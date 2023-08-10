# Ansible Role: peertube

This Ansible Role installs a rootless [peertube](https://joinpeertube.org/) container using Podman. It is intended to be composed with separate roles for other requirements.

In a nutshell, Peertube needs:

* https certificates
* web proxy
* node 16 (or containers)
* redis
* postfix
* postgres + 2 extensions

## Requirements

* [podman](docs/PODMAN.md)
* [containers.podman](https://github.com/containers/ansible-podman-collections)

## Dependencies

* [postgresql](docs/POSTGRES.md)
* [nginx_conf](docs/examples/nginx_conf.yml) (optional)

## Role Variables

See the role [defaults](defaults/main.yml) and the peertube [environment variable](https://docs.requarks.io/install/docker) documentation. For a working example, see this [homelab stack](https://github.com/bleetube/satstack).

## Example Playbook

```yaml
- hosts: peertube
  roles:
    - role: nginxinc.nginx_core.nginx
      become: true
    - role: anxs.postgresql
      become: true
    - role: alvistack.podman
      become: true
    - role: bleetube.peertube
      tags: peertube
  tasks:
    - import_tasks: nginx_conf.yml
      become: true
```

## Systemd

```
systemctl --user status container-peertube.service
```

## Upgrades

Configure `peertube_version`.

```bash
ansible-playbook playbooks/peertube.yml --tags peertube
```

## Configuration notes

The peertube 5.0.1 container reads some config from /config/production.yaml, and some config from environment variables. For posterity:

* smtp config must be in the environment variables
* postgres config must be in production.yaml
* redis config must be in production.yaml
* the peertube secret must be in the environment variables

To update this role for newer Peertube versions:

* Mind any changes to [production.yaml.example](https://github.com/Chocobozzz/PeerTube/blob/develop/config/production.yaml.example)