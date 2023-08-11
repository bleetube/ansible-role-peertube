# PostgreSQL

Here is an example using [anxs.postgresql](https://github.com/ANXS/postgresql)

## Example Playbook

```yaml
  roles:
    - anxs.postgresql
```

## Example Variables

```yaml
postgresql_users:
  - name: peertube
    pass: "{{ lookup('ansible.builtin.env', 'PEERTUBE_POSTGRES_PASSWORD') }}"
    encrypted: yes
    state: present

postgresql_databases:
  - name: peertube
    owner: peertube
    state: present
    pg_trgm: yes
    unaccent: yes
```

Depending on the OS version you're using, you may have to account for the usage of deprecated apt-key functionality.

## PG 15

I'm temporarily using this branch to get PG15:

```yaml
  - src: https://github.com/ANXS/postgresql
    name: anxs.postgresql
    version: development
```
## Backups

```bash
BACKUP_PG_DB() {
    BACKUP_DIR=$HOME/archive/${TARGET}/postgresql
    DUMP_FILE=/var/lib/postgresql/${1}_${TIMESTAMP}.dump.bz2
    ssh root@${TARGET} "cd /var/lib/postgresql && doas -u postgres /usr/bin/pg_dump -Fc ${1} | /usr/bin/bzip2 > ${DUMP_FILE}"
    mkdir -p ${BACKUP_DIR}
    rsync -tav root@${TARGET}:${DUMP_FILE} ${BACKUP_DIR}/
    ssh root@${TARGET} rm -v ${DUMP_FILE}

    # Only remove older backups if newer backups exist
    NEWER_BACKUPS=$(find $BACKUP_DIR -mtime -60 -type f -name "${1}_*.dump.bz2")
    if [[ -n $NEWER_BACKUPS ]]; then
        find $BACKUP_DIR -mtime +60 -type f -name "${1}_*.dump.bz2" -delete
    else
        echo "No newer backups found. Old backups not pruned."
    fi
}
BACKUP_PG_DB peertube
```