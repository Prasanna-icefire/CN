set ns [new Simulator]
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set tf [open ex6.tr w]
$ns trace-all $tf
set nf [open ex6.nam w]
$ns namtrace-all $nf
set file [open cong w]
$ns duplex-link $n2 $n0
$ns duplex-link $n3 $n0
$ns duplex-link $n4 $n0
$ns duplex-link $n0 $n1
10Mb 10ms DropTail
10Mb 10ms DropTail
10Mb 10ms DropTail
0.7Mb 20ms DropTail
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $tcp
$ns attach-agent $n0 $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 1.2 "$ftp start"
set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $tcp1
$ns attach-agent $n0 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 1.2 "$ftp1 start"
set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n4 $tcp2
$ns attach-agent $n0 $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 1.2 "$ftp2 start"
$ns at 3.0 "finish"
proc plot-window {agent file}
{
global ns
set time 0.10
set now [$ns now]
set cwnd[$agent set cwnd_]
puts $file â€œ$now $cwndâ€
$ns at [expr $now+$time] â€œplot-window $agent $fileâ€
}
proc finish {} {
global ns tf nf
$ns flush-trace
close $tf
close $nf
puts "running nam..."
puts "TCP PACKETS.."
exec nam ex6.nam &
exit 0
}
$ns run
