#!/bin/bash
source /opt/stack/devstack/openrc admin admin 
declare -a send_switch
#Create port via generic switch in loop we add amount 
for i in $( seq 5 15)
    do
	send_switch+=`printf " Te 1/$i " && python /opt/stack/new/networking-generic-switch/devstack/exercise.py --switch_name cz-eth1204-4 --port Te1/$i --switch_id=aa:bb:cc:dd:ee:ff --network=private &`
   done
echo $send_switch

#Check when can connect to switch and get result from netmiko
 
while [ 0 ]
do
out_switch=`netstat -ntu | grep 172.16.42.12 | wc -l`
if [[ $out_switch <= "4" ]]
    then 
	./testnetmiko | awk '/Te 1/' > out_t	
	break
fi 
done 

res_from_netmiko=`tail -45  out_t | awk '{print $1 " " $2 " " $6 $7}' | sed -e 's/Full//'`
echo $res_from_netmiko

#Compared resalt  

for j in `echo $res_from_netmiko`
    do
        if [[ `$j | awk '{print $3}'`  == "843" ]]

            then echo PASS
        else
	    echo $j NOT PASS
	fi
    done

#Delete created generic_switch_test port 
neutron port-list | grep generic_switch_test | awk '{print $2}' | xargs -n 5 neutron port-delete

