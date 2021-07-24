#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:13200684:f770353c9a9bbda3dadb046c9c36886d3c085cd1; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:12424488:9a454b39fdb669e9303724a5e0c1f1619af12610 EMMC:/dev/block/bootdevice/by-name/recovery f770353c9a9bbda3dadb046c9c36886d3c085cd1 13200684 9a454b39fdb669e9303724a5e0c1f1619af12610:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
