term shell

function totalcheck() {
x=`test platform hardware fed switch active port 25 phy prbs show-lock-stats | grep Error | cut -d "x" -f 2`
let err = err + x
echo "Total errors:" $err
echo "Errors since last check:" $x
}



function SetPortEnabledState() {
conf t
int Te1/1/$1
$2
speed $3
end
}
#Takes SFP port as first argument (1-4), state as second argument (shut/no shut), and speed as third argument (10000/25000)
#Speed line could be removed for some DUTs, if dual rate is not supported, as in this case
#Don't think nominal frequency is needed here



function SetPRBSPattern() {
let p = 24 + $1
test platform hardware fed switch active port $p phy prbs start prbs-$2
}
#Takes SFP port as first argument, adds to 24 because there are 24 copper interfaces
#Takes pattern as second argument (13/31), could be hardcoded to 31 for NRZ cases


function SetVoltageMargin() {
conf t
Voltage all $1 switch 1
}
#Takes voltage margin as input (high/low/nominal)



function StartPRBSStatistics() {
let p = 24 + $1
test platform hardware fed switch active port $p phy prbs clear-stats
ti=`show clock | cut -d " " -f 1 | cut -d "*" -f 2`
echo $ti
}
#takes port as argument



function GetPRBSStatistics() {
let p = 24 + $1
errcnt=`test platform hardware fed switch active port $p phy prbs show-lock-stats | grep Error | cut -d "x" -f 2`
tf=`show clock | cut -d " " -f 1 | cut -d "*" -f 2`
echo $errcnt, hex, $ti, $tf
}
#takes port as argument



function GetLockStats() {
let p = 24 + $1
test platform hardware fed switch active port $p phy prbs show-lock-stats | grep lock
}

wr
