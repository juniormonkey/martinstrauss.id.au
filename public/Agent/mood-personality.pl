:- module(moodAndPersonality, [generateMood/5, generateMood/6, whatMood/3, nextMoodMatch/3]).

% generateMood - generates a NewMood from the old Mood, the agent's Personality,
%					and the emotions elicited by the Smith & Ellsworth (SEEmotions)
%					and Roseman (REmotions) appraisals
generateMood(Mood, Personality, SEEmotions, REmotions, NewMood) :-
	applyEmotions(Mood, SEEmotions, REmotions, IntMood),
	applyPersonality(IntMood, Personality, NewMood).

% generateMood - generates a NewMood from the old Mood, the agent's Personality,
%					the emotions elicited by the Smith & Ellsworth (SEEmotions)
%					and Roseman (REmotions) appraisals and the biofeedback
%					(BEmotions)
generateMood(Mood, Personality, SEEmotions, REmotions, BEmotions, NewMood) :-
	applyEmotions(Mood, SEEmotions, REmotions, IntMood),
	applyContagion(IntMood, BEmotions, IntMood2),
	applyPersonality(IntMood2, Personality, NewMood).

% applyEmotions - takes the old mood vector and generates a new mood vector
%						by adding the elicited emotions
applyEmotions(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	SEEmotions,
	REmotions,
	[NAnger, NBoredom, NChallenge, NContempt, NDislike, NDistress, NDisgust,
		NFear, NFrustration, NGuilt, NHope, NInterest, NJoy, NLiking, NPride,
		NRegret, NRelief, NSadness, NShame, NSurprise]) :-
	(member(anger, SEEmotions) -> A1 is 0.5; A1 is 0),
	(member(anger, REmotions) -> A2 is 1; A2 is 0),
	NAnger is 0.9 * Anger + A1 + A2,
	(member(boredom, SEEmotions) -> B1 is 0.5; B1 is 0),
	(member(boredom, REmotions) -> B2 is 1; B2 is 0),
	NBoredom is 0.9 * Boredom + B1 + B2,
	(member(challenge, SEEmotions) -> Ch1 is 0.5; Ch1 is 0),
	(member(challenge, REmotions) -> Ch2 is 1; Ch2 is 0),
	NChallenge is 0.9 * Challenge + Ch1 + Ch2,
	(member(contempt, SEEmotions) -> Co1 is 0.5; Co1 is 0),
	(member(contempt, REmotions) -> Co2 is 1; Co2 is 0),
	NContempt is 0.9 * Contempt + Co1 + Co2,
	(member(dislike, SEEmotions) -> Di1 is 0.5; Di1 is 0),
	(member(dislike, REmotions) -> Di2 is 1; Di2 is 0),
	NDislike is 0.9 * Dislike + Di1 + Di2,
	(member(distress, SEEmotions) -> Dt1 is 0.5; Dt1 is 0),
	(member(distress, REmotions) -> Dt2 is 1; Dt2 is 0),
	NDistress is 0.9 * Distress + Dt1 + Dt2,
	(member(disgust, SEEmotions) -> Dg1 is 0.5; Dg1 is 0),
	(member(disgust, REmotions) -> Dg2 is 1; Dg2 is 0),
	NDisgust is 0.9 * Disgust + Dg1 + Dg2,
	(member(fear, SEEmotions) -> F1 is 0.5; F1 is 0),
	(member(fear, REmotions) -> F2 is 1; F2 is 0),
	NFear is 0.9 * Fear + F1 + F2,
	(member(frustration, SEEmotions) -> Fr1 is 0.5; Fr1 is 0),
	(member(frustration, REmotions) -> Fr2 is 1; Fr2 is 0),
	NFrustration is 0.9 * Frustration + Fr1 + Fr2,
	(member(guilt, SEEmotions) -> G1 is 0.5; G1 is 0),
	(member(guilt, REmotions) -> G2 is 1; G2 is 0),
	NGuilt is 0.9 * Guilt + G1 + G2,
	(member(hope, SEEmotions) -> H1 is 0.5; H1 is 0),
	(member(hope, REmotions) -> H2 is 1; H2 is 0),
	NHope is 0.9 * Hope + H1 + H2,
	(member(interest, SEEmotions) -> I1 is 0.5; I1 is 0),
	(member(interest, REmotions) -> I2 is 1; I2 is 0),
	NInterest is 0.9 * Interest + I1 + I2,
	(member(joy, SEEmotions) -> J1 is 0.5; J1 is 0),
	(member(joy, REmotions) -> J2 is 1; J2 is 0),
	NJoy is 0.9 * Joy + J1 + J2,
	(member(liking, SEEmotions) -> L1 is 0.5; L1 is 0),
	(member(liking, REmotions) -> L2 is 1; L2 is 0),
	NLiking is 0.9 * Liking + L1 + L2,
	(member(pride, SEEmotions) -> P1 is 0.5; P1 is 0),
	(member(pride, REmotions) -> P2 is 1; P2 is 0),
	NPride is 0.9 * Pride + P1 + P2,
	(member(regret, SEEmotions) -> Rg1 is 0.5; Rg1 is 0),
	(member(regret, REmotions) -> Rg2 is 1; Rg2 is 0),
	NRegret is 0.9 * Regret + Rg1 + Rg2,
	(member(relief, SEEmotions) -> Rl1 is 0.5; Rl1 is 0),
	(member(relief, REmotions) -> Rl2 is 1; Rl2 is 0),
	NRelief is 0.9 * Relief + Rl1 + Rl2,
	(member(sadness, SEEmotions) -> S1 is 0.5; S1 is 0),
	(member(sadness, REmotions) -> S2 is 1; S2 is 0),
	NSadness is 0.9 * Sadness + S1 + S2,
	(member(shame, SEEmotions) -> Sh1 is 0.5; Sh1 is 0),
	(member(shame, REmotions) -> Sh2 is 1; Sh2 is 0),
	NShame is 0.9 * Shame + Sh1 + Sh2,
	(member(surprise, SEEmotions) -> Su1 is 0.5; Su1 is 0),
	(member(surprise, REmotions) -> Su2 is 1; Su2 is 0),
	NSurprise is 0.9 * Surprise + Su1 + Su2.

% applyEmotions - takes the old mood vector and generates a new mood vector
%						by adding the effects of contagion
applyContagion(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	BEmotions,
	[NAnger, NBoredom, NChallenge, NContempt, NDislike, NDistress, NDisgust,
		NFear, NFrustration, NGuilt, NHope, NInterest, NJoy, NLiking, NPride,
		NRegret, NRelief, NSadness, NShame, NSurprise]) :-
	(member(anger, BEmotions) -> NAnger is 1.1 * Anger ; NAnger is Anger),
	(member(boredom, BEmotions) -> NBoredom is 1.1 * Boredom ;
		NBoredom is Boredom),
	(member(challenge, BEmotions) -> NChallenge is 1.1 * Challenge ;
		NChallenge is Challenge),
	(member(contempt, BEmotions) -> NContempt is 1.1 * Contempt ;
		NContempt is Contempt),
	(member(dislike, BEmotions) -> NDislike is 1.1 * Dislike ;
		NDislike is Dislike),
	(member(distress, BEmotions) -> NDistress is 1.1 * Distress ;
		NDistress is Distress),
	(member(disgust, BEmotions) -> NDisgust is 1.1 * Disgust ;
		NDisgust is Disgust),
	(member(fear, BEmotions) -> NFear is 1.1 * Fear ; NFear is Fear),
	(member(frustration, BEmotions) -> NFrustration is 1.1 * Frustration ;
		NFrustration is Frustration),
	(member(guilt, BEmotions) -> NGuilt is 1.1 * Guilt ; NGuilt is Guilt),
	(member(hope, BEmotions) -> NHope is 1.1 * Hope ; NHope is Hope),
	(member(interest, BEmotions) -> NInterest is 1.1 * Interest ;
		NInterest is Interest),
	(member(joy, BEmotions) -> NJoy is 1.1 * Joy ; NJoy is Joy),
	(member(liking, BEmotions) -> NLiking is 1.1 * Liking ; NLiking is Liking),
	(member(pride, BEmotions) -> NPride is 1.1 * Pride ; NPride is Pride),
	(member(regret, BEmotions) -> NRegret is 1.1 * Regret ; NRegret is Regret),
	(member(relief, BEmotions) -> NRelief is 1.1 * Relief ; NRelief is Relief),
	(member(sadness, BEmotions) -> NSadness is 1.1 * Sadness ;
		NSadness is Sadness),
	(member(shame, BEmotions) -> NShame is 1.1 * Shame ; NShame is Shame),
	(member(surprise, BEmotions) -> NSurprise is 1.1 * Surprise ;
		NSurprise is Surprise).

% applyPersonality - takes the old mood vector and generates a new mood vector
%							by adding the effects of the agent's personality
applyPersonality(
	[MAnger, MBoredom, MChallenge, MContempt, MDislike, MDistress, MDisgust,
		MFear, MFrustration, MGuilt, MHope, MInterest, MJoy, MLiking, MPride,
		MRegret, MRelief, MSadness, MShame, MSurprise],
	[PAnger, PBoredom, PChallenge, PContempt, PDislike, PDistress, PDisgust,
		PFear, PFrustration, PGuilt, PHope, PInterest, PJoy, PLiking, PPride,
		PRegret, PRelief, PSadness, PShame, PSurprise],
	[OAnger, OBoredom, OChallenge, OContempt, ODislike, ODistress, ODisgust,
		OFear, OFrustration, OGuilt, OHope, OInterest, OJoy, OLiking, OPride,
		ORegret, ORelief, OSadness, OShame, OSurprise]) :-
	OAnger is MAnger * (2^PAnger),
	OBoredom is MBoredom * (2^PBoredom),
	OChallenge is MChallenge * (2^PChallenge),
	OContempt is MContempt * (2^PContempt),
	ODislike is MDislike * (2^PDislike),
	ODistress is MDistress * (2^PDistress),
	ODisgust is MDisgust * (2^PDisgust),
	OFear is MFear * (2^PFear),
	OFrustration is MFrustration * (2^PFrustration),
	OGuilt is MGuilt * (2^PGuilt),
	OHope is MHope * (2^PHope),
	OInterest is MInterest * (2^PInterest),
	OJoy is MJoy * (2^PJoy),
	OLiking is MLiking * (2^PLiking),
	OPride is MPride * (2^PPride),
	ORegret is MRegret * (2^PRegret),
	ORelief is MRelief * (2^PRelief),
	OSadness is MSadness * (2^PSadness),
	OShame is MShame * (2^PShame),
	OSurprise is MSurprise * (2^PSurprise).

% whatMood - takes a mood vector and returns a name for the mood in Mood, and
%					its intensity in Intensity
whatMood(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	Mood, Intensity) :-
	biggest(
		[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise], Max),
	(
	Max is 0 -> Mood = none;
	Anger is Max -> Mood = anger;
	Boredom is Max -> Mood = boredom;
	Challenge is Max -> Mood = challenge;
	Contempt is Max -> Mood = contempt;
	Dislike is Max -> Mood = dislike;
	Distress is Max -> Mood = distress;
	Disgust is Max -> Mood = disgust;
	Fear is Max -> Mood = fear;
	Frustration is Max -> Mood = frustration;
	Guilt is Max -> Mood = guilt;
	Hope is Max -> Mood = hope;
	Interest is Max -> Mood = interest;
	Joy is Max -> Mood = joy;
	Liking is Max -> Mood = liking;
	Pride is Max -> Mood = pride;
	Regret is Max -> Mood = regret;
	Relief is Max -> Mood = relief;
	Sadness is Max -> Mood = sadness;
	Shame is Max -> Mood = shame;
	Surprise is Max -> Mood = surprise
	),
	nextMoodMatch(
		[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise], Mood, NextMood),
	biggest(NextMood, Max2),
	Intensity is Max - Max2.
	
% biggest - returns the maximum of a list
biggest([Item], Item).
biggest([Item|Rest], Max) :-
	biggest(Rest, MaxSoFar),
	Max is max(Item, MaxSoFar).

% nextMoodMatch(+Mood, +Emotion, -NewMood)
%		- removes Emotion from Mood to give NewMood
nextMoodMatch(
	[_Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	anger,
	[0, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, _Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	boredom,
	[Anger, 0, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, _Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	challenge,
	[Anger, Boredom, 0, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, _Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	contempt,
	[Anger, Boredom, Challenge, 0, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, _Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	dislike,
	[Anger, Boredom, Challenge, Contempt, 0, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, _Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	distress,
	[Anger, Boredom, Challenge, Contempt, Dislike, 0, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, _Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	disgust,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, 0, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, _Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	fear,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, 0,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		_Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	frustration,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		0, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, _Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	guilt,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, 0, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, _Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	hope,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, 0, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, _Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	interest,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, 0, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, _Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	joy,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, 0, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, _Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	liking,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, 0, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, _Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	pride,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, 0, Regret, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, _Regret, Relief,
		Sadness, Shame, Surprise],
	regret,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, 0, Relief,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, _Relief,
		Sadness, Shame, Surprise],
	relief,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, 0,
		Sadness, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		_Sadness, Shame, Surprise],
	sadness,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		0, Shame, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, _Shame, Surprise],
	shame,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, 0, Surprise]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, _Surprise],
	surprise,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, 0]
	).
nextMoodMatch(
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise],
	none,
	[Anger, Boredom, Challenge, Contempt, Dislike, Distress, Disgust, Fear,
		Frustration, Guilt, Hope, Interest, Joy, Liking, Pride, Regret, Relief,
		Sadness, Shame, Surprise]
	).
