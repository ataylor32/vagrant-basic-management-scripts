#!/bin/bash

function clear_screen {
	echo -en "\033c"
}

function end_script {
	echo
	echo "--------------------------------------------------------------------------------"
	echo
	read -p "Done. Press enter to exit this script."
}

clear_screen
here="`dirname \"$0\"`"
cd "$here"

if [ ! -s Vagrantfile ]; then
	echo "The \"Vagrantfile\" file wasn't found (or it was empty), so this script can't"
	echo "continue."
	end_script
	exit
fi

echo "Please wait while the virtual machine's status is determined..."
VAGRANT_STATUS=$(vagrant status --machine-readable)
VAGRANT_MACHINE_NAME=$(echo "$VAGRANT_STATUS" | sed "2!d" | awk -F ",*" '{print $2}')
VAGRANT_STATUS=$(echo "$VAGRANT_STATUS" | sed "2!d" | awk -F ",*" '{print $4}')

clear_screen
echo -n "The \"$VAGRANT_MACHINE_NAME\" virtual machine is currently "

case $VAGRANT_STATUS in
	not_created)
		echo -n "not created"
		;;
	poweroff)
		echo -n "powered off"
		;;
	aborted)
		echo -n "aborted -- it was abruptly stopped"
		;;
	running)
		echo -n "running"
		;;
	saved)
		echo -n "suspended"
		;;
esac

echo "."
echo
echo "Choose an action to perform:"
echo
echo "   1. Start the virtual machine"
echo "   2. Restart the virtual machine"
echo "   3. Suspend the virtual machine"
echo "   4. Shut down the virtual machine"
echo "   5. Destroy the virtual machine"
echo "   6. Display Vagrant version information"
echo "   7. Exit"
echo

while true; do
	read -p "Type a number and press enter: " num
	case $num in
		1)
			if [ "$VAGRANT_STATUS" != "running" ]; then
				vagrant up
				break
			else
				echo "The virtual machine is already running."
			fi
			;;
		2)
			if [ "$VAGRANT_STATUS" != "not_created" ]; then
				vagrant reload
				break
			else
				echo "The virtual machine hasn't been created, so it can't be restarted."
			fi
			;;
		3)
			if [ "$VAGRANT_STATUS" == "running" ]; then
				vagrant suspend
				break
			else
				echo "The virtual machine isn't running, so it can't be suspended."
			fi
			;;
		4)
			if [ "$VAGRANT_STATUS" == "running" ] || [ "$VAGRANT_STATUS" == "saved" ]; then
				vagrant halt
				break
			else
				echo "The virtual machine isn't running or suspended, so it can't be shut down."
			fi
			;;
		5)
			if [ "$VAGRANT_STATUS" != "not_created" ]; then
				vagrant destroy
				break
			else
				echo "The virtual machine hasn't been created, so it can't be destroyed."
			fi
			;;
		6)
			vagrant version
			break
			;;
		7)
			exit 0
			;;
		*)
			echo "Please enter a valid number."
	esac
done

end_script
