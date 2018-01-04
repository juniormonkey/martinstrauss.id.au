:- module(dialogueInput, [appraise/3]).

% appraise(+Stimulus, -RosemanAppraisals, -SmithEllsworthAppraisals)
% takes a stimulus in Stimulus and finds the Roseman (RosemanAppraisals)
% and Smith & Ellsworth (SmithEllsworthAppraisals) appraisals of the stimuli
appraise(Stimulus, RosemanAppraisals, SmithEllsworthAppraisals) :-
	rosemanAppraise(Stimulus, RosemanAppraisals),
	smithEllsworthAppraise(Stimulus, SmithEllsworthAppraisals).

% rosemanAppraise(+Stimulus, -RosemanAppraisals)
% a list of matching stimulus/appraisal pairs
rosemanAppraise(killMother, [motiveInconsistent, appetitive]).
rosemanAppraise(makeMonster, [motiveInconsistent, aversive]).
rosemanAppraise(buyAxe, [motiveConsistent, appetitive]).
rosemanAppraise(killMonster, [motiveConsistent, aversive]).
rosemanAppraise(i, [otherCaused, highControlPotential]).
rosemanAppraise(they, [otherCaused, lowControlPotential]).
rosemanAppraise(you, [selfCaused, highControlPotential]).
rosemanAppraise(yesYou, [selfCaused, lowControlPotential]).
rosemanAppraise(someone, [circumstanceCaused, lowControlPotential]).
rosemanAppraise(youMissedSomeone, [circumstanceCaused, highControlPotential]).
rosemanAppraise(did, [certain]).
rosemanAppraise(will, [unCertain]).
rosemanAppraise(iKnow, [certain]).
rosemanAppraise(iveHeard, [uncertain]).
rosemanAppraise(didYouKnow, [unexpected]).
rosemanAppraise(typical, [characterological]).
rosemanAppraise(whodaThunkIt, [nonCharacterological]).

/*
% user didn't get the groceries i asked him to
rosemanAppraise(a, [motiveInconsistent, appetitive, otherCaused, highControlPotehtial, certain, characterological]).
% user might not bless my doorway
rosemanAppraise(b, [motiveInconsistent, aversive, otherCaused, lowControlPotential, uncertain, characterological]).
% user bought my axe
rosemanAppraise(c, [motiveConsistent, appetitive, otherCaused, highControlPotential, certain, nonCharacterological]).
% i'm making a beautiful axe
rosemanAppraise(d, [motiveConsistent, appetitive, selfCaused, highControlPotential, uncertain, characterological]).
% the wicked witch of the west is dead!
rosemanAppraise(e, [motiveConsistent, aversive, circumstanceCaused, lowControlPotential, unexpected]).
% i tripped as i was running to the tailor
rosemanAppraise(f, [motiveInconsistent, appetitive, selfCaused, highControlPotential, certain, nonCharacterological]).
% it might rain tonight
rosemanAppraise(g, [motiveInconsistent, aversive, circumstanceCaused, lowControlPotential, uncertain, nonCharacterological]).
*/

%%%%%%%%%%%%%%%

%i'd like to buy your (axe/staff/armour/etc) - offer the right price
rosemanAppraise(a, [motiveConsistent, appetitive, certain]).

%i'd like to buy your (axe/staff/armour/etc) - offer above the right price
rosemanAppraise(b, [motiveConsistent, appetitive, certain, unexpected]).

%i'd like to buy your (axe/staff/armour/etc) - offer below the right price
rosemanAppraise(c, [motiveConsistent, circumstanceCaused, appetitive, uncertain, unexpected]).

% is that (axe/staff/armour/etc) for sale?
rosemanAppraise(d, [motiveConsistent, appetitive, uncertain]).

% here, buy this (axe/staff/armour/etc) off me - bargain price
rosemanAppraise(e, [motiveConsistent, otherCaused]).

% here, buy this (axe/staff/armour/etc) off me - reasonable price
rosemanAppraise(f, [motiveConsistent, otherCaused]).

% here, buy this (axe/staff/armour/etc) off me - unreasonable price
rosemanAppraise(g, [motiveConsistent, circumstanceCaused, uncertain]).

% here, fix this (axe/staff/armour/etc), it's broken
rosemanAppraise(h, [motiveConsistent, otherCaused]).

% hoi, you sold me a crap (axe/staff/piece of armour/etc), i want my money back
rosemanAppraise(i, [motiveInconsistent, aversive, nonCharacterological]).

%you sold me that (axe/staff/armour/etc), it was really good, great work!
rosemanAppraise(j, [motiveConsistent, selfCaused]).

% i think you sabotaged my (axe/staff/armour/etc), is that true?
rosemanAppraise(k, [motiveInconsistent, selfCaused, highControlPotential]).

% i've kidnapped your wife and children, give me that (axe/staff/armour/etc)
rosemanAppraise(l, [motiveInconsistent, otherCaused]).

% i'm the guy that killed your wife and children, i'm terribly sorry, i didn't realise
rosemanAppraise(m, [motiveInconsistent, otherCaused, nonCharacterological]).

% the monster who killed your wife and children is dead
rosemanAppraise(n, [motiveConsistent, circumstanceCaused, certain]).

% i'm the guy that killed the monster
rosemanAppraise(o, [motiveConsistent, otherCaused, unexpected]).

% i tried to kill the monster who killed your wife and children, but failed
rosemanAppraise(p, [motiveInconsistent, circumstanceCaused, aversive, lowControlPotential]).

% a monster killed your wife and children
rosemanAppraise(q, [motiveInconsistent, circumstanceCaused, lowControlPotential, aversisve]).

% i made the monster that killed your wife and children
rosemanAppraise(r, [motiveInconsistent, otherCaused, aversive, characterological]).

% i think YOU made the monster that killed your wife and children
rosemanAppraise(s, [motiveInconsistent, selfCaused]).

% is there any work for me around here?
rosemanAppraise(t, [motiveConsistent, otherCaused]).

% i'm actually a woman
rosemanAppraise(u, [unexpected, certain, motiveConsistent, appetitive, circumstanceCaused]).

% Did you see the dress the Queen was wearing at the parade?
rosemanAppraise(v, [motiveconsistent, circumstance, uncertain]).

% smithEllsworthAppraise(+Stimulus, -SmithEllsworthAppraisals)
% a list of matching stimulus/appraisal pairs
smithEllsworthAppraise(killMother, [lowPleasantness,
	lowAttractiveAttentionalActivity, veryHighAnticipatedEffort]).
smithEllsworthAppraise(makeMonster, [lowPleasantness,
	highRepulsiveAttentionalActivity, lowCertainty, highAnticipatedEffort]).
smithEllsworthAppraise(buyAxe, [highPleasantness,
	lowAttractiveAttentionalActivity]).
smithEllsworthAppraise(killMonster, [highPleasantness,
	lowAttractiveAttentionalActivity, veryLowAnticipatedEffort]).
smithEllsworthAppraise(i, [highOtherResponsibility, highPersonalControl]).
smithEllsworthAppraise(they, [highOtherResponsibility, lowPersonalControl]).
smithEllsworthAppraise(you, [highSelfResponsibility, highPersonalControl]).
smithEllsworthAppraise(yesYou, [highSelfResponsibility,
	mediumAnticipatedEffort, highPersonalControl, lowCertainty]).
smithEllsworthAppraise(someone, [highOtherResponsibility,
	lowAnticipatedEffort, highSituationalControl]).
smithEllsworthAppraise(youMissedSomeone, [lowSelfResponsibility,
	lowAnticipatedEffort, highSituationalControl]).
smithEllsworthAppraise(did, [highCertainty]).
smithEllsworthAppraise(will, [mediumCertainty, highAnticipatedEffort]).
smithEllsworthAppraise(iKnow, [veryHighCertainty]).
smithEllsworthAppraise(iveHeard, [veryLowCertainty]).
smithEllsworthAppraise(didYouKnow, [extremelyLowCertainty]).
smithEllsworthAppraise(typical, []).
smithEllsworthAppraise(whodaThunkIt, []).

/*
% user didn't get the groceries i asked him to
smithEllsworthAppraise(a, [lowPleasantness, highOtherResponsibility, highPersonalControl, highCertainty, highAnticipatedEffort, lowRepulsiveAttentionalActivity]).
% user might not bless my doorway
smithEllsworthAppraise(b, [lowPleasantness, highOtherResponsibility, lowPersonalControl, lowCertainty, veryHighAnticipatedEffort, lowAttractiveAttentionalActivity]).
% user bought my axe
smithEllsworthAppraise(c, [veryHighPleasantness, lowOtherResponsibility, highPersonalControl, highCertainty, lowAnticipatedEffort, lowAttractiveAttentionalActivity]).
% i'm making a beautiful axe
smithEllsworthAppraise(d, [veryHighPleasantness, highSelfResponsibility, highPersonalControl, lowCertainty, highAnticipatedEfforot, highAttractiveAttentionalActivity]).
% the wicked witch of the west is dead!
smithEllsworthAppraise(e, [veryHighPleasantness, highOtherResponsibility, highSituationalControl, extremelyLowCertainty, lowAnticipatedEffort, lowAttractiveAttentionalActivity]).
% i tripped as i was running to the tailor
smithEllsworthAppraise(f, [lowPleasantness, lowSelfResponsibility, highSituationalControl, lowCertainty, highAnticipatedEffort, lowAttractiveAttentionalActivity]).
% it might rain tonight
smithEllsworthAppraise(g, [lowPleasantness, highOtherResponsibility, highSituationalControl, lowCertainty, veryHighAnticipatedEffort, lowRepulsiveAttentionalActivity]).
*/

%%%%%%%%%%
%% same again, Smith & Ellsworth but

% i'd like to buy your (axe/staff/armour/etc) - offer the right price
smithEllsworthAppraise(a, [veryHighPleasantness, extremelyLowAnticipatedEffort, veryHighCertainty, lowAttractiveAttentionalActivity, lowSelfResponsibility, lowPersonalControl]).

% i'd like to buy your (axe/staff/armour/etc) - offer above the right price
smithEllsworthAppraise(b, [veryHighPleasantness, extremelyLowAnticipatedEffort, veryHighCertainty, lowAttractiveAttentionalActivity, lowSelfResponsibility, lowPersonalControl]).

% i'd like to buy your (axe/staff/armour/etc) - offer below the right price
smithEllsworthAppraise(c, [highPleasantness, veryHighAnticipatedEffort, highCertainty, lowAttractiveAttentionalActivity, lowSelfResponsibility, lowPersonalControl]).

% is that (axe/staff/armour/etc) for sale?
smithEllsworthAppraise(d, [veryHighPleasantness, extremelyLowAnticipatedEffort, veryHighCertainty, lowAttractiveAttentionalActivity, lowSelfResponsibility, lowSituationalControl]).

% here, buy this (axe/staff/armour/etc) off me - bargain price
smithEllsworthAppraise(e, [veryHighPleasantness, lowAnticipatedEffort, highCertainty, highAttractiveAttentionalActivity, equalResponsibility, lowSituationalControl]).

% here, buy this (axe/staff/armour/etc) off me - reasonable price
smithEllsworthAppraise(f, [veryHighPleasantness, lowAnticipatedEffort, highCertainty, highAttractiveAttentionalActivity, equalResponsibility, lowSituationalControl]).

% here, buy this (axe/staff/armour/etc) off me - unreasonable price
smithEllsworthAppraise(g, [highPleasantness, veryHighAnticipatedEffort, highAttractiveAttentionalActivity, lowSelfResponsibility]).

% here, fix this (axe/staff/armour/etc), it's broken
smithEllsworthAppraise(h, [highPleasantness, veryHighAnticipatedEffort, highCertainty, highAttractiveAttentionalActivity, equalControl, lowSelfResponsibility]).

% hoi, you sold me a crap (axe/staff/piece of armour/etc), i want my money back
smithEllsworthAppraise(i, [veryLowPleasantness, veryHighAnticipatedEffort, lowCertainty, highAttractiveAttentionalActivity, equalControl, lowOtherResponsibility]).

% you sold me that (axe/staff/armour/etc), it was really good, great work!
smithEllsworthAppraise(j, [highPleasantness, veryLowAnticipatedEffort, veryHighCertainty, lowAttractiveAttentionalActivity, lowPersonalControl, highSelfResponsibility]).

% i think you sabotaged my (axe/staff/armour/etc), is that true?
smithEllsworthAppraise(k, [lowPleasantness, highAnticipatedEffort, highCertainty, lowRepulsiveAttentionalActivity, lowPersonalControl, highSelfResponsibility]).

% i've kidnapped your wife and children, give me that (axe/staff/armour/etc)
smithEllsworthAppraise(l, [veryLowPleasantness, highAnticipatedEffort, veryHighCertainty, lowRepulsiveAttentionalActivity, highOtherResponsibility, lowPersonalControl]).

% i'm the guy that killed your wife and children, i'm terribly sorry, i didn't realise 
smithEllsworthAppraise(m, [veryLowPleasantness, highAnticipatedEffort, veryHighCertainty, lowRepulsiveAttentionalActivity, highOtherResponsibility, lowPersonalControl]).

% the monster who killed your wife and children is dead
smithEllsworthAppraise(n, [veryHighPleasantness, extremelyLowAnticipatedEffort, veryHighCertainty, highAttractiveAttentionalActivity, lowSelfResponsibility, lowPersonalControl]).

% i'm the guy that killed the monster
smithEllsworthAppraise(o, [veryHighPleasantness, extremelyLowAnticipatedEffort, veryHighCertainty, highAttractiveAttentionalActivity, lowSelfResponsibility, lowPersonalControl]).

% i tried to kill the monster who killed your wife and children, but failed
smithEllsworthAppraise(p, [veryLowPleasantness, veryHighAnticipatedEffort, highAttractiveAttentionalActivity, lowCertainty, equalControl, lowOtherResponsibility]).

% a monster killed your wife and children
smithEllsworthAppraise(q, [lowPleasantness, veryHighAnticipatedEffort, extremelyLowCertainty, neutralAttentionalActivity, highSituationalControl, equalResponsibility]).

% i made the monster that killed your wife and children
smithEllsworthAppraise(r, [lowPleasantness, mediumAnticipatedEffort, lowRepulsiveAttentionalActivity, highCertainty, lowPersonalControl, highOtherResponsibility]).

% i think YOU made the monster that killed your wife and children
smithEllsworthAppraise(s, [lowPleasantness, highAnticipatedEffort, extremelyLowCertainty, neutralAttentionalActivity, highSituationalControl, equalResponsibility]).

% is there any work for me around here?
smithEllsworthAppraise(t, [veryHighPleasantness, lowAnticipatedEffort, mediumCertainty, highAttractiveAttentionalActivity, equalResponsibility, lowSituationalControl]).

% i'm actually a woman
smithEllsworthAppraise(u, [veryHighPleasantness, extremelyLowAnticipatedEffort, extremelyLowCertainty, highAttractiveAttentionalActivity, lowPersonalControl, lowOtherResponsibility]).

% Did you see the dress the Queen was wearing at the parade?
smithEllsworthAppraise(v, [veryLowAnticipatedEffort, lowPleasantness, veryHighRepulsiveAttentionalActivity, certain, lowOtherResponsibility, lowSituationalControl]).
