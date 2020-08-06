#!/bin/bash

set -e

save_lib="ld-2.31.so libc-2.31.so libpthread-2.31.so libthread_db-1.0.so"

cd /lib

for LIB in $save_lib; do
    objcopy --only-keep-debug $LIB $LIB.dbg 
    strip --strip-unneeded $LIB
    objcopy --add-gnu-debuglink=$LIB.dbg $LIB 
done    

save_usrlib="libquadmath.so.0.0.0 libstdc++.so.6.0.27
             libitm.so.1.0.0 libatomic.so.1.2.0" 

cd /usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug $LIB $LIB.dbg
    strip --strip-unneeded $LIB
    objcopy --add-gnu-debuglink=$LIB.dbg $LIB
done

unset LIB save_lib save_usrlib

exec /tools/bin/bash -c "
    /tools/bin/find /usr/lib -type f -name \*.a \
        -exec /tools/bin/strip --strip-debug {} ';'

    /tools/bin/find /lib /usr/lib -type f \( -name \*.so* -a ! -name \*dbg \) \
       -exec /tools/bin/strip --strip-unneeded {} ';'

    /tools/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
        -exec /tools/bin/strip --strip-all {} ';'

    rm -rf /tmp/*
"
