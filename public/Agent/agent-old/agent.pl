:- use_module(smithellsworth).
:- use_module(roseman).
%:- use_module(biofeedback).  % not written yet! :-P
:- use_module(responses).
:- use_module(mood-personality).

cognitiverate(Mood, Event, NewMood, Emotions) :-
%	smithEllsworthEmotions1(Mood, Event, NewMood, SEEmotions),
	smithEllsworthEmotions(Event, SEEmotions),
%	write('State: '), write(NewState), write('\n'),
%	write('Smith & Ellsworth Emotions: '), write(SEEmotions), write('\n'),
	rosemanEmotions(Event, REmotions),
%	write('Roseman Emotions: '), write(REmotions), write('\n'),
	personalityIs(Personality),
	generateMood(Mood, Personality, SEEmotions, REmotions, NewMood),
%	write('Mood: '), write(NewMood), write('\n'),
	union(SEEmotions, REmotions, Emotions).

respond(Event, Emotions, Mood, FullResponse) :- 
	appropriateResponse(Event, Emotions, Response1),
	moodResponse(Event, Mood, Response2),
	(Response2 = [] -> FullResponse = Response1 ; FullResponse = Response2).

personalityIs([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]).
