#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER druid WITH SUPERUSER PASSWORD 'druid';
    CREATE DATABASE druid;
    GRANT ALL PRIVILEGES ON DATABASE druid TO druid;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER superset WITH SUPERUSER PASSWORD 'superset';
    CREATE DATABASE superset;
    GRANT ALL PRIVILEGES ON DATABASE superset TO superset;
EOSQL