:- module(agentResponses, [appropriateResponse/3, moodResponse/3]).

appropriateResponse([], [], ['I\'m speechless! I have nothing to say.']) :- !.
appropriateResponse(Event, Emotions, Response) :-
	appropriateResponseEmotion(Event, Emotions, Response).

moodResponse([], _, ['I\'m speechless! I have nothing to say.']) :- !.
moodResponse(Event, Mood, Response) :-
	findResponse(Event, Mood, Response).

appropriateResponseEmotion(Event, [Em], [Response]) :-
	findResponse(Event, Em, Response), !.

appropriateResponseEmotion(_Event, [], []).

appropriateResponseEmotion(Event, [Em|Rest], Response) :-
	findResponse(Event, Em, ResponseItem),
	appropriateResponseEmotion(Event, Rest, MoreResponses),
	union([ResponseItem], MoreResponses, Response).

findResponse(Event, joy, Response) :- 
	includes(Event, buyAxe) -> Response = 'I\'m pleased to be of service.';
	includes(Event, killMonster) -> Response = 'I\'m glad to be rid of him!';
	Response = 'Hooray!'.
findResponse(Event, sadness, Response) :- 
	includes(Event, killMother) -> Response =
											'Pity, she was the only mother I ever had.';
	includes(Event, makeMonster) -> Response =
								'Oh no, just when we\'d gotten rid of the old one?';
	Response = 'Oh poo.'.
findResponse(_Event, anger, Response) :- Response = 'Get out of my shop!!!'.
findResponse(_Event, boredom, Response) :- Response = 'Yawn...'.
findResponse(_Event, challenge, Response) :- Response = 'Oh? Now there\'s a challenge.'.
findResponse(_Event, hope, Response) :- Response = 'Here\'s hoping...'.
findResponse(_Event, fear, Response) :- Response = 'Oh no...'.
findResponse(_Event, interest, Response) :- Response = 'Oh really?'.
findResponse(_Event, contempt, Response) :- Response = 'You would too.'.
findResponse(_Event, disgust, Response) :- Response = 'Yech!'.
findResponse(_Event, frustration, Response) :- Response = 'Gnngh!'.
findResponse(_Event, surprise, Response) :- Response = 'Oh!'.
findResponse(Event, pride, Response) :-
	includes(Event, sellAxe) -> Response =
			'I\'m particularly proud of that axe.  One of the best I ever made.';
	includes(Event, killMonster) -> Response =
					'I wouldn\'t have thought myself capable of it, but, well...';
	Response = 'Hehe...'.
findResponse(_Event, shame, Response) :- Response = '(cringe)'.
findResponse(_Event, guilt, Response) :- Response =
											'It\'s true.  But I\'m not proud of it!'.
findResponse(Event, liking, Response) :- 
	includes(Event, hello) -> Response = 'Welcome, friend!', !;
	includes(Event, goodbye) -> Response = 'Call again soon!', !;
	Response = 'Anything for a friend!', !.
findResponse(Event, dislike, Response) :- 
	includes(Event, hello) -> Response = 'You again?', !;
	includes(Event, goodbye) -> Response = 'And good riddance.', !;
	Response = '', !.
findResponse(_Event, regret, Response) :- Response = 'If only...'.
findResponse(_Event, relief, Response) :- Response = 'Phew!'.
findResponse(_Event, distress, Response) :- Response = 'errrr...?'.
findResponse([hello], _Emotion, 'Welcome, stranger!').
findResponse([goodbye], _Emotion, 'Fare thee well!').

includes(Event, Item) :- member(Item, Event).
