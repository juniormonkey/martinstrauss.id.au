:- module(smithAndEllsworth, [smithEllsworthEmotions/3, smithEllsworthEmotions1/4]).

% this is just to test: the real agent will have moods and some continuity.
smithEllsworthEmotions(Event, NewState, Emotions) :-
	emotionalStateIs([mediumPleasantness, neutralAttentionalActivity, equalControl, mediumCertainty, equalResponsibility, mediumAnticipatedEffort], Event, NewState, Emotions).

smithEllsworthEmotions1(OldState, Event, NewState, Emotions) :-
	emotionalStateIs(OldState, Event, NewState, Emotions).

smithEllsworthState(Event, NewState) :-
	smithEllsworthAppraiseEvents([mediumPleasantness, neutralAttentionalActivity, equalControl, mediumCertainty, equalResponsibility, mediumAnticipatedEffort], Event, NewState).

emotionalStateIs(PriorState, Event, NewState, Emotions) :- 
	smithEllsworthAppraiseEvents(PriorState, Event, NewState),
%	write(NewState), write('\n'),
	( findEmotion(NewState, Emotions, 0), ! ;
%	(	smithEllsworthAppraisal(Emotion, NewState), ! ;
		Emotions = []
	).

findEmotion(State, Emotions, Depth) :-
	setof(Emotion, smithEllsworthAppraisal(Emotion, State), Emotions), ! ;
	Depth is 10, !, fail ;
	widenState(State, NewState), NewDepth is Depth + 1,
%	write('widening... depth is '), write(Depth), write('\n'),
	findEmotion(NewState, Emotions, NewDepth).

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

% SmithEllsworthAppraisal(?Emotion, [SmithEllsworthAppraisals]).
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
	dimensionMember(highPleasantness, AppraisalsList),
	dimensionMember(lowSituationalControl, AppraisalsList).

smithEllsworthAppraisal(fear, AppraisalsList) :-
	dimensionMember(veryHighAnticipatedEffort, AppraisalsList),
%	dimensionMember(neutralAttentionalActivity, AppraisalsList),
%	dimensionMember(lowOtherResponsibility, AppraisalsList),
	dimensionMember(extremelyLowCertainty, AppraisalsList),
	dimensionMember(lowPleasantness, AppraisalsList).%,
%	dimensionMember(highSituationalControl, AppraisalsList).

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
	dimensionMember(lowPleasantness, AppraisalsList),
	dimensionMember(lowSituationalControl, AppraisalsList).

smithEllsworthAppraisal(challenge, AppraisalsList) :-
	dimensionMember(veryHighAnticipatedEffort, AppraisalsList),
	dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList),
%	dimensionMember(lowSelfResponsibility, AppraisalsList),
	dimensionMember(veryHighCertainty, AppraisalsList),
	dimensionMember(highPleasantness, AppraisalsList).%,
%	dimensionMember(equalControl, AppraisalsList).

smithEllsworthAppraisal(interest, AppraisalsList) :-
	dimensionMember(lowAnticipatedEffort, AppraisalsList),
	dimensionMember(highAttractiveAttentionalActivity, AppraisalsList),
%	dimensionMember(equalResponsibility, AppraisalsList),
	dimensionMember(highCertainty, AppraisalsList),
	dimensionMember(veryHighPleasantness, AppraisalsList),
	dimensionMember(lowSituationalControl, AppraisalsList).

smithEllsworthAppraisal(surprise, AppraisalsList) :-
	dimensionMember(extremelyLowAnticipatedEffort, AppraisalsList),
	dimensionMember(lowAttractiveAttentionalActivity, AppraisalsList),
	dimensionMember(highOtherResponsibility, AppraisalsList),
	dimensionMember(extremelyLowCertainty, AppraisalsList).%,
%	dimensionMember(veryHighPleasantness, AppraisalsList).%,
%	dimensionMember(lowPersonalControl, AppraisalsList).

% dimensionMember(+appraisal, +list) 
% true if appraisal is in list
dimensionMember(Appraisal, List) :- member(Appraisal, List).

% smithEllsworthAppraiseEvent(+PriorState, +Event, ?NewState).
smithEllsworthAppraiseEvent(PriorState, killMother, NewState) :-
	decreaseBy(PriorState, pleasantness, 1, IntState1),
	increaseBy(IntState1, attentionalActivity, 1, IntState2),
	increaseBy(IntState2, anticipatedEffort, 4, NewState).
smithEllsworthAppraiseEvent(PriorState, makeMonster, NewState) :-
	decreaseBy(PriorState, pleasantness, 1, IntState1),
	decreaseBy(IntState1, attentionalActivity, 2, IntState2),
	decreaseBy(IntState2, certainty, 2, IntState3),
	increaseBy(IntState3, anticipatedEffort, 3, NewState).
smithEllsworthAppraiseEvent(PriorState, buyAxe, NewState) :-
	increase(PriorState, pleasantness, IntState1),
	increase(IntState1, certainty, IntState2),
	increase(IntState2, attentionalActivity, IntState3),
	increaseBy(IntState3, responsibility, 3, IntState4),
	decreaseBy(IntState4, anticipatedEffort, 3, NewState).
smithEllsworthAppraiseEvent(PriorState, killMonster, NewState) :-
	increase(PriorState, pleasantness, IntState1),
	increase(IntState1, attentionalActivity, IntState2),
	decreaseBy(IntState2, anticipatedEffort, 2, NewState).
smithEllsworthAppraiseEvent(PriorState, i, NewState) :-
	decreaseBy(PriorState, responsibility, 3, IntState1),
	decreaseBy(IntState1, anticipatedEffort, 1, IntState2),
	decreaseBy(IntState2, control, 2, NewState).
smithEllsworthAppraiseEvent(PriorState, they, NewState) :-
	decreaseBy(PriorState, responsibility, 3, IntState1),
	decreaseBy(IntState1, anticipatedEffort, 1, IntState2),
	increaseBy(IntState2, control, 2, NewState).
smithEllsworthAppraiseEvent(PriorState, you, NewState) :-
	increaseBy(PriorState, responsibility, 3, IntState1),
	increaseBy(IntState1, anticipatedEffort, 2, IntState2),
	decreaseBy(IntState2, control, 2, IntState3),
	increaseBy(IntState3, certainty, 2, NewState).
smithEllsworthAppraiseEvent(PriorState, yesYou, NewState) :-
	increaseBy(PriorState, responsibility, 1, IntState1),
	decreaseBy(IntState1, anticipatedEffort, 1, IntState2),
	decreaseBy(IntState2, control, 2, IntState3),
	increaseBy(IntState3, certainty, 2, NewState).
smithEllsworthAppraiseEvent(PriorState, someone, NewState) :-
	decrease(PriorState, responsibility, IntState1),
	increaseBy(IntState1, control, 3, NewState).
smithEllsworthAppraiseEvent(PriorState, youMissedSomeone, NewState) :-
	decreaseBy(PriorState, responsibility, 2, IntState1),
	increaseBy(IntState1, control, 1, NewState).
smithEllsworthAppraiseEvent(PriorState, did, NewState) :-
	decreaseBy(PriorState, anticipatedEffort, 2, IntState1),
	increaseBy(IntState1, certainty, 2, NewState).
smithEllsworthAppraiseEvent(PriorState, will, NewState) :-
	decreaseBy(PriorState, certainty, 2, NewState).
smithEllsworthAppraiseEvent(PriorState, iKnow, NewState) :-
	increase(PriorState, certainty, NewState).
smithEllsworthAppraiseEvent(PriorState, iveHeard, NewState) :-
	decrease(PriorState, certainty, NewState).
smithEllsworthAppraiseEvent(PriorState, didYouKnow, NewState) :-
	decreaseBy(PriorState, certainty, 3, NewState).
smithEllsworthAppraiseEvent(State, hello, State).
smithEllsworthAppraiseEvent(State, goodbye, State).

% smithEllsworthAppraiseEvents(List, NewState)
smithEllsworthAppraiseEvents(PriorState, [Event], NewState) :- 
	smithEllsworthAppraiseEvent(PriorState, Event, NewState), ! .
smithEllsworthAppraiseEvents(PriorState, [Event|EventList], NewState) :-
	smithEllsworthAppraiseEvent(PriorState, Event, IntermediateState),
	smithEllsworthAppraiseEvents(IntermediateState, EventList, NewState).
smithEllsworthAppraiseEvents(State, [], State).

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
