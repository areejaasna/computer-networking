TCP/FTP

set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set tf [open out.tr w]
$ns trace-all $tf

proc finish {} {
global ns nf tf
$ns flush-trace
close $tf
close $nf
exec nam out.nam &
exit 0
}

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10m DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

set ftp [new Application/FTP]
$ftp set packetSize_ 500
$ftp set rate_ 0.01Mb
$ftp set random_ true
$ftp set class_ 1

$ftp attach-agent $tcp0

$ns connect $tcp0 $sink

$ns at 0.5 "$ftp start"
$ns at 4.5 "$ftp stop"

$ns at 4 "finish" 

$ns run





































