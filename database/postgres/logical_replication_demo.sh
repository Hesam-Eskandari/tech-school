#!/bin/bash

function cleanup() {
  printf "removing container \"%s\"\n" "$CONTAINER_NAME" >&2;
  docker container rm -f "$CONTAINER_NAME" >/dev/null;
  printf "removing data directory: \"%s\"\n" "$PG_DATA_DIR" >&2;
  rm -r "$PG_DATA_DIR";
}

function is_installed() {
    local PROGRAM=$1;
    local CHECK;
    local RES;
    CHECK=$(which "$PROGRAM");
    RES=true;
    if [ -z "$CHECK" ]; then
      RES=false;
    fi
    echo $RES;
}

function exit_if_not_installed() {
  local PROGRAM=$1;
  if [ "$(is_installed "$PROGRAM")" != true ]; then
    fatal_error "fatal error: program \"$PROGRAM\" is not installed";
  fi
}

function fatal_error() {
  local MESSAGE="$1";
  echo "$MESSAGE" >&2;
  exit 1;
}

function to_lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

function contains_substring() {
  local LONG="$1";
  local SHORT="$2";
  local IS_CASE_SENSITIVE="${3-false}";
  local RES=false;
  if [ "$IS_CASE_SENSITIVE" == false ]; then
    LONG=$(to_lower "$LONG");
    SHORT=$(to_lower "$SHORT");
  fi
  if [[ "$LONG" == *"$SHORT"* ]]; then
    RES=true;
  fi
  echo $RES;
}

function create_pg_docker() {
  local INNER_DATA_DIR=/var/lib/postgresql/data;
  local DOCKER_IMAGE="postgres";
  local IMAGE_VERSION="15.4";
  printf "creating container \"%s\" with user:\"%s\", password:\"%s\" on port:\"%s\"\n" "$CONTAINER_NAME" "$USER" "$PASS" "$PORT" >&2;
  RES=$({ docker container run -p "$PORT:5432" -v "$PG_DATA_DIR:$INNER_DATA_DIR" -e POSTGRES_USER="$USER" \
    -e POSTGRES_PASSWORD="$PASS" --name "$CONTAINER_NAME" -d "$DOCKER_IMAGE:$IMAGE_VERSION";} 2>&1);
  if [ "$(contains_substring "$RES" "error")" == true ]; then
    cleanup;
    fatal_error "$RES";
  fi
  sleep 2; # let postgres image entry point run
}

function configure_postgres() {
  local CONF_FILE="$PG_DATA_DIR/postgresql.conf";
  printf "configuring \"%s\" file: setting \"wal_level\" to \"logical\"\n" "$CONF_FILE" >&2;
  echo "wal_level = logical" >> "$CONF_FILE";
  printf "restarting \"%s\" container\n" "$CONTAINER_NAME" >&2;
  docker container restart "$CONTAINER_NAME" >/dev/null;
  sleep 2;
}

function exec_sql() {
  local DB_NAME="$1";
  local PSQL_COMMAND="$2";
  COMMAND="psql -U $USER -p 5432 -d $DB_NAME -c";
  printf "running sql command: \"%s\" on database \"%s\"\n" "$PSQL_COMMAND" "$DB_NAME" >&2;
  RES=$({ docker container exec "$CONTAINER_NAME" $COMMAND "$PSQL_COMMAND";} 2>&1);
}

USER="postgres"; # not secure for production
PASS="password"; # not secure for production
PORT=5555;
PG_DATA_DIR="$PWD/pg_data";
CONTAINER_NAME="pg15";
PRIMARY_DATABASE="production";
REPLICA_DATABASE="backup";
IS_CLEANING=${1-false};

if [ "$IS_CLEANING" != false ]; then
  cleanup;
  exit 0;
fi

exit_if_not_installed docker;
exit_if_not_installed tr;
create_pg_docker;
configure_postgres;

exec_sql postgres "create database $PRIMARY_DATABASE;";
exec_sql postgres "create database $REPLICA_DATABASE;";

exec_sql $PRIMARY_DATABASE "create schema shared;";
exec_sql $PRIMARY_DATABASE "create table shared.client (id int primary key, name varchar(20));";
# if a table does not have a primary key run: ALTER TABLE <schema>.<table> REPLICA IDENTITY FULL;
# logical replication is only suppoerted on tables. views, materialized views, functions, etc. are not supported
exec_sql $PRIMARY_DATABASE "insert into shared.client values (1, 'client01');";

exec_sql $PRIMARY_DATABASE "create publication ${PRIMARY_DATABASE}_pub for table shared.client;";
exec_sql $PRIMARY_DATABASE "select * from pg_create_logical_replication_slot('${REPLICA_DATABASE}_sub', 'pgoutput');";

exec_sql $REPLICA_DATABASE "create schema shared;";
exec_sql $REPLICA_DATABASE "create table shared.client (id int primary key, name varchar(20));";
# if a table does not have a primary key run: ALTER TABLE <schema>.<table> REPLICA IDENTITY FULL;
exec_sql $REPLICA_DATABASE "create subscription ${REPLICA_DATABASE}_sub connection 'dbname=$PRIMARY_DATABASE user=$USER password=$PASS host=localhost port=5432' publication ${PRIMARY_DATABASE}_pub with (create_slot=false);";
exec_sql $REPLICA_DATABASE "ALTER SUBSCRIPTION ${REPLICA_DATABASE}_sub ENABLE;";

exec_sql $PRIMARY_DATABASE "insert into shared.client values (2, 'client02');";
