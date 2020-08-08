## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Auto uninstallation generation is disabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh

# Define vars
KMODDIR="/system/lib/modules"
FIRMDIR="/system/lib/firmware"
DALVIKDIR="/data/dalvik-cache"

# Restore stock kernel image
if [ -f "$KERNEL_IMAGE.rescue" ]; then
	geco "\n+ Restoring stock kernel image ..." && sleep 1
	mv "$KERNEL_IMAGE.rescue" "$KERNEL_IMAGE" || geco "\n++++ Error: Failed to restore stock kernel image" && return 101
fi

# Restore stock modules/firmware dir
for tget in $KMODDIR $FIRMDIR; do
	if [ -d $tget.old ]; then
		geco "\n+ Restoring stock $(basename $tget) ..."
		rm -rf $tget && mv $tget.old $tget || geco "\n++++ Error: Failed to restore stock $(basename $tget)" && return 101
	fi
done

# Clear dalvik-cache
[ -d "$DALVIKDIR" ] && geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot ..." && rm -rf $DALVIKDIR/*
