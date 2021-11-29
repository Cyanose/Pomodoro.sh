#!/bin/bash
now=$(date +%s)
remainingTime=$(($end - $now))
decrementBy=$2
sound=($PWD/Bell.webm)

displayHelp(){
	echo "usage: pomodoro [options] [countdown refresh]"
	echo "where options are:"
	echo "-h display help"
	echo "-s or --short"
	echo "-l or --long"
	echo ""
	echo "[countdown refresh] determines how often will"
	echo "the output of the countdown timer refresh"
	echo "pass in the value in seconds here "
}

shortPomodoro(){
	echo "----------------------------------------"
	echo "            Pomodoro Session            "
	echo "----------------------------------------"
	shortSession=true
	end=$(date -d "+ 25 minutes" +%s)
	count
	notify
	pause
}
longPomodoro(){
	echo "----------------------------------------"
	echo "            Pomodoro Session            "
	echo "----------------------------------------"
	longSession=true
	end=$(date -d "+ 50 minutes" +%s)
	count
	notify
	pause
}

count(){
	while [ $now -lt $end ]
	do
	now=$(date +%s)
	remainingTime=$(($end - $now))
	if [ $(($remainingTime % $decrementBy)) == 0 ] 
	then
	echo $(date -d@$remainingTime -u +%H:%M:%S)
	fi
	sleep 1
	done
}

notify(){
	if [ "$shortBreak" == true ]
	then
		text="Pomodoro 5 minutes break has finished"
	elif [ "$shortSession" == true ]
	then
		#duration="25 minutes"
		text="Pomodoro 25 minutes session has finished"
	elif [ "$longBreak" == true ]
	then
		text="Pomodoro 10 minutes break has finished"
	elif [ "$longSession" == true ]
	then
		#duration="50 minutes"
		text="Pomodoro 50 minutes session has finished"
	fi
	notify-send "$text"
	mplayer $sound > /dev/null 2>&1
}

pause(){
	echo "----------------------------------------"
	echo "             Pomodoro Break             "
	echo "----------------------------------------"
	if [ "$shortSession" == true ]
	then 
		shortSession=false
		shortBreak=true
		end=$(date -d "+ 5 minutes" +%s)
		count
	elif [ "$longSession" == true ]
	then
		longSession=false
		longBreak=true
		end=$(date -d "+ 10 minutes" +%s)
		count
	fi
	notify
}

#help
if [ -z "$1" ] || [ "$1" == "-h" ]
then
	displayHelp
fi

# pomodoro short session
if [ "$1" == "-s" ] || [ "$1" == "--short" ]
then
	shortPomodoro
fi

#pomodoro long session
if [ "$1" == "-l" ] || [ "$1" == "--long" ]
then
	longPomodoro
fi
