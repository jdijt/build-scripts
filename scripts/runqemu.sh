#!/usr/bin/env zsh

QEMU_IMG=`realpath $1`
OUTPUT=$HOME/Development/MSc_thesis/gnuarm-qemu/qemu/output
QEMU=$OUTPUT/qemu/bin/qemu-system-gnuarmeclipse

unset -v latest
for file in ${OUTPUT}/gnuarmeclipse-qemu-debian64-*.tgz(N); do
    [[ ! -e $latest ]] && latest=$file;
    [[ $file -nt $latest ]] && latest=$file;
done

if [[ ! ( -e $latest || -e ${QEMU} ) ]] 
then
    echo "No latest build and no qemu executable."
fi


if [[ ! -e $QEMU || $latest -nt $QEMU ]] 
then
    echo "Unpacking (new) build."
    rm -rf ${OUTPUT}/qemu 
    mkdir -p ${OUTPUT}/qemu

    tar --strip-components=2 -xz \
        -f ${latest} \
        -C ${OUTPUT}/qemu
    
    rm -f ${latest} $OUTPUT/*.md5
fi


${QEMU} -mcu NRF51822 -board generic \
    -image ${QEMU_IMG} \
    -verbose -verbose \
    -d unimp,guest_errors
