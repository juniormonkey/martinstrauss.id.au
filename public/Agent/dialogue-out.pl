:- module(dialogueOutput, [response/3, options/3]).

:- use_module(mood-personality).

% response(+Mood, +Emotion, +Stimulus, -Response)
% calcualtes the correct Agent response to a User stimulus, given the agent's
% affective state
response(Mood, Stimulus, Response) :-
	affectiveResponse(Mood, Response),
	possibleResponse(Stimulus, Response).

% options(+Mood, +Emotions, -Stimuli)
% calculates a set of User stimuli options based on the current affective state
options(Mood, Emotions, Stimuli) :-
	setof(
		Stimulus,
		allOptions(Mood, Emotions, Stimulus),
		Stimuli).

% allOptions(+Mood, +Emotionos, -Stimuli)
% calculates user stimuli based on current affective state
allOptions(Mood, Emotions, Stimulus) :-
	onebyone(Emotions, Emotion),
	affectiveStimulus(Mood, Emotion, Stimulus).

% possibleResponse(+Stimulus, -Response)
% gives the reasonable responses to Stimulus
possibleResponse(Stimulus, Response) :- possibleResponses(Stimulus, Response).

% affectiveStimulus(+Mood, +Emotion, -Stimulus)
% gives the appropriate stimuli, given the affective state.
affectiveStimulus(Mood, Emotion, Stimulus) :-
	availableStimulus(Stimulus),
	(moodResponse(Mood, Stimulus, 4); 
	affectiveResponses(Emotion, Stimulus)).

% affectiveResponse(+Mood, -Response)
% gives all the appropriate Responses in Mood
affectiveResponse(Mood, Response) :-
	moodResponse(Mood, Response, 1).

% moodResponse(+Mood, -Response, ?Num)
% gives all the appropriate Responses in Mood (recursive)
moodResponse(Mood, Response, 1) :-
	whatMood(Mood, ThatMood, _),
	affectiveResponses(ThatMood, Response).

moodResponse(Mood, Response, Num) :-
	Num > 1,
	whatMood(Mood, ThatMood, _),
	(affectiveResponses(ThatMood, Response) ;
	nextMoodMatch(Mood, ThatMood, NextMood),
	Num1 is Num - 1,
	moodResponse(NextMood, Response, Num1)).

% affectiveResponses(+Emotion, -Response)
% gives all the responses appropriate to Emotion
affectiveResponses(Emotion, Response) :-
	affectiveResponsesList(Emotion, ResponsesList),
	onebyone(ResponsesList, Response).

% possibleResponses(+Stimulus, Response)
% gives all the responses appropriate to Stimulus
possibleResponses(Stimulus, Response) :-
	possibleResponsesList(Stimulus, ResponsesList),
	onebyone(ResponsesList, Response).

% availableStimulus(-Stimulus)
% gives all the possible stimuli
availableStimulus(Stimulus) :-
	availableStimulusList(Stimuli),
	onebyone(Stimuli, Stimulus).

% onebyone(+List, -Item)
% returns all the Items in the List one by one
onebyone([First|List], Item) :- 
	Item = First;
	onebyone(List, Item).

% and now the definitions
affectiveResponsesList(anger, [a, d, h, i, k, l, n, p, q, r, s, y,
	ad, fa, ea, hb, ic, jb, kb, lb, nc, pb, sa, qb, tb, uc, vc]).
affectiveResponsesList(boredom, [a, b, d, h, n, p, t, y,
	ad, fa, ea, hb, ib, jb, la, nc, pb, sa, qa, tc, ub, vb]).
affectiveResponsesList(challenge, [a, c, d, g, h, n, p, t, v, y,
	ac, da, ba, fa, ea, ha, ja, lc, na, pa, sa, qb, ta, ub, vb]).
affectiveResponsesList(contempt, [a, c, d, g, h, k, l, n, p, s, y,
	ad, eb, fa, hb, ic, jb, kb, nc, pb, ld, sa, qb, tb, uc, vc]).
affectiveResponsesList(dislike, [a, c, d, g, h, i, k, l, n, p, r, s, y,
	ac, ad, ba, fa, ea, hb, ib, jb, lb, nc, pb, sa, qb, tb, uc, vc]).
affectiveResponsesList(distress, [a, d, h, n, p, q, s, y,
	ad, eb, fa, hb, ib, jb, kb, la, nc, pb, sa, qa, tb, uc, vc]).
affectiveResponsesList(disgust, [a, c, d, h, k, l, n, p, s, y,
	ad, eb, fa, hb, ic, jb, kb, nc, pb, ld, sa, qb, tb, uc, vc]).
affectiveResponsesList(fear, [a, d, h, n, p, q, r, s, y,
	ac, ad, ba, eb, fa, hb, jb, kb, nc, pb, ld, qa, sb, tb, uc, vc]).
affectiveResponsesList(frustration, [a, d, h, i, k, n, p, q, r, s, y,
	ad, eb, fa, hb, jb, kb, lb, nc, pb, sa, qa, tb, uc, vc]).
affectiveResponsesList(guilt, [a, d, h, k, m, n, p, y,
	ad, eb, fa, hb, jb, ka, la, nc, pb, sb, qa, tc, ub, vb]).
affectiveResponsesList(hope, [a, c, d, g, h, n, t, v, y,
	ac, da, fa, ea, ha, ia, ja, kb, lc, nb, pa, sb, qb, tc, ua, vb]).
affectiveResponsesList(interest, [a, c, d, h, n, t, v, y,
	ac, ba, da, fa, ea, ha, ja, lc, nb, pa, sb, qa, ta, ua, va]).
affectiveResponsesList(joy, [a, b, d, f, h, j, n, o, t, u, v, y,
	aa, da, ea, ha, ia, ja, ka, lc, na, pa, sb, qa, tc, ud, va]).
affectiveResponsesList(liking, [b, d, f, h, j, n, t, u, v, y,
	ab, ba, da, ea, ha, ia, ja, ka, lc, nb, pa, sb, qa, ta, ud, va]).
affectiveResponsesList(pride, [b, d, e, f, h, j, n, o, t, u, v, y,
	aa, da, ea, ha, ic, ja, kb, lc, na, pa, sa, qb, ta, ub, va]).
affectiveResponsesList(regret, [a, d, g, h, m, n, p, y,
	ac, ad, ba, eb, fa, hb, jb, ka, la, nc, pb, sb, qa, tc, ub, vb]).
affectiveResponsesList(relief, [a, d, h, n, o, u, v, y,
	ac, ba, da, ea, ha, ia, ja, ka, lc, na, pa, sb, qa, tc, ub, va]).
affectiveResponsesList(sadness, [a, d, g, h, i, k, m, n, p, y,
	ac, ad, ba, eb, fa, hb, ia, ja, la, nc, pb, sb, qa, tc, ub, vb]).
affectiveResponsesList(shame, [a, d, g, h, m, n, p, y,
	ac, ad, ba, eb, fa, hb, jb, ka, la, nc, pb, sb, qa, tc, ub, vb]).
affectiveResponsesList(surprise, [a, d, h, n, p, v, y,
	ab, ba, da, ea, ha, ic, ja, kb, lc, na, pa, sb, qb, ta, tc, ua, va]).

possibleResponsesList(a, [aa, ab, ac, ad]).
possibleResponsesList(b, [aa, ab, ad, ba]).
possibleResponsesList(c, [aa, ac, ad]).
possibleResponsesList(d, [ad, da]).
possibleResponsesList(e, [ea, eb]).
possibleResponsesList(f, [fa, ea]).
possibleResponsesList(g, [fa, ea]).
possibleResponsesList(h, [ha, hb]).
possibleResponsesList(i, [ic, ib, ia, kb, ka]).
possibleResponsesList(j, [ja, jb]).
possibleResponsesList(k, [kb, ka]).
possibleResponsesList(l, [la, lb, lc, ld]).
possibleResponsesList(m, [la, lb, lc, ld]).
possibleResponsesList(n, [na, nb, nc]).
possibleResponsesList(o, [na, nb, nc]).
possibleResponsesList(p, [pa, pb]).
possibleResponsesList(q, [qa, qb]).
possibleResponsesList(r, [la, lb, lc, ld]).
possibleResponsesList(s, [sa, sb]).
possibleResponsesList(t, [ta, tb, tc]).
possibleResponsesList(u, [ua, ub, ld, uc, ud]).
possibleResponsesList(v, [va, vb, vc]).

availableStimulusList([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, y]).

