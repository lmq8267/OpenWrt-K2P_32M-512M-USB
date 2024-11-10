#!/bin/bash
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

#添加科学上网源
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall

#添加自定义的软件包源
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages ddns-go
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-ddns-go
#git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo
#git clone --depth=1 https://github.com/sirpdboy/NetSpeedTest package/NetSpeedTest
git clone -b v5-lua --single-branch --depth 1 https://github.com/sbwml/luci-app-mosdns package/mosdns
#git clone -b lua --single-branch --depth 1 https://github.com/sbwml/luci-app-alist package/alist
#git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git package/lucky
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# 修改默认主题为QWRT同款luci-theme-design
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile

# 修改默认管理IP地址
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

##### K2P-32M修改编译文件 ######
sed -i 's/"Phicomm K2P";/"Phicomm K2P-32M";/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i '/spi-max-frequency/a\\t\tbroken-flash-reset;' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i 's/<0xa0000 0xf60000>/<0xa0000 0x1fb0000>/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i 's/15744k/32448k/g' target/linux/ramips/image/mt7621.mk
