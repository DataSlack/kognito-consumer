#!/bin/bash
# Run logstash from source
#
# This is most useful when done from a git checkout.
#
# Usage:
#   bin/logstash <command> [arguments]
#
# See 'bin/logstash --help' for a list of commands.
#
# Supported environment variables:
#   LS_JAVA_OPTS="xxx" to append extra options to the JVM options provided by logstash
#
# Development environment variables:
#   DEBUG=1 to output debugging information

unset CDPATH
# This unwieldy bit of scripting is to try to catch instances where Logstash
# was launched from a symlink, rather than a full path to the Logstash binary
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
      echo "You may need to launch Logstash with a full path instead of a symlink."
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
  LOGSTASH_VERSION_FILE2="${LOGSTASH_HOME}/versions.yml"
  if [ -f ${LOGSTASH_VERSION_FILE2} ]; then
    # this file is present for a git checkout type install
    # but its not in zip, deb and rpm artifacts (and in integration tests)
    LOGSTASH_VERSION="$(sed -ne 's/^consumer: \([^*]*\)$/\1/p' ${LOGSTASH_VERSION_FILE2})"
  else
    LOGSTASH_VERSION="Version not detected"
  fi
  echo "Kognito Consumer: $LOGSTASH_VERSION"
else
  unset CLASSPATH
  for J in $(cd "${LOGSTASH_JARS}"; ls *.jar); do
    CLASSPATH=${CLASSPATH}${CLASSPATH:+:}${LOGSTASH_JARS}/${J}
  done
  exec "${JAVACMD}" ${JAVA_OPTS} -cp "${CLASSPATH}" br.com.kognito.consumer.Consumer "$@"
fi