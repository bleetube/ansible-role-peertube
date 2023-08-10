#!/bin/bash
TARGET=example
TIMESTAMP=$(date +%m-%d-%Y)

# peertube files
rsync --delete-after -ta ${TARGET}:/var/compose/peertube $HOME/archive/${TARGET}/

# peertube postgresql
BACKUP_DIR=$HOME/archive/${TARGET}/postgresql
DUMP_FILE=/var/lib/postgresql/peertube_${TIMESTAMP}.dump.bz2
ssh root@${TARGET} "doas -u postgres /usr/bin/pg_dump -Fc peertube | /usr/bin/bzip2 > ${DUMP_FILE}"
mkdir -p $HOME/archive/${TARGET}/postgresql/
rsync -tav ${TARGET}:${DUMP_FILE} $HOME/archive/${TARGET}/postgresql/
ssh root@${TARGET} rm -v ${DUMP_FILE}

# restore
#su - postgres
# dropdb peertube; createdb peertube
#bzcat peertube_*.dump.bz2 | pg_restore -d peertube