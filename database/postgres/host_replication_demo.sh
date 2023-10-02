#!/bin/bash

function cleanup() {
  local CONTAINER_NAME="$1";
  local DATA_DIR="$2";
  printf "removing container \"%s\"\n" "$CONTAINER_NAME" >&2;
  docker container rm -f "$CONTAINER_NAME";
  printf "removing data directory: \"%s\"\n" "$DATA_DIR" >&2;
  rm -r "$DATA_DIR";
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
  local CONTAINER_NAME="$1";
  local PORT="$2";
  local DATA_DIR="$3";
  local INNER_DATA_DIR=/var/lib/postgresql/data;
  local DOCKER_IMAGE="postgres";
  local IMAGE_VERSION="15.4";
  printf "creating container \"%s\" with user:\"%s\", password:\"%s\" on port:\"%s\"\n" "$CONTAINER_NAME" "$USER" "$PASS" "$PORT" >&2;
  RES=$({ docker container run -p "$PORT:5432" -v "$DATA_DIR:$INNER_DATA_DIR" -e POSTGRES_USER="$USER" \
    -e POSTGRES_PASSWORD="$PASS" --name "$CONTAINER_NAME" --network "$NETWORK_NAME" -d "$DOCKER_IMAGE:$IMAGE_VERSION";} 2>&1);
  if [ "$(contains_substring "$RES" "error")" == true ]; then
    cleanup "$CONTAINER_NAME" "$DATA_DIR";
    fatal_error "$RES";
  fi
  sleep 2; # let postgres image entry point run
}

function configure_postgres_primary_async() {
  local HBA_FILE="$PG_DATA_DIR_PRIMARY/pg_hba.conf";
  printf "configuring \"%s\" file\n" "$HBA_FILE" >&2;
  echo "host      replication      $USER       all     md5" >> "$HBA_FILE";
  printf "restarting \"%s\" container\n" "$CONTAINER_NAME_PRIMARY" >&2;
  docker container restart "$CONTAINER_NAME_PRIMARY" >/dev/null;
  sleep 2;
}

function configure_postgres_primary_sync() {
  local CONF_FILE="$PG_DATA_DIR_PRIMARY/postgresql.conf";
  printf "configuring \"%s\" file\n" "$CONF_FILE" >&2;
    echo "synchronous_standby_names = 'first 1 ($STANDBY_APP_NAME)'" >> "$CONF_FILE";
}

function configure_postgres_standby() {
  docker container stop "$CONTAINER_NAME_STANDBY" >/dev/null;
  rm -R "$PG_DATA_DIR_STANDBY";
  sleep 1;
  cp -R "$PG_DATA_DIR_PRIMARY" "$PG_DATA_DIR_STANDBY";
  sleep 1;
  local CONF_FILE="$PG_DATA_DIR_STANDBY/postgresql.conf";
  printf "configuring \"%s\" file\n" "$CONF_FILE" >&2;
  echo "primary_conninfo = 'application_name=$STANDBY_APP_NAME host=$CONTAINER_NAME_PRIMARY port=5432 user=$USER password=$PASS'" >> "$CONF_FILE";
  touch "$PG_DATA_DIR_STANDBY/standby.signal";
  docker container start "$CONTAINER_NAME_STANDBY" >/dev/null;
  sleep 1;
}

function exec_sql() {
  local CONTAINER_NAME="$1";
  local DB_NAME="$2";
  local PSQL_COMMAND="$3";
  COMMAND="psql -U $USER -p 5432 -d $DB_NAME -c";
  printf "running sql command: \"%s\" on database \"%s\"\n" "$PSQL_COMMAND" "$DB_NAME" >&2;
  RES=$({ docker container exec "$CONTAINER_NAME" $COMMAND "$PSQL_COMMAND";} 2>&1);
}

NETWORK_NAME="replication";
USER="postgres"; # not secure for production
PASS="password"; # not secure for production
PORT_PRIMARY=5443;
PORT_STANDBY=5444
STANDBY_APP_NAME="standby01";
PG_DATA_DIR_PRIMARY="$PWD/pg_data_primary";
PG_DATA_DIR_STANDBY="$PWD/pg_data_standby";
CONTAINER_NAME_PRIMARY="pg15primary";
CONTAINER_NAME_STANDBY="pg15standby";
DATABASE_NAME="production";
IS_CLEANING=${1-false};
IS_SYNCED=${2-false};

if [ "$IS_CLEANING" != false ]; then
  cleanup "$CONTAINER_NAME_PRIMARY" "$PG_DATA_DIR_PRIMARY";
  cleanup "$CONTAINER_NAME_STANDBY" "$PG_DATA_DIR_STANDBY";
  sleep 1;
  docker network rm "$NETWORK_NAME";
  exit 0;
fi

exit_if_not_installed docker;
exit_if_not_installed tr;
printf "creating network \"%s\"\n" "$NETWORK_NAME" >&2; docker network create -d bridge "$NETWORK_NAME";
create_pg_docker "$CONTAINER_NAME_PRIMARY" "$PORT_PRIMARY" "$PG_DATA_DIR_PRIMARY";
create_pg_docker "$CONTAINER_NAME_STANDBY" "$PORT_STANDBY" "$PG_DATA_DIR_STANDBY";
configure_postgres_standby;
if [ "$IS_SYNCED" != false ]; then
  configure_postgres_primary_sync;
fi
configure_postgres_primary_async;
docker container restart "$CONTAINER_NAME_STANDBY";

exec_sql "$CONTAINER_NAME_PRIMARY" postgres "create database $DATABASE_NAME;";
exec_sql "$CONTAINER_NAME_PRIMARY" "$DATABASE_NAME" "create schema shared;";
exec_sql "$CONTAINER_NAME_PRIMARY" "$DATABASE_NAME" "create table shared.client (id int primary key, name varchar(20));";
exec_sql "$CONTAINER_NAME_PRIMARY" "$DATABASE_NAME" "insert into shared.client values (1, 'client01')";
exec_sql "$CONTAINER_NAME_PRIMARY" "$DATABASE_NAME" "insert into shared.client values (2, 'client02')";
