:- module(referee, [cognitiverate/6, personalityIs/1]).

:- use_module(smithellsworth).
:- use_module(roseman).
:- use_module(biofeedback).
:- use_module(mood-personality).

% cognitiverate - goes from a prior mood, appraisals and biofeedback emotions
%						to a new mood and emotions
cognitiverate(Mood,
	RosemanAppraisals,
	SmithEllsworthAppraisals,
	BEmotions,
	NewMood,
	Emotions) :-
	smithEllsworthAppraisals(SmithEllsworthAppraisals, SEEmotions),
	rosemanAppraisals(RosemanAppraisals, REmotions),
	personalityIs(Personality),
	generateMood(Mood, Personality, SEEmotions, REmotions, BEmotions, NewMood),
	union(SEEmotions, REmotions, Emotions).

% here we set the agent's personality.
personalityIs([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]).
