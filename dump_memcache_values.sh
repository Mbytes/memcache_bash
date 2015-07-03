#!/bin/bash
#

#Vuelva variables IPWP y muestra valor

#Ruta programas
NAME=$(basename $0)
PRG=$(echo "$0" | sed -e "s/${NAME}//")


echo ${PRG}

KEYS=$(${PRG}/dump_memcache.sh |grep ITEM | awk '{print $2}')

#Leemos Variable Multiline
while read -r LINE
do
  #echo "$LINE"
    
  #Muestra valor
  VALOR=$(echo "get ${LINE} XNB" | sed -e "s/XNB/\nquit/" | nc localhost 11211| tail -2 | head -1)
  
  echo "${LINE} = ${VALOR}"

done <<< "${KEYS}"