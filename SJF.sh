clear
declare -A processes
declare -A bTime
declare -A wTime
declare -A taTime
zero=0;

read -p "How many process are you going to add: " psNos

for ((i=0; i<$psNos; i++))
do
    read -p "Enter Process Number $i: " processes[$i]
    read -p "Enter Burst Time for Process Number $i: " bTime[$i]
    if (( ${bTime[$i]}==$zero ))
    then
        while (( ${bTime[$i]}==$zero ))
        do
            echo "Burst Time Cannot Be Zero (0)"
            read -p "Enter Burst Time for Process Number $i: " bTime[$i]
            if (( ${bTime[$i]}!=$zero ))
            then
                break
            fi
        done
    fi
done

for ((i = 0; i<$psNos; i++))
do
    for ((j = 0; j<$psNos-i-1; j++))
    do
        if (( ${bTime[$j]} > ${bTime[$((j+1))]} ))
        then
            temp=${bTime[$j]}
            bTime[$j]=${bTime[$((j+1))]}
            bTime[$((j+1))]=$temp
            
            pemp=${processes[$j]}
            processes[$j]=${processes[$((j+1))]}
            processes[$((j+1))]=$pemp
        fi
    done
done
let wTime[0]=0
for ((i=1;i<=$psNos;i++))
do
    wTime[$i]=0
    for ((j=0;j<$i;j++))
    do
        wTime[$i]=$((${wTime[$i]} + ${bTime[$j]}))
    done
done
taTime[0]=0
printf "  Process Name     Burst Time     Waiting Time     Turnaround Time\n"
for ((i=0;i<$psNos;i++))
do
    let taTime[$i]=$((${wTime[$i]} + ${bTime[$i]}))
    printf "\t%s\t\t%d\t\t%d\t\t%d\n" ${processes[$i]} ${bTime[$i]} ${wTime[$i]} ${taTime[$i]}
done
