#!/bin/sh
# ncm.sh - Switch between NCM / ECM / RNDIS modes

MODE=${1:-rndis}

up_mode() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

cd /sys/kernel/config/usb_gadget || exit 1

if command -v gc >/dev/null 2>&1; then
    echo "Cleaning old gadget with gc -c..."
    gc -c >/dev/null 2>&1
else
    echo "gc not found, cleaning manually..."
fi

if [ -d g1 ]; then
    cd g1
    echo "" > UDC 2>/dev/null
    rm configs/c.1/ncm.usb0 2>/dev/null
    rm configs/c.1/ecm.usb0 2>/dev/null
    rm configs/c.1/rndis.usb0 2>/dev/null
    rmdir configs/c.1 2>/dev/null
    rmdir functions/ncm.usb0 2>/dev/null
    rmdir functions/ecm.usb0 2>/dev/null
    rmdir functions/rndis.usb0 2>/dev/null
    rmdir strings/0x409 2>/dev/null
    cd ..
    rmdir g1
fi

mkdir g1 && cd g1

echo 0x1d6b > idVendor
echo 0x0104 > idProduct
mkdir -p strings/0x409
echo 0x01010101 > strings/0x409/serialnumber
echo "MyCompany" > strings/0x409/manufacturer
echo "$(up_mode "$MODE") Gadget" > strings/0x409/product

mkdir configs/c.1
echo 0x80 > configs/c.1/bmAttributes
echo 250 > configs/c.1/MaxPower

case "$MODE" in
    ncm)
        mkdir functions/ncm.usb0
        echo "6a:c3:55:41:52:d3" > functions/ncm.usb0/host_addr
        echo "9a:4e:90:fa:e5:5b" > functions/ncm.usb0/dev_addr
        ln -s functions/ncm.usb0 configs/c.1/
        ;;
    ecm)
        mkdir functions/ecm.usb0
        ln -s functions/ecm.usb0 configs/c.1/
        ;;
    rndis)
        mkdir functions/rndis.usb0
        ln -s functions/rndis.usb0 configs/c.1/
        ;;
    *)
        echo "Unknown mode: $MODE, use ncm|ecm|rndis"
        cd .. && rmdir g1
        exit 1
        ;;
esac

echo "ci_hdrc.0" > UDC
echo "Switched to $(up_mode "$MODE") mode"
echo "$MODE" > /etc/net_mode
