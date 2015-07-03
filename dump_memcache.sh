#!/bin/bash
#


#Control Numero parametros
if test x = ${1}x
then
        echo "ERROR FALTAN PARAMETROS"
        echo "Prefijos:"
        echo "IPWP	IPFirewall "
        echo "GEIP	Geoip"
        echo "$0 [PREFIJO|IPWP|GEIP]"
        exit    
fi

PREFIX=$1

#Crea variable para ver estadisticas
read -d '' STATS <<- "_EOF_"
stats items
quit
_EOF_


function RecuperaSLABS ()
{

read -d '' RSLAB <<- "_EOF_"
stats cachedump DATA01 DATA02
quit
_EOF_

#Crea estadisticas y filtra
echo "${RSLAB}" | sed -e "s/DATA01/$1/" -e "s/DATA02/$2/" | nc localhost 11211 | grep ${PREFIX}

}	#EndFunction



#Recupera SLABS
SLABS=$(echo "stats items " "${STATS}" | nc localhost 11211 | grep number)

#echo "${SLABS}"

echo "====================="

#Leemos cada SLAB de datos
while read -r LINE
do
  #echo "$LINE"
  NSLAB=$(echo ${LINE} | awk -F: '{print $2}')
  ITEMS=$(echo ${LINE} | awk '{print $NF}')
    
  RecuperaSLABS "${NSLAB}" "${ITEMS}"
    
done <<< "${SLABS}"


