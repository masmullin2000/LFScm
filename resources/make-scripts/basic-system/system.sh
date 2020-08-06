#!/bin/bash

set -e

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

for i in {1..29}
do
	cd /sources && /basic-system/$i.*.sh || exit
done

exec /bin/bash --login +h -c "/basic-system/system-2.sh"
