#!/bin/bash

TEXT_WIDTH=80

HEIGHT=0
WIDTH=0
CHOICE_HEIGHT=10
BACKTITLE=""
TITLE=""
MENU="Choose one of the following options:"

LIST_OPT=(1 "TODO Locked Easy"
          2 "TODO Locked Medium"
	  3 "DONE Easy"
	  4 "DONE Medium"
	  5 "Statatistics"
	  6 "Quit"
	 )

PROB_OPT=(1 "Show Problem"
          2 "Edit Solution"
	  3 "Test Solution"
	  4 "Submit Solution"
	  5 "Change Problem"
	  6 "Change Problem List"
	  7 "Quit"
	 )


function promptList() {
    LIST_CHOICE=$(dialog --clear \
			 --backtitle "$BACKTITLE" \
			 --title "$TITLE" \
			 --menu "$MENU" \
			 $HEIGHT $WIDTH $CHOICE_HEIGHT \
			 "${LIST_OPT[@]}" \
			 2>&1 >/dev/tty)
    if [ $? -eq 0 ]
    then
	echo $LIST_CHOICE
    else
	PROB_NUMBER=""
	rm prob.txt
	rm prob_cache.txt	
	break
    fi
}

function loadList() {
    local LIST_CHOICE=$1
    case $LIST_CHOICE in
	1)
	    leetcode list -q leD > prob_cache.txt
	    ;;
	2)
	    leetcode list -q lmD > prob_cache.txt
	    ;;
	3)
	    leetcode list -q ed > prob_cache.txt
	    ;;
	4)
	    leetcode list -q md > prob_cache.txt
	    ;;
	5)
	    leetcode stat > stat.txt
	    dialog --textbox stat.txt $HEIGHT $WIDTH
	    rm stat.txt
	    ;;		
	6)
	    clear
	    rm prob_cache.txt
	    exit
	    ;;	
    esac
}

function processList() {
    PROBLEMS=()
    while read -r s ; do
	index=$(echo "$s" | grep -o -E '[0-9]+' | head -1 )
	PROBLEMS+=("$index" "${s}")
    done < prob_cache.txt
    PROB_NUMBER=$(dialog --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT \
			 "${PROBLEMS[@]}" \
			 2>&1 >/dev/tty)
    if [ $? -eq 0 ]
    then
	echo $PROB_NUMBER
    else
	PROB_NUMBER=""
	rm prob.txt
	rm prob_cache.txt	
	break
    fi
}

function processProblem() {
    PROB_NUMBER=$1
    PROB_ACTION=$(dialog --menu "Problem Number: $PROB_NUMBER" $HEIGHT $WIDTH $CHOICE_HEIGHT \
			 "${PROB_OPT[@]}" \
			 2>&1 >/dev/tty)
    if [ $? -eq 0 ]
    then
	case $PROB_ACTION in
	    1)
		#	    leetcode pick "${PROB_NUMBER}" > prob.txt
		clear
		leetcode pick "${PROB_NUMBER}" | fold -w $TEXT_WIDTH -s > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    2)
		leetcode edit "${PROB_NUMBER}" > prob.txt
		;;
	    3)
		clear
		leetcode test "${PROB_NUMBER}" | fold -w $TEXT_WIDTH -s > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    4)
		clear
		leetcode exec "${PROB_NUMBER}" | fold -w $TEXT_WIDTH -s > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    5)
		PROB_NUMBER=""
		rm prob.txt
		;;
	    6)
		PROB_NUMBER=""
		rm prob.txt
		rm prob_cache.txt
		break
		;;

	    8)
		rm prob.txt
		rm prob_cache.txt
		rm stat.txt
		clear
		exit
		;;
	esac
    else
	PROB_NUMBER=""
	rm prob.txt
	rm prob_cache.txt
	break
    fi
}


function main() {
    while true; do
	if [ -e prob_cache.txt ]
	    then
		if [ ! -z "$PROB_NUMBER" ]  
		then
		    processProblem $PROB_NUMBER
		    clear
		else # no problem selected yet
		    PROB_NUMBER=$(processList)
		    clear
		fi
	else
	    PROB_NUMBER=""
	    LIST_CHOICE=$(promptList)
	    loadList $LIST_CHOICE

	fi
    done
}
 
main

