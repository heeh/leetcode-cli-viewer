#!/bin/bash

HEIGHT=0
WIDTH=0
CHOICE_HEIGHT=10
BACKTITLE="Backtitle here"
TITLE="Title here"
MENU="Choose one of the following options:"

LIST_OPT=(1 "List Problems(Easy)"
          2 "List Problems(Medium)"
	  3 "Quit"
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
	break
    fi
}

function loadList() {
    local LIST_CHOICE=$1
    case $LIST_CHOICE in
	1)
	    leetcode list -q eD > prob_cache.txt
	    ;;
	2)
	    leetcode list -q mD > prob_cache.txt
	    ;;
	3)
	    clear
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
		leetcode pick "${PROB_NUMBER}" | fold -w 80 -s > prob.txt
		dialog --keep-tite --textbox prob.txt $HEIGHT $WIDTH
		;;
	    2)
		leetcode edit "${PROB_NUMBER}" > prob.txt
		;;
	    3)
		leetcode test "${PROB_NUMBER}" > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    4)
		leetcode exec "${PROB_NUMBER}" > prob.txt
		dialog --textbox prob.txt $HEIGHT $WIDTH
		;;
	    5)
		PROB_NUMBER=$(processList)
		;;
	    6)
		LIST_CHOICE=$(promptList)
		clear
		loadList $LIST_CHOICE	    
		;;
	    7)
		clear
		exit
		;;
	esac
    else
	PROB_NUMBER=""
	break
    fi
}


function main() {
    while true; do
    # If we have a problem number, process right away
    if [ -n "$PROB_NUMBER" ]
    then
	processProblem $PROB_NUMBER
	clear
    else
	# If we have a problem cache, open up the list
	if [ -e prob_cache.txt ]
	then
	    PROB_NUMBER=$(processList)
	    clear
	else
	    LIST_CHOICE=$(promptList)
	    clear
	    loadList $LIST_CHOICE
	    clear
	fi
    fi
    done
}

main

