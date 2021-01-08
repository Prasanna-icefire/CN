set ns [new Simulator]
set tf [open ex3.tr w]
$ns trace-all $tf
set nf [open ex3.nam w]
$ns namtrace-all $nf
set cwind [open win3.tr w]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
set lan [$ns newLan "$n1 $n2 $n3 $n4 $n5 $n6 $n7 $n8 $n9 $n10 " 10Mb 2ms LL
Queue/DropTail Channel]
$ns duplex-link $n5 $n6 1Mb 10ms DropTail
set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n8 $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set tcp1 [new Agent/TCP]
$ns attach-agent $n7 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 1.0 "$ftp0 start"
$ns at 2.0 "$ftp1 start"
proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
$ns at 2.0 "plotWindow $tcp0 $cwind"
$ns at 5.5 "plotWindow $tcp1 $cwind"
proc finish {} {
global ns tf nf cwind
$ns flush-trace
close $tf
close $nf
puts "running nam..."
exec xgraph win3.tr &
exec nam ex3.nam &
exit 0
}
$ns at 20.0000 "finish"
$ns run
