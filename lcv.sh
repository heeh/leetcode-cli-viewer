#!/bin/bash

HEIGHT=60
WIDTH=120
CHOICE_HEIGHT=10
BACKTITLE="Backtitle here"
TITLE="Title here"
MENU="Choose one of the following options:"

OPTIONS=(1 "List Google(Easy)"
         2 "List Google(Medium)"
	 3 "leetcode test"
         4 "leetcode submit")

PROB_OPT=(1 "Download Source"
          2 "Show Problem"
	  3 "Test Problem"
          4 "Submit..!!")


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
	    #		PROBLEMS+=($n "$s")
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
		# g: generate source file x: add descrption to source file
		leetcode show "${PROB}" > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    2)
		leetcode show "${PROB}"
		;;
	    3)
		leetcode test 
		;;
	    4)
		leetcode submit "{PROB}"
		;;
	esac
	;;
    2)
	leetcode list -q m -t google
        ;;
    3)
        ;;
    4)
	;;
esac
    
