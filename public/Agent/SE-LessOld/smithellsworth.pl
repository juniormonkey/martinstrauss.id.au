:- module(smithAndEllsworth, [smithEllsworthEmotions/2, smithEllsworthAppraisals/2]).

% this is just to test: the real agent will have moods and some continuity.
smithEllsworthEmotions(Event, Emotions) :-
	bagof(
		Emotion,
		smithEllsworthEmotion(Event, Emotion),
		Emotions).
smithEllsworthEmotion(Event, Emotion) :- 
	smithEllsworthAppraiseEvents(Event, SmithEllsworthAppraisals),
	write('Appraisals: '), write(SmithEllsworthAppraisals), write('\n'),
	smithEllsworthRemoveConflicts(SmithEllsworthAppraisals, CleanAppraisals),
	smithEllsworthAppraisal(Emotion, CleanAppraisals).

% this is used by the agent.  Given a list of appraisals, produces the
% appropriate emotion
smithEllsworthAppraisals(AppraisalsList, Emotions) :-
	smithEllsworthRemoveConflicts(AppraisalsList, CleanAppraisals),
	bagof(
		Emotion,
		smithEllsworthAppraisal(Emotion, CleanAppraisals),
		Emotions).

% SmithEllsworthAppraisal(?Emotion, [SmithEllsworthAppraisals]).
smithEllsworthAppraisal(none, []) :- !.

smithEllsworthAppraisal(pride, AppraisalsList) :-
	dimensionMember(extremelyLowAnticipatedEffort, AppraisalsList),
	dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList),
	dimensionMember(highSelfResponsibility, AppraisalsList),
	dimensionMember(veryHighCertainty, AppraisalsList),
	dimensionMember(veryHighPleasantness, AppraisalsList).%,
%	dimensionMember(lowPersonalControl, AppraisalsList).

smithEllsworthAppraisal(joy, AppraisalsList) :-
	dimensionMember(extremelyLowAnticipatedEffort, AppraisalsList),
	dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList),
%	dimensionMember(lowSelfResponsibility, AppraisalsList),
	dimensionMember(veryHighCertainty, AppraisalsList),
	dimensionMember(veryHighPleasantness, AppraisalsList).%,
%	dimensionMember(equalControl, AppraisalsList).

smithEllsworthAppraisal(hope, AppraisalsList) :-
%	dimensionMember(mediumAnticipatedEffort, AppraisalsList),
	dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList),
%	dimensionMember(lowSelfResponsibility, AppraisalsList),
	dimensionMember(lowCertainty, AppraisalsList),
	dimensionMember(highPleasantness, AppraisalsList).%,
%	dimensionMember(lowSituationalControl, AppraisalsList).

smithEllsworthAppraisal(fear, AppraisalsList) :-
	dimensionMember(veryHighAnticipatedEffort, AppraisalsList),
%	dimensionMember(neutralAttentionalActivity, AppraisalsList),
%	dimensionMember(lowOtherResponsibility, AppraisalsList),
	dimensionMember(extremelyLowCertainty, AppraisalsList),
	dimensionMember(lowPleasantness, AppraisalsList),
	dimensionMember(highSituationalControl, AppraisalsList).

smithEllsworthAppraisal(sadness, AppraisalsList) :-
	dimensionMember(highAnticipatedEffort, AppraisalsList),
%	dimensionMember(lowRepulsiveAttentionalActivity, AppraisalsList),
%	dimensionMember(highOtherResponsibility, AppraisalsList),
%	dimensionMember(lowCertainty, AppraisalsList),
	dimensionMember(veryLowPleasantness, AppraisalsList).%,
%	dimensionMember(highSituationalControl, AppraisalsList).

smithEllsworthAppraisal(frustration, AppraisalsList) :-
	dimensionMember(veryHighAnticipatedEffort, AppraisalsList),
	dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList),
%	dimensionMember(lowOtherResponsibility, AppraisalsList),
	dimensionMember(lowCertainty, AppraisalsList),
	dimensionMember(veryLowPleasantness, AppraisalsList).%,
%	dimensionMember(equalControl, AppraisalsList).

smithEllsworthAppraisal(disgust, AppraisalsList) :-
%	dimensionMember(mediumAnticipatedEffort, AppraisalsList),
	dimensionMember(highRepulsiveAttentionalActivity, AppraisalsList),
	dimensionMember(highOtherResponsibility, AppraisalsList),
	dimensionMember(highCertainty, AppraisalsList),
	dimensionMember(lowPleasantness, AppraisalsList).%,
%	dimensionMember(lowPersonalControl, AppraisalsList).

smithEllsworthAppraisal(anger, AppraisalsList) :-
	dimensionMember(veryHighAnticipatedEffort, AppraisalsList),
%	dimensionMember(neutralAttentionalActivity, AppraisalsList),
	dimensionMember(highOtherResponsibility, AppraisalsList),
	dimensionMember(highCertainty, AppraisalsList),
	dimensionMember(veryLowPleasantness, AppraisalsList).%,
%	dimensionMember(lowPersonalControl, AppraisalsList).

smithEllsworthAppraisal(contempt, AppraisalsList) :-
	dimensionMember(highAnticipatedEffort, AppraisalsList),
%	dimensionMember(neutralAttentionalActivity, AppraisalsList),
	dimensionMember(highOtherResponsibility, AppraisalsList),
	dimensionMember(highCertainty, AppraisalsList),
	dimensionMember(veryLowPleasantness, AppraisalsList).%,
%	dimensionMember(lowPersonalControl, AppraisalsList).

smithEllsworthAppraisal(guilt, AppraisalsList) :-
	dimensionMember(highAnticipatedEffort, AppraisalsList),
%	dimensionMember(lowRepulsiveAttentionalActivity, AppraisalsList),
	dimensionMember(highSelfResponsibility, AppraisalsList),
	dimensionMember(highCertainty, AppraisalsList),
	dimensionMember(lowPleasantness, AppraisalsList).%,
%	dimensionMember(lowPersonalControl, AppraisalsList).

smithEllsworthAppraisal(shame, AppraisalsList) :-
	dimensionMember(veryHighAnticipatedEffort, AppraisalsList),
%	dimensionMember(lowRepulsiveAttentionalActivity, AppraisalsList),
	dimensionMember(highSelfResponsibility, AppraisalsList),
%	dimensionMember(mediumCertainty, AppraisalsList),
	dimensionMember(lowPleasantness, AppraisalsList).%,
%	dimensionMember(lowPersonalControl, AppraisalsList).

smithEllsworthAppraisal(boredom, AppraisalsList) :-
	dimensionMember(veryLowAnticipatedEffort, AppraisalsList),
	dimensionMember(veryHighRepulsiveAttentionalActivity, AppraisalsList),
%	dimensionMember(lowOtherResponsibility, AppraisalsList),
	dimensionMember(veryHighCertainty, AppraisalsList),
	dimensionMember(lowPleasantness, AppraisalsList).%,
%	dimensionMember(lowSituationalControl, AppraisalsList).

smithEllsworthAppraisal(challenge, AppraisalsList) :-
	dimensionMember(veryHighAnticipatedEffort, AppraisalsList),
	dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList),
%	dimensionMember(lowSelfResponsibility, AppraisalsList),
	dimensionMember(mediumCertainty, AppraisalsList),
	dimensionMember(highPleasantness, AppraisalsList).%,
%	dimensionMember(equalControl, AppraisalsList).

smithEllsworthAppraisal(interest, AppraisalsList) :-
	dimensionMember(lowAnticipatedEffort, AppraisalsList),
	dimensionMember(highAttractiveAttentionalActivity, AppraisalsList),
%	dimensionMember(equalResponsibility, AppraisalsList),
	dimensionMember(highCertainty, AppraisalsList),
	dimensionMember(veryHighPleasantness, AppraisalsList).%,
%	dimensionMember(lowSituationalControl, AppraisalsList).

smithEllsworthAppraisal(surprise, AppraisalsList) :-
	dimensionMember(extremelyLowAnticipatedEffort, AppraisalsList),
	dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList),
	dimensionMember(highOtherResponsibility, AppraisalsList),
	dimensionMember(extremelyLowCertainty, AppraisalsList).%,
%	dimensionMember(veryHighPleasantness, AppraisalsList).%,
%	dimensionMember(lowPersonalControl, AppraisalsList).

% dimensionMember(+appraisal, +list) 
% true if appraisal is in list, or if appraisal's opposite is not in list
dimensionMember(extremelyLowAnticipatedEffort, AppraisalsList) :-
	listMatch(extremelyLowAnticipatedEffort,
		[mediumAnticipatedEffort,
			highAnticipatedEffort, veryHighAnticipatedEffort],
		AppraisalsList).
dimensionMember(veryLowAnticipatedEffort, AppraisalsList) :-
	listMatch(veryLowAnticipatedEffort,
		[mediumAnticipatedEffort,
			highAnticipatedEffort, veryHighAnticipatedEffort],
		AppraisalsList).
dimensionMember(lowAnticipatedEffort, AppraisalsList) :-
	listMatch(lowAnticipatedEffort,
		[highAnticipatedEffort, veryHighAnticipatedEffort],
		AppraisalsList).
dimensionMember(mediumAnticipatedEffort, AppraisalsList) :-
	listMatch(mediumAnticipatedEffort,
		[veryLowAnticipatedEffort, veryHighAnticipatedEffort],
		AppraisalsList).
dimensionMember(highAnticipatedEffort, AppraisalsList) :-
	listMatch(highAnticipatedEffort,
		[lowAnticipatedEffort, veryLowAnticipatedEffort],
		AppraisalsList).
dimensionMember(veryHighAnticipatedEffort, AppraisalsList) :-
	listMatch(veryHighAnticipatedEffort,
		[mediumAnticipatedEffort,
			lowAnticipatedEffort, veryLowAnticipatedEffort],
		AppraisalsList).

dimensionMember(veryHighRepulsiveAttentionalActivity, AppraisalsList) :-
	listMatch(veryHighRepulsiveAttentionalActivity,
		[neutralAttentionalActivity,
			lowAttractiveAttentionalActivity, highAttractiveAttentionalActivity],
		AppraisalsList).
dimensionMember(highRepulsiveAttentionalActivity, AppraisalsList) :-
	listMatch(highRepulsiveAttentionalActivity,
		[neutralAttentionalActivity,
			lowAttractiveAttentionalActivity, highAttractiveAttentionalActivity],
		AppraisalsList).
dimensionMember(lowRepulsiveAttentionalActivity, AppraisalsList) :-
	listMatch(lowRepulsiveAttentionalActivity,
		[lowAttractiveAttentionalActivity, highAttractiveAttentionalActivity],
		AppraisalsList).
dimensionMember(neutralAttentionalActivity, AppraisalsList) :-
	listMatch(extremelyLowAttentionalActivity,
		[veryHighRepulsiveAttentionalActivity, highAttractiveAttentionalActivity],
		AppraisalsList).
dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList) :-
	listMatch(lowAttractiveAttentionalActivity,
		[lowRepulsiveAttentionalActivity,
		highRepulsiveAttentionalActivity, veryHighRepulsiveAttentionalActivity],
		AppraisalsList).
dimensionMember(highAttractiveAttentionalActivity, AppraisalsList) :-
	listMatch(highAttractiveAttentionalActivity,
		[neutralAttentionalActivity, lowRepulsiveAttentionalActivity,
		highRepulsiveAttentionalActivity, veryHighRepulsiveAttentionalActivity],
		AppraisalsList).

dimensionMember(extremelyLowCertainty, AppraisalsList) :-
	listMatch(extremelyLowCertainty,
		[mediumCertainty,	highCertainty, veryHighCertainty],
		AppraisalsList).
dimensionMember(veryLowCertainty, AppraisalsList) :-
	listMatch(veryLowCertainty,
		[mediumCertainty,	highCertainty, veryHighCertainty, extremelyLowCertainty],
		AppraisalsList).
dimensionMember(lowCertainty, AppraisalsList) :-
	listMatch(lowCertainty,
		[highCertainty, veryHighCertainty, extremelyLowCertainty],
		AppraisalsList).
dimensionMember(mediumCertainty, AppraisalsList) :-
	listMatch(mediumCertainty,
		[extremelyLowCertainty, veryLowCertianty, veryHighCertainty],
		AppraisalsList).
dimensionMember(highCertainty, AppraisalsList) :-
	listMatch(highCertainty,
		[lowCertainty, veryLowCertainty, extremelyLowCertainty],
		AppraisalsList).
dimensionMember(veryHighCertainty, AppraisalsList) :-
	listMatch(veryHighCertainty,
		[mediumCertainty, lowCertainty, veryLowCertainty, extremelyLowCertainty],
		AppraisalsList).

dimensionMember(highPersonalControl, AppraisalsList) :-
	listMatch(highPersonalControl,
		[equalControl,	lowSituationalControl, highSituationalControl],
		AppraisalsList).
dimensionMember(lowPersonalControl, AppraisalsList) :-
	listMatch(lowPersonalControl,
		[lowSituationalControl, highSituationalControl],
		AppraisalsList).
dimensionMember(equalControl, AppraisalsList) :-
	listMatch(equalControl,
		[highPersonalControl, highSituationalControl],
		AppraisalsList).
dimensionMember(lowSituationalControl, AppraisalsList) :-
	listMatch(lowSituationalControl,
		[lowPersonalControl, highPersonalControl],
		AppraisalsList).
dimensionMember(highSituationalControl, AppraisalsList) :-
	listMatch(highSituationalControl,
		[equalControl, lowPersonalControl, highPersonalControl],
		AppraisalsList).

dimensionMember(veryLowPleasantness, AppraisalsList) :-
	listMatch(veryLowPleasantness,
		[mediumPleasantness, highPleasantness, veryHighPleasantness],
		AppraisalsList).
dimensionMember(lowPleasantness, AppraisalsList) :-
	listMatch(lowPleasantness,
		[highPleasantness, veryHighPleasantness],
		AppraisalsList).
dimensionMember(mediumLowPleasantness, AppraisalsList) :-
	listMatch(mediumLowPleasantness,
		[veryLowPleasantness, veryHighPleasantness],
		AppraisalsList).
dimensionMember(highPleasantness, AppraisalsList) :-
	listMatch(highPleasantness,
		[lowPleasantness, veryLowPleasantness],
		AppraisalsList).
dimensionMember(veryHighPleasantness, AppraisalsList) :-
	listMatch(veryHighPleasantness,
		[mediumPleasantness, lowPleasantness, veryLowPleasantness],
		AppraisalsList).

dimensionMember(highOtherResponsibility, AppraisalsList) :-
	listMatch(highOtherResponsibility,
		[equalResponsibility,
			lowSelfResponsibility, highSelfResponsibility],
		AppraisalsList).
dimensionMember(lowOtherResponsibility, AppraisalsList) :-
	listMatch(lowOtherResponsibility,
		[lowSelfResponsibility, highSelfResponsibility],
		AppraisalsList).
dimensionMember(equalResponsibility, AppraisalsList) :-
	listMatch(equalResponsibility,
		[highOtherResponsibility, highSelfResponsibility],
		AppraisalsList).
dimensionMember(lowSelfResponsibility, AppraisalsList) :-
	listMatch(lowSelfResponsibility,
		[lowOtherResponsibility, highOtherResponsibility],
		AppraisalsList).
dimensionMember(highSelfResponsibility, AppraisalsList) :-
	listMatch(highSelfResponsibility,
		[equalResponsibility,
			lowOtherResponsibility, highOtherResponsibility],
		AppraisalsList).

% listMatch(+Item, +List1, +List2)
%   true if Item is in List2, or if none of List1 are in List2.
listMatch(Item, List1, List2) :-
	member(Item, List2), ! ;
	disjoint(List1, List2).

% disjoint(+List1, +List2)
%   true if the two lists are disjoint.
disjoint([], _).
disjoint(_, []).
disjoint([Item|Rest], List) :-
	\+ member(Item, List),
	disjoint(Rest, List).

% listsDelete(+List1, +List2, ?List3)
%   returns true when List3 contains all elements of List1 not in List2.
listDelete(List1, [], List1).
listDelete(List1, [Item|Rest], List3) :-
	delete(List1, Item, List1a),
	listDelete(List1a, Rest, List3).

% smithEllsworthAppraisEvent(+Event, ?Appraisals) 
%	Appraisals is the list of appraisals of Event
smithEllsworthAppraiseEvent(killMother, 
	[lowPleasantness, lowAttractiveAttentionalActivity, 
	veryHighAnticipatedEffort]).
smithEllsworthAppraiseEvent(makeMonster, 
	[lowPleasantness, highRepulsiveAttentionalActivity,
	lowCertainty, highAnticipatedEffort]).
smithEllsworthAppraiseEvent(buyAxe,
	[highPleasantness, lowAttractiveAttentionalActivity]).
smithEllsworthAppraiseEvent(killMonster, 
	[highPleasantness, lowAttractiveAttentionalActivity,
	veryLowAnticipatedEffort]).
smithEllsworthAppraiseEvent(i, 
	[highOtherResponsibility, highPersonalControl]).
smithEllsworthAppraiseEvent(they, 
	[highOtherResponsibility, lowPersonalControl]).
smithEllsworthAppraiseEvent(you, 
	[highSelfResponsibility, highPersonalControl]).
smithEllsworthAppraiseEvent(yesYou, 
	[highSelfResponsibility, mediumAnticipatedEffort, highPersonalControl,
	lowCertainty]).
smithEllsworthAppraiseEvent(someone, 
	[highOtherResponsibility, lowAnticipatedEffort, highSituationalControl]).
smithEllsworthAppraiseEvent(youMissedSomeone,
	[lowSelfResponsibility, lowAnticipatedEffort, highSituationalControl]).
smithEllsworthAppraiseEvent(did, [highCertainty]).
smithEllsworthAppraiseEvent(will, [mediumCertainty, highAnticipatedEffort]).
smithEllsworthAppraiseEvent(iKnow, [veryHighCertainty]).
smithEllsworthAppraiseEvent(iveHeard, [veryLowCertainty]).
smithEllsworthAppraiseEvent(didYouKnow, [extremelyLowCertainty]).
smithEllsworthAppraiseEvent(typical, []).
smithEllsworthAppraiseEvent(whodaThunkIt, []).

smithEllsworthAppraiseEvent(hello, []).
smithEllsworthAppraiseEvent(goodbye, []).

% smithEllsworthAppraiseEvents(+List, ?Appraisals) 
%	Appraisals is the list of appraisals of the list of events in List
smithEllsworthAppraiseEvents(List, Appraisals) :-
	smithEllsworthAppraiseEvents1(List, Appraisals, []).

smithEllsworthAppraiseEvents1([Event], Appraisals, List) :- 
	smithEllsworthAppraiseEvent(Event, Appraisals1),
	append(Appraisals1, List, Appraisals).
smithEllsworthAppraiseEvents1([Event|EventList], Appraisals, List) :-
	smithEllsworthAppraiseEvent(Event, Appraisals1),
	append(Appraisals1, List, List1),
	smithEllsworthAppraiseEvents1(EventList, Appraisals2, List),
	append(Appraisals2, List1, Appraisals).

cleanList(AppraisalsList, Appraisal, Opposites, CleanAppraisals) :-
	((member(Appraisal, AppraisalsList),
	\+ disjoint(Opposites, AppraisalsList)) ->
		(delete(AppraisalsList, Appraisal, AppraisalsList1),
		listDelete(AppraisalsList1, Opposites, CleanAppraisals))
	;
		(CleanAppraisals = AppraisalsList)
	).

smithEllsworthRemoveConflicts(AppraisalsList, CleanAppraisals) :-
	cleanList(AppraisalsList, extremelyLowAnticipatedEffort,
		[mediumAnticipatedEffort,
			highAnticipatedEffort, veryHighAnticipatedEffort],
		L1),
	cleanList(L1, veryLowAnticipatedEffort,
		[mediumAnticipatedEffort,
			highAnticipatedEffort, veryHighAnticipatedEffort],
		L2),
	cleanList(L2, lowAnticipatedEffort,
		[highAnticipatedEffort, veryHighAnticipatedEffort],
		L3),
	cleanList(L3, mediumAnticipatedEffort,
		[veryLowAnticipatedEffort, veryHighAnticipatedEffort],
		L4),
	cleanList(L4, highAnticipatedEffort,
		[lowAnticipatedEffort, veryLowAnticipatedEffort],
		L5),
	cleanList(L5, veryHighAnticipatedEffort,
		[mediumAnticipatedEffort,
			lowAnticipatedEffort, veryLowAnticipatedEffort],
		L6),

	cleanList(L6, veryHighRepulsiveAttentionalActivity,
		[neutralAttentionalActivity,
			lowAttractiveAttentionalActivity, highAttractiveAttentionalActivity],
		L7),
	cleanList(L7, highRepulsiveAttentionalActivity,
		[neutralAttentionalActivity,
			lowAttractiveAttentionalActivity, highAttractiveAttentionalActivity],
		L8),
	cleanList(L8, lowRepulsiveAttentionalActivity,
		[lowAttractiveAttentionalActivity, highAttractiveAttentionalActivity],
		L9),
	cleanList(L9, extremelyLowAttentionalActivity,
		[veryHighRepulsiveAttentionalActivity, highAttractiveAttentionalActivity],
		L10),
	cleanList(L10, lowAttractiveAttentionalActivity,
		[lowRepulsiveAttentionalActivity,
		highRepulsiveAttentionalActivity, veryHighRepulsiveAttentionalActivity],
		L11),
	cleanList(L11, highAttractiveAttentionalActivity,
		[neutralAttentionalActivity, lowRepulsiveAttentionalActivity,
		highRepulsiveAttentionalActivity, veryHighRepulsiveAttentionalActivity],
		L12),

	cleanList(L12, extremelyLowCertainty,
		[mediumCertainty,	highCertainty, veryHighCertainty],
		L13),
	cleanList(L13, veryLowCertainty,
		[mediumCertainty,	highCertainty, veryHighCertainty],
		L14),
	cleanList(L14, lowCertainty,
		[highCertainty, veryHighCertainty],
		L15),
	cleanList(L15, mediumCertainty,
		[extremelyLowCertainty, veryLowCertianty, veryHighCertainty],
		L16),
	cleanList(L16, highCertainty,
		[lowCertainty, veryLowCertainty],
		L17),
	cleanList(L17, veryHighCertainty,
		[mediumCertainty, lowCertainty, veryLowCertainty],
		L18),

	cleanList(L18, highPersonalControl,
		[equalControl,	lowSituationalControl, highSituationalControl],
		L19),
	cleanList(L19, lowPersonalControl,
		[lowSituationalControl, highSituationalControl],
		L20),
	cleanList(L20, equalControl,
		[highPersonalControl, highSituationalControl],
		L21),
	cleanList(L21, lowSituationalControl,
		[lowPersonalControl, highPersonalControl],
		L22),
	cleanList(L22, highSituationalControl,
		[equalControl, lowPersonalControl, highPersonalControl],
		L23),

	cleanList(L23, veryLowPleasantness,
		[mediumPleasantness, highPleasantness, veryHighPleasantness],
		L24),
	cleanList(L24, lowPleasantness,
		[highPleasantness, veryHighPleasantness],
		L25),
	cleanList(L25, mediumLowPleasantness,
		[veryLowPleasantness, veryHighPleasantness],
		L26),
	cleanList(L26, highPleasantness,
		[lowPleasantness, veryLowPleasantness],
		L27),
	cleanList(L27, veryHighPleasantness,
		[mediumPleasantness, lowPleasantness, veryLowPleasantness],
		L28),

	cleanList(L28, highOtherResponsibility,
		[equalResponsibility,
			lowSelfResponsibility, highSelfResponsibility],
		L29),
	cleanList(L29, lowOtherResponsibility,
		[lowSelfResponsibility, highSelfResponsibility],
		L30),
	cleanList(L30, equalResponsibility,
		[highOtherResponsibility, highSelfResponsibility],
		L31),
	cleanList(L31, lowSelfResponsibility,
		[lowOtherResponsibility, highOtherResponsibility],
		L32),
	cleanList(L32, highSelfResponsibility,
		[equalResponsibility,
			lowOtherResponsibility, highOtherResponsibility],
		L33),
	
	CleanAppraisals = L33.

%%%%%%%%%%%%%%%%%%%%%%%%
widenState(State, NewState) :-
%	write('widening...'), write(State), write('\n'),
	(append(_Stuff, [HP,HA,HCo,HCe,HR,HE,LP,LA,LCo,LCe,LR,LE], State) ->
	(
		widenDimUp(HP, HP1), append(State, [HP1], S1),
		widenDimUp(HA, HA1), append(S1,[HA1],S2),
		widenDimUp(HCo, HCo1), append(S2,[HCo1],S3),
		widenDimUp(HCe, HCe1), append(S3,[HCe1],S4),
		widenDimUp(HR, HR1), append(S4,[HR1],S5),
		widenDimUp(HE, HE1), append(S5,[HE1],S6),

		%write([HP1, HA1, HCo1, HCe1, HR1, HE1]), write('\n'),

		widenDimDown(LP, LP1), append(S6,[LP1],S7),
		widenDimDown(LA, LA1), append(S7,[LA1],S8),
		widenDimDown(LCo, LCo1), append(S8,[LCo1],S9),
		widenDimDown(LCe, LCe1), append(S9,[LCe1],S10),
		widenDimDown(LR, LR1), append(S10,[LR1],S11),
		widenDimDown(LE, LE1), append(S11,[LE1],S12)
	) ; (
		[P, A, Co, Ce, R, E] = State,
		increaseDim(P, P1), append(State, [P1], S1),
		increaseDim(A, A1), append(S1,[A1],S2),
		increaseDim(Co, Co1), append(S2,[Co1],S3),
		increaseDim(Ce, Ce1), append(S3,[Ce1],S4),
		increaseDim(R, R1), append(S4,[R1],S5),
		increaseDim(E, E1), append(S5,[E1],S6),

		%write([HP1, HA1, HCo1, HCe1, HR1, HE1]), write('\n'),

		decreaseDim(P, P2), append(S6,[P2],S7),
		decreaseDim(A, A2), append(S7,[A2],S8),
		decreaseDim(Co, Co2), append(S8,[Co2],S9),
		decreaseDim(Ce, Ce2), append(S9,[Ce2],S10),
		decreaseDim(R, R2), append(S10,[R2],S11),
		decreaseDim(E, E2), append(S11,[E2],S12)
	)),
	
	%write([LP1, LA1, LCo1, LCe1, LR1, LE1]), write('\n'),

	NewState = S12.

% increase & decrease

% let's increase by a number; this'll have to be recursive
increaseBy(State, Dimension, 1, NewState) :-
	increase(State, Dimension, NewState), ! .
increaseBy(State, Dimension, Number, NewState) :-
	increase(State, Dimension, IntState),
	NewNumber is Number-1,
	increaseBy(IntState, Dimension, NewNumber, NewState).

% same goes for decrease:
decreaseBy(State, Dimension, 1, NewState) :-
	decrease(State, Dimension, NewState), ! .
decreaseBy(State, Dimension, Number, NewState) :-
	decrease(State, Dimension, IntState),
	NewNumber is Number-1,
	decreaseBy(IntState, Dimension, NewNumber, NewState).

% increase, x6 dimensions
increase([P,A,Co,Ce,R,E], pleasantness, [P2,A,Co,Ce,R,E]) :- increaseDim(P, P2).
increase([P,A,Co,Ce,R,E], attentionalActivity, [P,A2,Co,Ce,R,E]) :-
	increaseDim(A, A2).
increase([P,A,Co,Ce,R,E], control, [P,A,Co2,Ce,R,E]) :- increaseDim(Co, Co2).
increase([P,A,Co,Ce,R,E], certainty, [P,A,Co,Ce2,R,E]) :- increaseDim(Ce, Ce2).
increase([P,A,Co,Ce,R,E], responsibility, [P,A,Co,Ce,R2,E]) :- 
	increaseDim(R, R2).
increase([P,A,Co,Ce,R,E], anticipatedEffort, [P,A,Co,Ce,R,E2]) :- 
	increaseDim(E, E2).

% decrease, x6 dimensions
decrease([P,A,Co,Ce,R,E], pleasantness, [P2,A,Co,Ce,R,E]) :- decreaseDim(P, P2).
decrease([P,A,Co,Ce,R,E], attentionalActivity, [P,A2,Co,Ce,R,E]) :-
	decreaseDim(A, A2).
decrease([P,A,Co,Ce,R,E], control, [P,A,Co2,Ce,R,E]) :- decreaseDim(Co, Co2).
decrease([P,A,Co,Ce,R,E], certainty, [P,A,Co,Ce2,R,E]) :- decreaseDim(Ce, Ce2).
decrease([P,A,Co,Ce,R,E], responsibility, [P,A,Co,Ce,R2,E]) :- 
	decreaseDim(R, R2).
decrease([P,A,Co,Ce,R,E], anticipatedEffort, [P,A,Co,Ce,R,E2]) :- 
	decreaseDim(E, E2).

% you can increase by either increasing the positive dimension...
increaseDim(Dimension, NewDimension) :-
	increaseDim1(Dimension, NewDimension);
% ... or by increasing the negative dimension
	increaseDim0(Dimension, NewDimension).

% you can decrease by doing the reverse of an increaseDim
decreaseDim(Dimension, NewDimension) :-
	decreaseDim1(Dimension, NewDimension);
	decreaseDim0(Dimension, NewDimension).

% and widening is simply a convolution of these
widenDimUp(Dimension, NewDimension) :-
	(increaseDim1(Dimension, NewDimension);
	decreaseDim0(Dimension, NewDimension)), !.
widenDimDown(Dimension, NewDimension) :-
	(decreaseDim1(Dimension, NewDimension);
	increaseDim0(Dimension, NewDimension)), !.
% and some center "bottom out" options
widenDimDown(mediumPleasantness, mediumPleasantness).
widenDimDown(neutralAttentionalActivity, neutralAttentionalActivity).
widenDimDown(equalControl, equalControl).
widenDimDown(mediumCertainty, mediumCertainty).
widenDimDown(equalResponsibility, equalResponsibility).
widenDimDown(mediumAnticipatedEffort, mediumAnticipatedEffort).

increaseDim0(Dimension, NewDimension) :- higherDim0(Dimension, NewDimension).
increaseDim1(Dimension, NewDimension) :- higherDim1(Dimension, NewDimension).
% if you hit the highest option, gotta stay there (rather than fail)
increaseDim1(veryHighPleasantness, veryHighPleasantness).
increaseDim1(highAttractiveAttentionalActivity, highAttractiveAttentionalActivity).
increaseDim1(highSituationalControl, highSituationalControl).
increaseDim1(veryHighCertainty, veryHighCertainty).
increaseDim1(highSelfResponsibility, highSelfResponsibility).
increaseDim1(veryHighAnticipatedEffort, veryHighAnticipatedEffort).

decreaseDim1(Dimension, NewDimension) :- higherDim1(NewDimension, Dimension).
decreaseDim0(Dimension, NewDimension) :- higherDim0(NewDimension, Dimension).
% if you hit the lowest option, better stay there :)
decreaseDim0(veryLowPleasantness, veryLowPleasantness).
decreaseDim0(veryHighRepulsiveAttentionalActivity, veryHighRepulsiveAttentionalActivity).
decreaseDim0(highPersonalControl, highPersonalControl).
decreaseDim0(extremelyLowCertainty, extremelyLowCertainty).
decreaseDim0(highOtherResponsibility, highOtherResponsibility).
decreaseDim0(extremelyLowAnticipatedEffort, extremelyLowAnticipatedEffort).

% here's the ordinality definitions (what's an increase in what, or what's a
% "higher dimension... ha ha ha...)
higherDim0(veryLowPleasantness, lowPleasantness).
higherDim0(lowPleasantness, mediumPleasantness).

higherDim0(veryHighRepulsiveAttentionalActivity, highRepulsiveAttentionalActivity).
higherDim0(highRepulsiveAttentionalActivity, lowRepulsiveAttentionalActivity).
higherDim0(lowRepulsiveAttentionalActivity, neutralAttentionalActivity).

higherDim0(highPersonalControl, lowPersonalControl).
higherDim0(lowPersonalControl, equalControl).

higherDim0(extremelyLowCertainty, veryLowCertainty).
higherDim0(veryLowCertainty, lowCertainty).
higherDim0(lowCertainty, mediumCertainty).

higherDim0(highOtherResponsibility, lowOtherResponsibility).
higherDim0(lowOtherResponsibility, equalResponsibility).

higherDim0(extremelyLowAnticipatedEffort, veryLowAnticipatedEffort).
higherDim0(veryLowAnticipatedEffort, lowAnticipatedEffort).
higherDim0(lowAnticipatedEffort, mediumAnticipatedEffort).

higherDim1(neutralAttentionalActivity, lowAttractiveAttentionalActivity).
higherDim1(lowAttractiveAttentionalActivity, highAttractiveAttentionalActivity).

higherDim1(equalControl, lowSituationalControl).
higherDim1(lowSituationalControl, highSituationalControl).

higherDim1(mediumCertainty, highCertainty).
higherDim1(highCertainty, veryHighCertainty).

higherDim1(equalResponsibility, lowSelfResponsibility).
higherDim1(lowSelfResponsibility, highSelfResponsibility).

higherDim1(mediumAnticipatedEffort, highAnticipatedEffort).
higherDim1(highAnticipatedEffort, veryHighAnticipatedEffort).

higherDim1(mediumPleasantness, highPleasantness).
higherDim1(highPleasantness, veryHighPleasantness).
% end of ordinality! (phew)
