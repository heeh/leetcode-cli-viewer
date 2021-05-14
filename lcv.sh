#!/bin/bash

HEIGHT=60
WIDTH=120
CHOICE_HEIGHT=10
BACKTITLE="Backtitle here"
TITLE="Title here"
MENU="Choose one of the following options:"

OPTIONS=(1 "List Google(Easy)"
         2 "List Google(Medium)")

PROB_OPT=(1 "Show Problem "
          2 "Show Problem + Download Source"
	  3 "Show Problem + Download Source + Add Description to source"
	 )

#function menu_prompt() {
CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
clear
case $CHOICE in
    1)
	leetcode list -q e -t google > list.txt
	PROBLEMS=()
	while read n s ; do
	    PROBLEMS+=("${s:2:3}" "${s:7}")
	done < list.txt
	PROB=$(dialog --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${PROBLEMS[@]}" \
			2>&1 >/dev/tty)
	PROB_CHOICE=$(dialog --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT \
			       "${PROB_OPT[@]}" \
			       2>&1 >/dev/tty) 
	case $PROB_CHOICE in
	    1)
		leetcode show "${PROB}"  > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    2)
		leetcode show "${PROB} -g" > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    3)
		leetcode show "${PROB} -gx" > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;		
	esac
	;;
    2)
	leetcode list -q m -t google > list.txt
	PROBLEMS=()
	while read n s ; do
	    PROBLEMS+=("${s:2:3}" "${s:7}")
	done < list.txt
	PROB=$(dialog --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${PROBLEMS[@]}" \
			2>&1 >/dev/tty)
	PROB_CHOICE=$(dialog --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT \
			       "${PROB_OPT[@]}" \
			       2>&1 >/dev/tty) 
	case $PROB_CHOICE in
	    1)
		leetcode show "${PROB}"  > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    2)
		leetcode show "${PROB} -g" > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    3)
		leetcode show "${PROB} -gx" > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;		
	esac	
        ;;
esac
