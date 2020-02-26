#!/bin/bash
STATEFILE=/var/www/html/.skip_elasticsearch_indexing
pgrep -af fulltextsearch | grep -qv grep
if [ $? -ne 0 ]
then
    if ! test -f $STATEFILE
    then
        su -c "php /var/www/html/occ fulltextsearch:index -q" -s "/bin/bash" www-data
        touch $STATEFILE
    fi
    nohup su -c "php /var/www/html/occ fulltextsearch:live -q" -s "/bin/bash" www-data &>/dev/null &
fi

trap "{ echo EXITING; pkill -f -SIGTERM 'fulltextsearch'; }" SIGKILL SIGTERM

while pgrep -af fulltextsearch | grep -qv grep:
do
        sleep 1	# This script is not really doing anything.
done
