enable
term shell
configure terminal | null
    shell processing full
    service internal
    no logging console
    line con 0
        exec-timeout 0 0    
        exit
    line vty 0 4
        exec-timeout 0 0
        end
ti=`show clock | cut -d ' ' -f 1 | cut -d '*' -f 2`
totalerr=0

function SetPortEnabledState() {
    interface=$1
    if [[ 'disable' == $2 ]]; then
        state='shut'
    else;
        state='no shut'
    fi
    conf t | null
        int Te1/1/$interface
            $state
            if (( $3 )); then
                speed $3
            fi
            end
}

function SetVoltageMargin() {
    voltmarg=$2
    conf t | null
        Voltage all $voltmarg switch 1
        end
}

function SetPRBSPattern() {
    interface=$1
    pattern=$2
    let port = 48 + $interface
    templock='null'
    for x in `sh int | nl | cut -d":" -f 1 | head 5`; do
        if [[ 'Aquired' != $templock ]]; then
            Test platform hardware fed switch 1 port $port phy prbs start prbs-$pattern | null
            templock=`Test platform hardware fed switch 1 port $port phy prbs show-lock-stats | grep lock | cut -d ' ' -f 7`
        fi
    done
}

function StartPRBSStatistics() {
    totalerr=0
    ti=`show clock | cut -d ' ' -f 1 | cut -d '*' -f 2`
    echo ''
}

function GetPRBSStatistics() {
    interface=$1
    let port = 48 + $interface
    errhex=`Test platform hardware fed switch 1 port $port phy prbs show-lock-stats | grep Error | cut -d 'x' -f 2`
    tf=`show clock | cut -d ' ' -f 1 | cut -d '*' -f 2`
    lock=`Test platform hardware fed switch 1 port $port phy prbs show-lock-stats | grep lock | cut -d ' ' -f 7`
    errdec=`printf '%d' 0x$errhex`
    let totalerr += $errdec
    if [[ 'Aquired' == $lock ]]; then
        lockstat='Locked'
    else;
        lockstat='Unlocked'
    fi
    echo $totalerr, dec, $ti, $tf, $lockstat
    echo ''
}

function GetDomPower() {
    interface=$1
    let port = 48 + $interface
    dompower=`sh int te1/1/$interface tra de | tail 2 | head 1 | cut -d ' ' -f 7,8,9`
    echo $dompower
    echo ''
}

#END OF FUNCTIONS








Test platform hardware fed switch 1 port 50 phy prbs stop prbs-31



Test platform hardware fed switch 1 port 49 phy prbs start prbs-31
Test platform hardware fed switch 1 port 49 phy prbs show-lock-stats


templock='null'
for x in `sh int | nl | cut -d":" -f 1 | head 5`; do
    if [[ 'Aquired' != $templock ]]; then
        Test platform hardware fed switch 1 port $port phy prbs start prbs-31
        templock=`Test platform hardware fed switch 1 port $port phy prbs show-lock-stats | grep lock | cut -d ' ' -f 7`
    fi
done

