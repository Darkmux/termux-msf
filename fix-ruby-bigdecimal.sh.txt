#!/data/data/com.termux/files/usr/bin/sh
##
##  Fix linking error for Ruby Bigdecimal
##  native extensions.
##

apt install -yq patchelf

for i in aarch64-linux-android arm-linux-androideabi \
    i686-linux-android x86_64-linux-android; do

    if [ -e "$PREFIX/lib/ruby/2.6.0/${i}/bigdecimal.so" ]; then
        if [ -n "$(patchelf --print-needed "$PREFIX/lib/ruby/2.6.0/${i}/bigdecimal/util.so" | grep bigdecimal.so)" ]; then
            exit 0
        fi

        patchelf --add-needed \
            "$PREFIX/lib/ruby/2.6.0/${i}/bigdecimal.so" \
            "$PREFIX/lib/ruby/2.6.0/${i}/bigdecimal/util.so"
    fi
done
