#create a simulator object
set ns [new Simulator]

#open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#open the trace file
set tf [open out.tr w]
$ns trace-all $tf


#define a 'finish' procedure
proc finish {} {
global ns nf tf
$ns flush-trace
close $nf
close $tf
exec nam out.nam &
exit 0
}


#creat three node
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#create a duplex link between the nodes
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n1 1Mb 10ms DropTail

#creat a UDP agent and attach it to node n0
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0

#create Null agent 
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0

#connect
$ns connect $udp0 $null0
$udp0 set fid_ 2

#Create a CBR traffic source and attach it to udp0
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp0
$cbr set packetSize_ 500
$cbr set interval_ 0.005

#schedule
$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"

$ns at 5.0 "finish"

$ns run