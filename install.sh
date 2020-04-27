## Ready to use kernel installation script by @AXON
## For proper develoer documentation, visit https://supreme-gamers.com/gearlock
# Check `!zygote.sh` to configure your package functions or gearlock can also guide you during the build process.

#####--- Import Functions ---#####
get_base_dir # Returns execution directory path in $BD variable
#####--- Import Functions ---#####

do_comm_job(){
	gclone "$BD/system" /
	geco "\n+ Backing up your current kernel zimage"; sleep 1
	if [ -e "$GRROOT/rescue.kernel" ]; then
		geco "+ Your stock kernel zimage is already backed up as rescue.kernel\n"
	else
		mv $GRROOT/kernel $GRROOT/rescue.kernel
		geco "+ Your stock kernel zimage is renamed from kernel to rescue.kernel\n"
	fi
	rsync -a "$BD/kernel" "$GRROOT" && chmod 777 "$GRROOT/kernel" && sleep 1.5
	geco "\n- Your system will reboot after 20 seconds. ${RED}Read the information below!${RC}"; sleep 1; source "$BD"/'!zygote.sh'
	geco "\n- In case if your system is not booting with ${YELLOW}${NAME}-${VERSION}${RC} on your hardware,"
	geco "\n- then you can rename ${PURPLE}rescue.kernel${RC} to ${GREEN}kernel${RC} on your android_x86 partition to boot with your old kernel ..."; sleep 20
	# Cleanup package firmware if exists before gearlock gen_unins
	[ -d "$BD/system/lib/firmware" ] && rm -r "$BD/system/lib/firmware"
}

if [ -d "$BD/system/lib/firmware" ]; then
	geco "This kernel package also provides additional firmware."
	while true; do
		read -n1 -p "$(geco "Do you want to upgrade the ${BLUE}firmware${RC} through this kernel package? [${GREEN}Y${RC}/n]") " c

		case $c in
			[Yy]* )
				geco "\n+ Backing up stock firmware blobs"; cd /system/lib && nout garca a -m0=lzma2 -mx=3 $DEPDIR/firmware.bak firmware
				geco "\n+ Deleting /system/firmware" && rm -r /system/lib/firmware
				geco "\n+ Placing the kernel module and firmware files into your system" && do_comm_job
				break
				;;

			[Nn]* )
				geco "\n+ Placing the kernel module files into your system" && do_comm_job
				break
				;;
			* ) geco "\n- Enter either ${GREEN}y${RC}es or no" ;;
		esac
	done

else
	geco "\n+ Placing the kernel module files into your system" && do_comm_job
fi

# Clear dalvik-cache
	geco "\n+ Clearing dalvik-cache ..."
	[ -d "/data/dalvik-cache" ] && rm -rf /data/dalvik-cache/*
