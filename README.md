# Ansible Role: peertube

This Ansible Role deploys the [Peertube](https://joinpeertube.org/) Typescript code in a rootless container using Podman. It is intended to be composed with separate roles for the other Peertube requirements.

Thus, besides its own code (which this role deploys) it also needs:

* postgres + 2 extensions
* https certificates
* web proxy
* redis
* mail server (optional)

Tested on:

* Ubuntu 22.04

## Requirements

* [podman](docs/PODMAN.md)
* [containers.podman](https://github.com/containers/ansible-podman-collections)

Relevant parts of `requirements.yml`:

  ```yaml
  collections:
    - name: containers.podman
      src: https://github.com/containers/ansible-podman-collections
  roles:
    - src: https://github.com/alvistack/ansible-role-podman
      name: alvistack.podman
  ```

## Dependencies

* [postgresql](docs/POSTGRES.md)
* [nginx_conf](docs/examples/nginx_conf.yml) (optional)

## Role Variables

See the role [defaults](defaults/main.yml). For a working example, see this [homelab stack](https://github.com/bleetube/satstack).

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

* Review the [development changelog](https://github.com/Chocobozzz/PeerTube/blob/develop/CHANGELOG.md) and mind any meaningful changes to [production.yml](https://github.com/Chocobozzz/PeerTube/blob/release/5.2.0/config/production.yaml.example)
* Configure `peertube_version`.

```bash
ansible-playbook playbooks/peertube.yml --tags peertube
```

## Notes

The peertube 5.0.1 container would only read some config from `production.yaml`, and some config from environment variables. This is handled by the role, but for posterity:

* postgres config must be in production.yaml
* redis config must be in production.yaml
* smtp config must be in the environment variables
* the peertube secret must be in the environment variables
