#!/bin/bash

pgrep -af fulltextsearch | grep -qv grep || { su -c "php /var/www/html/occ fulltextsearch:index -q" -s "/bin/bash" www-data; }
pgrep -af fulltextsearch | grep -qv grep || nohup su -c "php /var/www/html/occ fulltextsearch:live -q" -s "/bin/bash" www-data &>/dev/null &

trap "{ echo EXITING; pkill -f -SIGTERM 'fulltextsearch'; }" SIGKILL SIGTERM

while pgrep -af fulltextsearch | grep -qv grep:
do
        sleep 1	# This script is not really doing anything.
done
