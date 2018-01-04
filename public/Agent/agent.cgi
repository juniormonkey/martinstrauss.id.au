#!/usr/bin/perl -w
use strict;
use CGI::Pretty qw(:standard start_ul);
use File::Temp qw(:mktemp);

##################################################################
# MAIN PROGRAM
##################################################################

my (
	$sessid,			# this one is "global".  I don't like it.
	$inputfile,
	$outputfile,
   $biofeedback,
	$bio_output,
	$stimulus,
	$nice_stimulus,
	$io_output,
	$mood,			# ditto.  Ditto.
	$intensity,		# and again.
	$bio_emotion,	# yeah, well.
	$response,
	$debug
   );

my $query = new CGI;
my $self = $query->url();

$nice_stimulus = "";
$bio_emotion = "none";

print header;
print start_html(-title => 'Martin\'s affective agent chat',
						-style => { -src => 'agent.css' });

if (!$query->param('sessid')) {
	$sessid = init();
} else {
	$sessid = $query->param('sessid');
}
$inputfile = "tmp/input.$sessid";
$outputfile = "tmp/output.$sessid";

if (not -e $inputfile or not -e $outputfile) {
	print p(b("Error:")." Your session has timed out.");
	$sessid = init();
	$inputfile = "tmp/input.$sessid";
	$outputfile = "tmp/output.$sessid";
}

if ($query->param('biofeedback')) {
   $debug .=
      "Given biofeedback is ".em($query->param('biofeedback')).p;
   $biofeedback = $query->param('biofeedback');
}
if ($query->param('stimulus')) {
   $debug .=
      "Given stimulus is ".em($query->param('stimulus')).p;
	$stimulus = $query->param('stimulus');
} else {
	$stimulus = 'z';
}

if($stimulus ne 'z' and $stimulus ne 'x') {
	$nice_stimulus = em("\"".get_stimulus($stimulus)."\"");
}

print h1('Let\'s talk!');

$debug = hr.h2("Output:")."<pre>";
$bio_output = do_biofeedback($biofeedback);

$io_output = do_io($biofeedback);

$debug .= "</pre>", hr;

if($stimulus eq 'y') {
	`rm -f tmp/input.$sessid tmp/output.$sessid`;
	output_nicely("(none)", 
		ul(li(a({href=>"$self"}, "Start another conversation"))),
		$nice_stimulus, "none", "none", "0",
		em("\"Good luck in thy travels, fair adventurer!\""));
	exit;
}

output_nicely($bio_output, $io_output, $nice_stimulus, 
	$bio_emotion, $mood, $intensity, $response);

print $debug;

print end_html;

##################################################################

##################################################################
# do_biofeedback
# takes the biofeedback string as an argument and prints the biofeedback table
##################################################################

sub do_biofeedback {
	my $biofeedback = shift;
	my $output;
	my (
		$gsr, $bvp, $emg, $resp,
		$highGSR, $lowGSR,
		$highBVP, $lowBVP,
		$highEMG, $lowEMG,
		$highResp, $lowResp
	);
	if($biofeedback and $biofeedback =~ /\[(.*), (.*), (.*), (.*)\]/) {
		$gsr = $1; $bvp = $2; $emg = $3; $resp = $4;
	} else {
		$gsr = 'low'; $bvp = 'low'; $emg = 'low'; $resp = 'low';
	}

	if($gsr eq 'high') {
		$highGSR = '<b>High</b>';
		$lowGSR = "<a href=\"$self?sessid=$sessid&stimulus=z&biofeedback=[low, $bvp, $emg, $resp]\">Low</a>";
	} else {
		$highGSR = "<a href=\"$self?sessid=$sessid&stimulus=z&biofeedback=[high, $bvp, $emg, $resp]\">High</a>";
		$lowGSR = '<b>Low</b>';
	}
	if($bvp eq 'high') {
		$highBVP = '<b>High</b>';
		$lowBVP = "<a href=\"$self?sessid=$sessid&stimulus=z&biofeedback=[$gsr, low, $emg, $resp]\">Low</a>";
	} else {
		$highBVP = "<a href=\"$self?sessid=$sessid&stimulus=z&biofeedback=[$gsr, high, $emg, $resp]\">High</a>";
		$lowBVP = '<b>Low</b>';
	}
	if($emg eq 'high') {
		$highEMG = '<b>High</b>';
		$lowEMG = "<a href=\"$self?sessid=$sessid&stimulus=z&biofeedback=[$gsr, $bvp, low, $resp]\">Low</a>";
	} else {
		$highEMG = "<a href=\"$self?sessid=$sessid&stimulus=z&biofeedback=[$gsr, $bvp, high, $resp]\">High</a>";
		$lowEMG = '<b>Low</b>';
	}
	if($resp eq 'high') {
		$highResp = '<b>High</b>';
		$lowResp = "<a href=\"$self?sessid=$sessid&stimulus=z&biofeedback=[$gsr, $bvp, $emg, low]\">Low</a>";
	} else {
		$highResp = "<a href=\"$self?sessid=$sessid&stimulus=z&biofeedback=[$gsr, $bvp, $emg, high]\">High</a>";
		$lowResp = '<b>Low</b>';
	}

	$output = 
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

	return $output;
}

##################################################################
# do_io
# talks to the fifos
##################################################################

sub do_io {
	my $biofeedback = shift;
	my $output = "";
	my (
		$gsr, $bvp, $emg, $resp,
		$i,
		@options
	);
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

	# loop forever, or at least until we hit a last (which happens when we
	# see the "Options" line on the INPUT, or when we see the "Stimulus"
	# line if we missed the "Options" line cos prolog is stupid.
	OUTER_LOOP: while(1) {
		open INPUT, "cat $outputfile|"
			or die "Cannot open pipe '$outputfile' for input<br/>";
		while (<INPUT>) {
			$debug .= $_;
			if ($_ =~ "Stimulus:" ) {	# the "Stimulus:" prompt
				if($stimulus) {			# if we have stimulus, give it
					open OUTPUT, ">$inputfile"
						or die "Cannot open pipe '$inputfile' for output<br/>";
					print OUTPUT $stimulus.".";
					close OUTPUT or die "Unable to close output<br/>";
					$debug .= "$stimulus.\n";
				}
				if($stimulus eq 'x') {	# if stimulus is x (the send-again char)
					close INPUT or die "Unable to close input<br/>";
					last OUTER_LOOP;		# close the pipe and break the loop
				}
			} elsif ($_ =~ /"(.*)"/) {	# the response
				$response = em("\"".get_response($1)."\"")."";
			} elsif ($_ =~ "Biofeedback:") { # the "Biofeedback:" prompt
				open OUTPUT, ">$inputfile" or die "Cannot open pipe '$inputfile' for output<br/>";
				print OUTPUT "[$gsr, $bvp, $emg, $resp]."; # output biofeedback
				close OUTPUT or die "Unable to close output<br/>";
				$debug .= "[$gsr, $bvp, $emg, $resp].\n";
			} elsif ($_ =~ /Options: \[(.*)\]/) {	# the list of options
				$stimulus = 'x';							# in case we get "Stimulus:"
				@options = split(", ", $1);		#  as well; x means "come again"
				$output .= start_ul();
				for($i = 0; $i <= $#options; $i++) {
					$output .= li(a({href=>"$self?sessid=$sessid&biofeedback=[$gsr, $bvp, $emg, $resp]&stimulus=".$options[$i]}, get_stimulus($options[$i])));
				}
				$output .= end_ul();
			} elsif ($_ =~ /YourMood: \[(.*)\]/) {	# the results of the biofeedback
				my @tmparray = split(', ', $1);
				$bio_emotion = $tmparray[0];
			} elsif ($_ =~ /Mood: (.*), (.*)/) {	# the current mood
				$mood = $1; $intensity = $2;
				if($stimulus eq 'y') {	# if stimulus is x (the goodbye char)
					close INPUT or die "Unable to close input<br/>";
					last OUTER_LOOP;		# close the pipe and break the loop
				}
			} else {									# anything else
				$debug .= $_;
			}
		}
		close INPUT or die "Unable to close input<br/>";
	}

	return $output;
}

##################################################################
# get_stimulus
# turns a stimulus letter into a sentence
##################################################################

sub get_stimulus {
	my $key = shift;
	my %stimuli = (
		a => "I'd like to buy your [axe/staff/armour/etc] (offer the right price)",
		b => "I'd like to buy your [axe/staff/armour/etc] (offer above the right price)",
		c => "I'd like to buy your [axe/staff/armour/etc] (offer below the right price)",
		d => "Is that [axe/staff/armour/etc] for sale?",
		e => "Here, buy this [axe/staff/armour/etc] off me (bargain price)",
		f => "Here, buy this [axe/staff/armour/etc] off me (reasonable price)",
		g => "Here, buy this [axe/staff/armour/etc] off me (unreasonable price)",
		h => "Here, fix this [axe/staff/armour/etc], it's broken",
		i => "Hoi, you sold me a crap [axe/staff/piece of armour/etc], i want my money back",
		j => "You sold me that [axe/staff/armour/etc], it was really good, great work!",
		k => "I think you sabotaged my [axe/staff/armour/etc], is that true?",
		l => "I've kidnapped your wife and children, give me that [axe/staff/armour/etc]",
		m => "I'm the guy that killed your wife and children, i'm terribly sorry, i didn't realise",
		n => "The monster who killed your wife and children is dead",
		o => "I'm the guy that killed the monster",
		p => "I tried to kill the monster who killed your wife and children, but failed",
		q => "A monster killed your wife and children",
		r => "I made the monster that killed your wife and children",
		s => "I think YOU made the monster that killed your wife and children",
		t => "Is there any work for me around here?",
		u => "I'm actually a woman!",
		v => "Did you see the dress the Queen was wearing at the parade?",
		y => "Thanks for your help.  Fare thee well!"
	);

	return $stimuli{$key};
}

##################################################################
# get_response
# turns a response letter into a sentence
##################################################################

sub get_response {
	my $key = shift;
	my %responses = (
		aa => "Most certainly, sir!  I'll just put it into your inventory.",
		ab => "I can't possibly take that much money off you for such a worthless item!  Let me sell it to you for half that.",
		ac => "Oh dear, sir, it's certainly worth much more than that, you'll have to make a higher offer.",
		ba => "Well, you've talked me into it.  Here it is.",
		ad => "I'm sorry, sir, that item is not for sale.",
		da => "Yes, sir, it is; but you'll have to make an offer.  Valuables such as these cannot have a price tag!",
		ea => "Well, sir, you are most reasonable; I'll add it to my collection.",
		eb => "Well, I guess I can't turn down a price like that.  Give it here.",
		fa => "My dear sir, you can't possibly expect me to be able to afford that!",
		ha => "What a beautiful piece of art; I'll do my best to restore its beauty.",
		hb => "I'm sorry sir, this is not a repair-shop for petty trinkets!",
		ia => "My most abject apologies Sir, please accept my full refund.",
		ib => "Here's a free Latin lesson: caveat emptor.  Which means: you lucked out, pal! hahahahaha!",
		ic => "I would never sell such a piece of shoddy handiwork.  You are trying to defraud me!",
		ja => "Why thankyou, I live only to serve.",
		jb => "Flattery won't get you anywhere, you'll have to pay full price, just like everybody else!",
		ka => "Fine, I admit it; I've been selling you fakes.",
		kb => "Never!  I would not think of such a thing!",
		la => "You brute!  How could you do such a thing!",
		lb => "My name is Inigo Montoya.  You killed my father.  Prepare to die.",
		lc => "Don't fret about it, mate, I didn't really like them anyway...",
		ld => "I knew from the start there was something not right about you, but never in my wildest dreams did I suspect...",
		na => "Huzzah!  What a relief!  That monster has destroyed many lives.",
		nb => "Congratulations!  This town owes you an enormous debt.",
		nc => "Well, that's a relief... you did something right for a change.",
		pa => "Many have tried, and many have failed.  You stand in great company.",
		pb => "But you ran away, and let it escape?  Coward!",
		sa => "How dare you make such an outrageous accusation!  Me, who has never so much as hurt a fly in his entire life...",
		sb => "It's true... it was an old experiment gone horribly wrong... I was hoping nobody would discover our connection!",
		qa => "No! Not my precious Lily! Please, let it not be true!",
		qb => "I knew it would happen... you adventuring types should have killed the monster long ago!  And now it's done this... (sob)",
		ta => "I don't have any at the moment, but I could recommend you to a friend, who always needs a hand in the shop...",
		tb => "We don't have a need for the likes of you!  Go back to scaring small children, or whatever else you do in your spare time.",
		tc => "Well, there is that monster who's been terrorising the neighbourhood...",
		ua => "Oh dear, I've completely misjudged you!  I thought everybody who played role-playing games was male... My most abject apologies!",
		ub => "I thought I spotted a bit of a limp wrist... How may I help you, <b>Ma'am</b>?",
		uc => "Well, really.  What kind of a woman goes around wearing breeches anyway?",
		ud => "Thank goodness!  We don't get nearly enough oestrogen in these parts!",
		va => "Yes, wasn't it just delightful!  But in my eyes she was put in shadow by Princess Mary... wasn't that just the most spectacular train?",
		vb => "Yes, lovely.  May I show you my wares?",
		vc => "Listen, I'd love to stand around chatting, but there's other customers to serve.  Buy something, or get out."
	);
	return $responses{$key};
}

##################################################################
# output_nicely
# writes the output of the biofeedback and IO interactions nicely
##################################################################

sub output_nicely {
	my $bio_output = shift; my $io_output = shift;
	my $nice_stimulus = shift; my $bio_emotion = shift;
	my $mood = shift; my $intensity = shift; my $response = shift;

	my $nice_mood = "";

	if(!$mood) { $mood = "none"; }
	if(!$intensity) { $intensity = "0"; }

	if(!$response) { $response = ""; }

	print table({-width=>'100%', -border=>2},
		Tr(
			td({-width=>'60%', -rowspan=>2},
					p({-align=>'center'},
						img{src=>"images/".$mood.".png", align=>'center'}).
					p({-align=>'right'}, $nice_stimulus).
					p({-align=>'center'}, b("Mood: ").$mood.", ".$intensity).
					p({-align=>'left'}, $response)
			),
			td( h3("Biofeedback:").$bio_output ),
			td(
				h3("Your mood:"),
				p({-align=>'center'},
					img{src=>"images/".$bio_emotion.".png",
						align=>'center', height=>100}).
				p({-align=>'center'}, $bio_emotion)
			)
		),
		Tr(
			td({-colspan=>2}, h3("Options:").$io_output)
		)
	);
	
	return;
}

sub init {
	my $sessid;
	if (mktemp("tmp/input.XXXXXX") =~ /tmp\/input\.(.*)/) {
		$sessid = $1;
	} else {
		die "Unable to generate valid session ID!\n";
	}

	`mkfifo tmp/input.$sessid`;
	`mkfifo tmp/output.$sessid`;

	system("./agent tmp/input.$sessid tmp/output.$sessid &") and do {
		print "Unable to open the prolog agent!\n";
		`rm -f tmp/input.$sessid tmp/output.$sessid`;
		die "Unable to open the prolog agent!\n";
	};
	system("./reaper $sessid &") and do {
		print p("Unable to open the grim reaper!");
		print p("Warning: this means that a stray Prolog process is running around!");
		die "Unable to open the prolog agent!\nWarning: this means that a stray Prolog process is running around!";
	};

	return $sessid;
}
