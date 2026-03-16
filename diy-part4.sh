#!/bin/bash

# turboacc
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh --no-sfe
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh


# OpenClash
git clone --depth 1 https://github.com/vernesong/OpenClash.git OpenClash




echo "===== 直接覆盖 feeds.conf.default 为新配置 ====="
cat > feeds.conf.default << 'EOF'
src-git packages https://github.com/immortalwrt/packages.git;openwrt-25.12
src-git luci https://github.com/immortalwrt/luci.git;openwrt-25.12
src-git routing https://github.com/openwrt/routing.git;openwrt-25.12
src-git telephony https://github.com/openwrt/telephony.git;openwrt-25.12
src-git video https://github.com/openwrt/video.git;openwrt-25.12
src-git qmodem https://github.com/FUjr/QModem.git;main
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git small https://github.com/kenzok8/small
src-git rtp https://github.com/xuanranran/openwrt-rtp2httpd
src-git easytier https://github.com/EasyTier/luci-app-easytier.git
EOF

echo "===== 替换后的 feeds.conf.default 内容 ====="
cat feeds.conf.default

echo "===== feeds.conf.default 覆盖完成 ====="


