#!/bin/bash

# Check if the instance name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <tomcat9_instance_N> {start|stop|restart}"
  exit 1
fi

TOMCAT_INSTANCE=$1
TOMCAT_BIN_PATH="/opt/docm/${TOMCAT_INSTANCE}/bin"

# Function to stop Tomcat
stop_tomcat() {
  echo "Navigating to ${TOMCAT_BIN_PATH}"
  cd "${TOMCAT_BIN_PATH}" || exit
  echo "Stopping Tomcat instance"
  ./shutdown.sh

  echo "Verifying if Tomcat instance is stopped"
  TOMCAT_PIDS=$(ps -ef | grep tomcat | grep -v grep | awk '{print $2}')
  
  if [ -z "$TOMCAT_PIDS" ]; then
    echo "Tomcat instance is stopped"
  else
    echo "Killing remaining Tomcat processes"
    for PID in $TOMCAT_PIDS; do
      kill -9 "$PID"
    done
  fi
}

# Function to start Tomcat
start_tomcat() {
  echo "Navigating to ${TOMCAT_BIN_PATH}"
  cd "${TOMCAT_BIN_PATH}" || exit
  echo "Starting Tomcat instance"
  ./startup.sh

  echo "Verifying if Tomcat instance is started"
  ps -ef | grep tomcat | grep -v grep
}

# Main logic
case $2 in
  start)
    start_tomcat
    ;;
  stop)
    stop_tomcat
    ;;
  restart)
    stop_tomcat
    start_tomcat
    ;;
  *)
    echo "Usage: $0 <tomcat9_instance_N> {start|stop|restart}"
    exit 1
    ;;
esac
