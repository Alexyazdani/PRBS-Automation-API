

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

function start() {
    p=$1
    if [[ $p -lt 8 ]]; then
        show platform hardware subslot 0/0 module device "debug phy $p write 1 23 0xcb" | null
        show platform hardware subslot 0/0 module device "debug phy $p write 1 23 0xdb" | null
        show platform hardware subslot 0/0 module device "debug phy $p write 1 23 0xcb" | null
    else;
        show platform hardware subslot 0/0 module device "debug pm prbs $p start 31" | null
    fi
}

function stop() {
    p=$1
    if [[ $p -lt 8 ]]; then
        show platform hardware subslot 0/0 module device "debug phy $p write 1 23 0x0" | null
    else;
        show platform hardware subslot 0/0 module device "debug pm prbs $p start 0" | null
    fi
}

function check() {
    p=$1
    if [[ $p -lt 8 ]]; then
        LSB=`show platform hardware subslot 0/0 module device "debug phy $p read 1 24" | cut -d 'x' -f 2`
        MSB=`show platform hardware subslot 0/0 module device "debug phy $p read 1 25" | cut -d 'x' -f 2`
        errhex=$MSB$LSB
        errdec=`printf '%d' 0x$errhex`
    else;
        errdec=`show platform hardware subslot 0/0 module device "debug pm prbs $p status"  | tail 2 | cut -d ' ' -f 6`
    fi
    echo $errdec
    echo ''
}

function SetPortEnabledState() {
    p=$1
    if [[ $p -lt 8 ]]; then
        int=gi0/0/$p
    else;
        if [[ $p -lt 16 ]]; then
            int=te0/0/$p
        else;
            int=twe0/0/$p
        fi
    fi
    if [[ 'disable' == $2 ]]; then
        state='shut'
    else;
        state='no shut'
    fi
    conf t | null
        int $int
        $state
        end
}

function SetVoltageMargin() {
    echo ''
}

function SetPRBSPattern() {
    p=$1
    stop $p | null
    sleep 1
    start $p | null
}

function StartPRBSStatistics() {
    p=$1
    totalerr=0
    errdec=0
    ti=`show clock | cut -d ' ' -f 1 | cut -d '*' -f 2`
    if [[ $p -lt 8 ]]; then
        start $p | null
        lockstat='Locked'
    else;
        lock=`show platform hardware subslot 0/0 module device "debug pm prbs $p status" | grep locked | cut -d ' ' -f 4 | cut -d ',' -f 1`
        if [[ 'Yes' == $lock ]]; then
            lockstat='Locked'
        else;
            lockstat='Unlocked'
        fi
        echo ''
    fi
}

function GetPRBSStatistics() {
    tf=`show clock | cut -d ' ' -f 1 | cut -d '*' -f 2`
    if [[ $p -lt 8 ]]; then
        LSB=`show platform hardware subslot 0/0 module device "debug phy $p read 1 24" | cut -d 'x' -f 2`
        MSB=`show platform hardware subslot 0/0 module device "debug phy $p read 1 25" | cut -d 'x' -f 2`
        totalerr=`printf '%d' 0x$MSB$LSB`
        let totalerr = $totalerr / 3
    else;
        let totalerr = $totalerr + `show platform hardware subslot 0/0 module device "debug pm prbs $p status"  | tail 2 | cut -d ' ' -f 6`
    fi
    echo $totalerr, dec, $ti, $tf, $lockstat
    echo ''
}

function GetDomPower() {
    p=$1
    if [[ $p -lt 8 ]]; then
        int=gi0/0/$p
    else;
        if [[ $p -lt 16 ]]; then
            int=te0/0/$p
        else;
            int=twe0/0/$p
        fi
    fi
    dompower=`sh int $int tra de | tail 2 | head 1 | cut -d ' ' -f 6,7,8`
    echo $dompower
    echo ''
}

wr | null

#END OF FUNCTIONS


