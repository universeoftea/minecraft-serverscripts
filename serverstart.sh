#!/bin/bash

cd $(dirname $0)
exec java -Xmx$1 -Xms$1 -jar server.jar nogui
