set ns [new Simulator]

set tf [open ex4.tr w]
$ns trace-all $tf

set nf [open ex4.nam w]
$ns namtrace-all $nf

$ns color 1 Blue 

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n0 label "Server"
$n5 label "Client"

$ns duplex-link $n0 $n1 0.3Mb 10ms DropTail
$ns duplex-link $n1 $n2 0.3Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 10ms DropTail
$ns duplex-link $n1 $n4 0.3Mb 10ms DropTail
$ns duplex-link $n3 $n5 0.5Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.5Mb 10ms DropTail


set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
$tcp set packetSize_ 1500
set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.1 "$ftp start"
$ns at 12.0 "finish"

proc finish {} {
	global ns tf nf cwind
	$ns flush-trace
	close $tf
	close $nf
	exec nam ex4.nam &
	exec awk -f ex4transfer.awk ex4.tr &
	exec awk -f ex4convert.awk ex4.tr > convert.tr &
	exec xgraph convert.tr -geometry 800*400 -t "bytes_client" -x "time" -y "bytes_in_bps" &
	exit 0
}

$ns run
