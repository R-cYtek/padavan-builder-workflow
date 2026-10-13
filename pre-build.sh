CFG_BASE="padavan-ng/trunk/configs/boards/TPLINK/TL_WR840N-V4_USB"
TPLINK_BASE="padavan-ng/trunk/configs/boards/TPLINK"
TOOLS_BASE="padavan-ng/trunk/tools/mktplinkfw"

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
