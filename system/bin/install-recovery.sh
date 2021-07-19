#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:13178156:f0bbb2353f5288c9c60ac95e26136b4d773636c1; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:12401960:4790cd18e1624a343cdb17ac467bfe42c514db8d EMMC:/dev/block/bootdevice/by-name/recovery f0bbb2353f5288c9c60ac95e26136b4d773636c1 13178156 4790cd18e1624a343cdb17ac467bfe42c514db8d:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
