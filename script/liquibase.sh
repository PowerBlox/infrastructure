#!/bin/bash
#
# run liquibase commands against a mysql database
# check https://www.liquibase.org/documentation/command_line.html for options
#

HERE=$(cd `dirname $0` && pwd)
LIQUIBASE_DIR="$HERE/../liquibase"

set -e

: ${MYSQL_USERNAME?Need to be defined}
: ${MYSQL_PASSWORD?Need to be defined}
: ${MYSQL_DATABASE?Need to be defined}
: ${MYSQL_HOST?Need to be defined}
: ${MYSQL_PORT?Need to be defined}

if [ $# -lt 1 ]; then
  echo "Usage: $0 <liquibase command>"
  echo "Example: $0 update"
  echo "Example: $0 status"
  echo "Example: $0 rollbackCount 1"
  exit 1
fi

function liquibase() {
  java -jar $LIQUIBASE_DIR/lib/liquibase-core-3.5.3.jar \
    --changeLogFile="$LIQUIBASE_DIR/changeLog-master.xml" \
    --username="$MYSQL_USERNAME" \
    --password="$MYSQL_PASSWORD" \
    --url="$MYSQL_URL" \
    --classpath="$LIQUIBASE_DIR/lib/mysql-connector-java-5.1.38.jar" \
    --driver="com.mysql.jdbc.Driver" \
    --logLevel="info" \
    $*
}

MYSQL_URL="jdbc:mysql://$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DATABASE?useSSL=false&nullNamePatternMatchesAll=true&serverTimezone=UTC"
echo "running 'liquibase $*' against url $MYSQL_URL"
liquibase $*
