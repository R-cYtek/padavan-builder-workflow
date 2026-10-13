CFG_BASE="padavan-ng/trunk/configs/boards/TPLINK/TL_WR841N-V13_USB"
TPLINK_BASE="padavan-ng/trunk/configs/boards/TPLINK"
TOOLS_BASE="padavan-ng/trunk/tools/mktplinkfw"


# Откатываем BusyBox на стабильную ветку 1.36.x, чтобы избежать конфликтов из-за отключенного IPv6
if [ -d "$BBOX_BASE/busybox-1.36.0" ] || [ -d "$BBOX_BASE/busybox-1.36.1" ] || [ -f "$BBOX_BASE/Makefile" ]; then
  # Если в репозитории есть конфиг для 1.36, принудительно подменяем ссылку на него в Makefile
  sed -i 's/busybox-1.37.0/busybox-1.36.1/g' "$BBOX_BASE/Makefile" 2>/dev/null || true
  sed -i 's/busybox-1.37.0/busybox-1.36.0/g' "$BBOX_BASE/Makefile" 2>/dev/null || true
fi

# Универсальный фикс: если все же собирается 1.37, отключаем в нем проблемную сетевую утилиту 'ip' целиком
if [ -f "$BBOX_BASE/busybox-1.37.x.config" ]; then
  sed -i 's/CONFIG_IP=y/CONFIG_IP=n/' "$BBOX_BASE/busybox-1.37.x.config"
  sed -i 's/CONFIG_IPADDR=y/CONFIG_IPADDR=n/' "$BBOX_BASE/busybox-1.37.x.config"
  sed -i 's/CONFIG_IPLINK=y/CONFIG_IPLINK=n/' "$BBOX_BASE/busybox-1.37.x.config"
  sed -i 's/CONFIG_IPROUTE=y/CONFIG_IPROUTE=n/' "$BBOX_BASE/busybox-1.37.x.config"
fi


# kernel config
sed -i \
  -e 's/^CONFIG_RT2880_FLASH_8M=y/# CONFIG_RT2880_FLASH_8M is not set/' \
  -e 's/^# CONFIG_RT2880_FLASH_16M is not set/CONFIG_RT2880_FLASH_16M=y/' \
  "$CFG_BASE/kernel-3.4.x.config"

# board.mk
sed -i 's/TPLINK_FLASHLAYOUT=8Mmtk/TPLINK_FLASHLAYOUT=16Mmtk/' \
  "$CFG_BASE/board.mk"

# partition table
sed -i \
  -e 's/size:[[:space:]]*0x780000/size: 0xF80000/' \
  -e 's/offset:[[:space:]]*0x7A0000/offset: 0xFA0000/' \
  -e 's/offset:[[:space:]]*0x7C0000/offset: 0xFC0000/' \
  -e 's/offset:[[:space:]]*0x7D0000/offset: 0xFD0000/' \
  -e 's/offset:[[:space:]]*0x7E0000/offset: 0xFE0000/' \
  -e 's/offset:[[:space:]]*0x7F0000/offset: 0xFF0000/' \
  "$TPLINK_BASE/pt_tplink_8m.config"

# mktplinkfw
sed -i \
  -e 's/\.id[[:space:]]*=[[:space:]]*"8Mmtk"/.id = "16Mmtk"/' \
  -e 's/\.fw_max_len[[:space:]]*=[[:space:]]*0x7a0000/.fw_max_len = 0xf80000/' \
  "$TOOLS_BASE/mktplinkfw2.c"
