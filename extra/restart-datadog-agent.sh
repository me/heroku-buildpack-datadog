#!/bin/bash

if [[ $DISABLE_DATADOG_AGENT ]]; then
  echo "DISABLE_DATADOG_AGENT environment variable is set, not starting the agent."
  exit 0
fi

# Update integration directory configuration
sed -i -e"s/^.*UNIX_CONFIG_PATH =.*$/UNIX_CONFIG_PATH = '\/app\/.apt\/opt\/datadog-agent\/agent'/" /app/.apt/opt/datadog-agent/agent/config.py

(
  # Load our library path first when starting up
  export LD_LIBRARY_PATH=/app/.apt/opt/datadog-agent/embedded/lib:$LD_LIBRARY_PATH
  mkdir -p /tmp/logs/datadog
  exec /app/.apt/opt/datadog-agent/embedded/bin/python /app/.apt/opt/datadog-agent/agent/agent.py restart
)
