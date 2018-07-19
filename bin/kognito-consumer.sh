#!/bin/bash
# Run KOGNITO CONSUMER from source
#
# This is most useful when done from a git checkout.
#
# Usage:
#   bin/kognito-consumer.sh <command> [arguments]
#
# See 'bin/kognito-consumer.sh --help' for a list of commands.
#
# Supported environment variables:
#   LS_JAVA_OPTS="xxx" to append extra options to the JVM options provided by Kognito Consumer
#
# Development environment variables:
#   DEBUG=1 to output debugging information

unset CDPATH
# This unwieldy bit of scripting is to try to catch instances where Consumer
# was launched from a symlink, rather than a full path to the Consumer binary
if [ -L "$0" ]; then
  # Launched from a symlink
  # --Test for the readlink binary
  RL="$(command -v readlink)"
  if [ $? -eq 0 ]; then
    # readlink exists
    SOURCEPATH="$(${RL} $0)"
  else
    # readlink not found, attempt to parse the output of stat
    SOURCEPATH="$(stat -c %N $0 | awk '{print $3}' | sed -e 's/\‘//' -e 's/\’//')"
    if [ $? -ne 0 ]; then
      # Failed to execute or parse stat
      echo "Failed to find source library at path $(cd `dirname $0`/..; pwd)/bin/consumer.lib.sh"
      echo "You may need to launch Kognito Consumer with a full path instead of a symlink."
      exit 1
    fi
  fi
else
  # Not a symlink
  SOURCEPATH="$0"
fi

. "$(cd `dirname ${SOURCEPATH}`/..; pwd)/bin/consumer.lib.sh"
setup

if [ "$1" = "-V" ] || [ "$1" = "--version" ]; then
  CONSUMER_VERSION_FILE2="${CONSUMER_HOME}/versions.yml"
  if [ -f ${CONSUMER_VERSION_FILE2} ]; then
    # this file is present for a git checkout type install
    # but its not in zip, deb and rpm artifacts (and in integration tests)
    CONSUMER_VERSION="$(sed -ne 's/^consumer: \([^*]*\)$/\1/p' ${CONSUMER_VERSION_FILE2})"
  else
    CONSUMER_VERSION="Version not detected"
  fi
  echo "Kognito Consumer: $CONSUMER_VERSION"
else
  unset CLASSPATH
  for J in $(cd "${LOGSTASH_JARS}"; ls *.jar); do
    CLASSPATH=${CLASSPATH}${CLASSPATH:+:}${LOGSTASH_JARS}/${J}
  done
  exec "${JAVACMD}" ${JAVA_OPTS} -cp "${CLASSPATH}" br.com.kognito.consumer.Consumer "$@"
fi