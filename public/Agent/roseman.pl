:- module(roseman, [rosemanEmotions/2, rosemanAppraisals/2]).

% this is just to test: the real agent will have moods and some continuity.
rosemanEmotions(Event, Emotions) :-
   bagof(
   	Emotion,
   	rosemanEmotion(Event, Emotion),
   	Emotions).
rosemanEmotion(Event, Emotion) :- 
   rosemanAppraiseEvents(Event, RosemanAppraisals),
   rosemanRemoveConflicts(RosemanAppraisals, CleanAppraisals),
   rosemanAppraisal(Emotion, CleanAppraisals).

% this is used by the other agent.  Given a list of appraisals, produces an
% emotion.
rosemanAppraisals(AppraisalsList, Emotions) :-
	rosemanRemoveConflicts(AppraisalsList, CleanAppraisals),
	bagof(
		Emotion,
		rosemanAppraisal(Emotion, CleanAppraisals),
		Emotions).

% RosemanAppraisal(?Emotion, [RosemanAppraisals]).
rosemanAppraisal(none, []) :- !.

rosemanAppraisal(liking, AppraisalsList) :-
   appraisalMember(otherCaused, AppraisalsList),
   appraisalMember(motiveConsistent, AppraisalsList). 

rosemanAppraisal(pride, AppraisalsList) :-
   appraisalMember(selfCaused, AppraisalsList),
   appraisalMember(motiveConsistent, AppraisalsList).

rosemanAppraisal(joy, AppraisalsList) :-
   appraisalMember(circumstanceCaused, AppraisalsList),
   appraisalMember(motiveConsistent, AppraisalsList),
   appraisalMember(appetitive, AppraisalsList),
   appraisalMember(certain, AppraisalsList).

rosemanAppraisal(relief, AppraisalsList) :-
   appraisalMember(circumstanceCaused, AppraisalsList),
   appraisalMember(motiveConsistent, AppraisalsList),
   appraisalMember(aversive, AppraisalsList),
   appraisalMember(certain, AppraisalsList).

rosemanAppraisal(hope, AppraisalsList) :-
   appraisalMember(circumstanceCaused, AppraisalsList),
   appraisalMember(motiveConsistent, AppraisalsList),
   appraisalMember(uncertain, AppraisalsList).

rosemanAppraisal(fear, AppraisalsList) :-
   appraisalMember(circumstanceCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(lowControlPotential, AppraisalsList),
   appraisalMember(uncertain, AppraisalsList).

rosemanAppraisal(sadness, AppraisalsList) :-
   appraisalMember(circumstanceCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(appetitive, AppraisalsList),
   appraisalMember(lowControlPotential, AppraisalsList),
   appraisalMember(certain, AppraisalsList).

rosemanAppraisal(distress, AppraisalsList) :-
   appraisalMember(circumstanceCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(aversive, AppraisalsList),
   appraisalMember(lowControlPotential, AppraisalsList),
   appraisalMember(certain, AppraisalsList).

rosemanAppraisal(frustration, AppraisalsList) :-
   appraisalMember(circumstanceCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(highControlPotential, AppraisalsList),
   appraisalMember(nonCharacterological, AppraisalsList).

rosemanAppraisal(disgust, AppraisalsList) :-
   appraisalMember(circumstanceCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(highControlPotential, AppraisalsList),
   appraisalMember(characterological, AppraisalsList).

rosemanAppraisal(dislike, AppraisalsList) :-
   appraisalMember(otherCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(lowControlPotential, AppraisalsList).

rosemanAppraisal(anger, AppraisalsList) :-
   appraisalMember(otherCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(highControlPotential, AppraisalsList),
   appraisalMember(nonCharacterological, AppraisalsList).

rosemanAppraisal(contempt, AppraisalsList) :-
   appraisalMember(otherCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(highControlPotential, AppraisalsList),
   appraisalMember(characterological, AppraisalsList).

rosemanAppraisal(regret, AppraisalsList) :-
   appraisalMember(selfCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(lowControlPotential, AppraisalsList).

rosemanAppraisal(guilt, AppraisalsList) :-
   appraisalMember(selfCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(highControlPotential, AppraisalsList),
   appraisalMember(nonCharacterological, AppraisalsList).

rosemanAppraisal(shame, AppraisalsList) :-
   appraisalMember(selfCaused, AppraisalsList),
   appraisalMember(motiveInconsistent, AppraisalsList),
   appraisalMember(highControlPotential, AppraisalsList),
   appraisalMember(characterological, AppraisalsList).

rosemanAppraisal(surprise, AppraisalList) :-
   appraisalMember(unexpected, AppraisalList).

% appraisalMember(+appraisal, +list) 
% true if appraisal is in list, or if appraisal's opposite is not in list
appraisalMember(motiveConsistent, AppraisalsList) :-
   member(motiveConsistent, AppraisalsList), ! ;
   \+ member(motiveInconsistent, AppraisalsList).
appraisalMember(motiveInconsistent, AppraisalsList) :-
   member(motiveInconsistent, AppraisalsList), ! ;
   \+ member(motiveConsistent, AppraisalsList).

appraisalMember(appetitive, AppraisalsList) :-
   member(appetitive, AppraisalsList), ! ;
   \+ member(aversive, AppraisalsList).
appraisalMember(aversive, AppraisalsList) :-
   member(aversive, AppraisalsList), ! ;
   \+ member(appetitive, AppraisalsList).

appraisalMember(circumstanceCaused, AppraisalsList) :-
   member(circumstanceCaused, AppraisalsList), ! ;
   (\+ member(selfCaused, AppraisalsList),
   \+ member(otherCaused, AppraisalsList)).
appraisalMember(otherCaused, AppraisalsList) :-
   member(otherCaused, AppraisalsList), ! ;
   (\+ member(selfCaused, AppraisalsList),
   \+ member(circumstanceCaused, AppraisalsList)).
appraisalMember(selfCaused, AppraisalsList) :-
   member(selfCaused, AppraisalsList), ! ;
   (\+ member(otherCaused, AppraisalsList),
   \+ member(circumstanceCaused, AppraisalsList)).

appraisalMember(certain, AppraisalsList) :-
   member(certain, AppraisalsList), ! ;
   \+ member(uncertain, AppraisalsList).
appraisalMember(uncertain, AppraisalsList) :-
   member(uncertain, AppraisalsList), ! ;
   \+ member(certain, AppraisalsList).
appraisalMember(unexpected, AppraisalsList) :-
   member(unexpected, AppraisalsList).

appraisalMember(lowControlPotential, AppraisalsList) :-
   member(lowControlPotential, AppraisalsList), ! ;
   \+ member(highControlPotential, AppraisalsList).
appraisalMember(highControlPotential, AppraisalsList) :-
   member(highControlPotential, AppraisalsList), ! ;
   \+ member(lowControlPotential, AppraisalsList).

appraisalMember(characterological, AppraisalsList) :-
   member(characterological, AppraisalsList), ! ;
   \+ member(nonCharacterological, AppraisalsList).
appraisalMember(nonCharacterological, AppraisalsList) :-
   member(nonCharacterological, AppraisalsList), ! ;
   \+ member(characterological, AppraisalsList).

% rosemanAppraisEvent(+Event, ?Appraisals) 
%   Appraisals is the list of appraisals of Event
rosemanAppraiseEvent(killMother, [motiveInconsistent, appetitive]).
rosemanAppraiseEvent(makeMonster, [motiveInconsistent, aversive]).
rosemanAppraiseEvent(buyAxe, [motiveConsistent, appetitive]).
rosemanAppraiseEvent(killMonster, [motiveConsistent, aversive]).
rosemanAppraiseEvent(i, [otherCaused, highControlPotential]).
rosemanAppraiseEvent(they, [otherCaused, lowControlPotential]).
rosemanAppraiseEvent(you, [selfCaused, highControlPotential]).
rosemanAppraiseEvent(yesYou, [selfCaused, lowControlPotential]).
rosemanAppraiseEvent(someone, [circumstanceCaused, lowControlPotential]).
rosemanAppraiseEvent(youMissedSomeone,
										[circumstanceCaused, highControlPotential]).
rosemanAppraiseEvent(did, [certain]).
rosemanAppraiseEvent(will, [unCertain]).
rosemanAppraiseEvent(iKnow, [certain]).
rosemanAppraiseEvent(iveHeard, [uncertain]).
rosemanAppraiseEvent(didYouKnow, [unexpected]).
rosemanAppraiseEvent(typical, [characterological]).
rosemanAppraiseEvent(whodaThunkIt, [nonCharacterological]).

rosemanAppraiseEvent(hello, []).
rosemanAppraiseEvent(goodbye, []).

% rosemanAppraiseEvents(+List, ?Appraisals) 
%   Appraisals is the list of appraisals of the list of events in List
rosemanAppraiseEvents(List, Appraisals) :-
   rosemanAppraiseEvents1(List, Appraisals, []).

rosemanAppraiseEvents1([Event], Appraisals, List) :- 
   rosemanAppraiseEvent(Event, Appraisals1),
   append(Appraisals1, List, Appraisals).
rosemanAppraiseEvents1([Event|EventList], Appraisals, List) :-
   rosemanAppraiseEvent(Event, Appraisals1),
   append(Appraisals1, List, List1),
   rosemanAppraiseEvents1(EventList, Appraisals2, List),
   append(Appraisals2, List1, Appraisals).

rosemanRemoveConflicts(AppraisalsList, CleanAppraisals) :-
   ((member(motiveConsistent, AppraisalsList),
   member(motiveInconsistent, AppraisalsList)) ->
   	(delete(AppraisalsList, motiveConsistent, AppraisalsList1),
   	delete(AppraisalsList1, motiveInconsistent, AppraisalsList2))
   ;
   	(AppraisalsList2 = AppraisalsList)
   ),
   ((member(appetitive, AppraisalsList2),
   member(aversive, AppraisalsList2)) ->
   	(delete(AppraisalsList2, appetitive, AppraisalsList3),
   	delete(AppraisalsList3, aversive, AppraisalsList4))
   ;
   	(AppraisalsList4 = AppraisalsList2)
   ),
   ((member(circumstanceCaused, AppraisalsList4),
   member(selfCaused, AppraisalsList4),
   member(otherCaused, AppraisalsList4)) ->
   	(delete(AppraisalsList4, appetitive, AppraisalsList5),
   	delete(AppraisalsList5, aversive, AppraisalsList6))
   ;
   	(AppraisalsList6 = AppraisalsList4)
   ),
   ((member(certain, AppraisalsList6),
   member(uncertain, AppraisalsList6)) ->
   	(delete(AppraisalsList6, appetitive, AppraisalsList7),
   	delete(AppraisalsList7, aversive, AppraisalsList8))
   ;
   	(AppraisalsList8 = AppraisalsList6)
   ),
   ((member(lowControlPotential, AppraisalsList8),
   member(highControlPotential, AppraisalsList8)) ->
   	(delete(AppraisalsList8, appetitive, AppraisalsList9),
   	delete(AppraisalsList9, aversive, AppraisalsList10))
   ;
   	(AppraisalsList10 = AppraisalsList8)
   ),
   ((member(characterological, AppraisalsList10),
   member(nonCharacterological, AppraisalsList10)) ->
   	(delete(AppraisalsList10, appetitive, AppraisalsList11),
   	delete(AppraisalsList11, aversive, AppraisalsList12))
   ;
   	(AppraisalsList12 = AppraisalsList10)
   ),
   CleanAppraisals = AppraisalsList12.
