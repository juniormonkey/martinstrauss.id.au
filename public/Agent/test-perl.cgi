#!/usr/bin/perl -w
use strict;
use CGI qw(:standard);

my $query = new CGI;
my $self = $query->url();

my (
	$biofeedback,
	$gsr,
	$bvp,
	$emg,
	$resp,
	$highGSR,
	$lowGSR,
	$highBVP,
	$lowBVP,
	$highEMG,
	$lowEMG,
	$highResp,
	$lowResp
	);

print header;
print start_html('Hello there'),
   h1('here goes...');

if ($query->param('biofeedback')) {
	print 
		"Given biofeedback is ",em($query->param('biofeedback')),
		p;
	$biofeedback = $query->param('biofeedback');
} 
if ($query->param('stimulus')) {
	print 
		"Given stimulus is ",em($query->param('stimulus')),
		p;
}

if($biofeedback and $biofeedback =~ /\[(.*), (.*), (.*), (.*)\]/) {
	$gsr = $1;
	$bvp = $2;
	$emg = $3;
	$resp = $4;
} else {
	$gsr = 'low';
	$bvp = 'low';
	$emg = 'low';
	$resp = 'low';
}

if($gsr eq 'high') { 
	$highGSR = '<b>High</b>';
	$lowGSR = "<a href=\"$self?biofeedback=[low, $bvp, $emg, $resp]\">Low</a>";
} else {
	$highGSR = "<a href=\"$self?biofeedback=[high, $bvp, $emg, $resp]\">High</a>";
	$lowGSR = '<b>Low</b>';
}
if($bvp eq 'high') { 
	$highBVP = '<b>High</b>';
	$lowBVP = "<a href=\"$self?biofeedback=[$gsr, low, $emg, $resp]\">Low</a>";
} else {
	$highBVP = "<a href=\"$self?biofeedback=[$gsr, high, $emg, $resp]\">High</a>";
	$lowBVP = '<b>Low</b>';
}
if($emg eq 'high') { 
	$highEMG = '<b>High</b>';
	$lowEMG = "<a href=\"$self?biofeedback=[$gsr, $bvp, low, $resp]\">Low</a>";
} else {
	$highEMG = "<a href=\"$self?biofeedback=[$gsr, $bvp, high, $resp]\">High</a>";
	$lowEMG = '<b>Low</b>';
}
if($resp eq 'high') { 
	$highResp = '<b>High</b>';
	$lowResp = "<a href=\"$self?biofeedback=[$gsr, $bvp, $emg, low]\">Low</a>";
} else {
	$highResp = "<a href=\"$self?biofeedback=[$gsr, $bvp, $emg, high]\">High</a>";
	$lowResp = '<b>Low</b>';
}

print h2("Biofeedback:"),
	table(
	Tr(
	[
		td([em('GSR'), $highGSR, $lowGSR]),
		td([em('BVP'), $highBVP, $lowBVP]),
		td([em('EMG'), $highEMG, $lowEMG]),
		td([em('Resp'), $highResp, $lowResp])
	]
	)
);

print end_html;

