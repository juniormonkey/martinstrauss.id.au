:- module(biofeedback, [bioFindEmotion/2]).

% bioFindEmotion(+[GSR, BVP, EMG, Respiration], ?[Emotion])
% bioFindEmotion(+[GSR, BVP], ?[Emotion])
% returns the emotions implied by a 4-tuple or 2-tuple of biofeedback.
bioFindEmotion(Feedback, Emotions) :-
	setof(Emotion,
		bioFindEmotions(Feedback, Emotion),
		Emotions).

bioFindEmotions(Feedback, Emotion) :-
	interpretFeedback(Feedback, Characteristics),
	twoDEmotion(Characteristics, Emotion).

% interpretFeedback(+[GSR, BVP, EMG, Respiration], ?[Valence, Arousal])
% returns the valence and intensity implied by a 4-tuple of biofeedback
interpretFeedback([high, high, high, high], [highNegative, veryHigh]).
interpretFeedback([high, high, high, low], [highNegative, high]).
interpretFeedback([high, high, low, high], [lowNegative, veryHigh]).
interpretFeedback([high, high, low, low], [lowNegative, high]).
interpretFeedback([high, low, high, high], [lowPositive, veryHigh]).
interpretFeedback([high, low, high, low], [lowPositive, high]).
interpretFeedback([high, low, low, high], [highPositive, veryHigh]).
interpretFeedback([high, low, low, low], [highPositive, high]).
interpretFeedback([low, high, high, high], [highNegative, low]).
interpretFeedback([low, high, high, low], [highNegative, veryLow]).
interpretFeedback([low, high, low, high], [lowNegative, low]).
interpretFeedback([low, high, low, low], [lowNegative, veryLow]).
interpretFeedback([low, low, high, high], [lowPositive, low]).
interpretFeedback([low, low, high, low], [lowPositive, veryLow]).
interpretFeedback([low, low, low, high], [highPositive, low]).
interpretFeedback([low, low, low, low], [highPositive, veryLow]).

% interpretFeedback(+[GSR, BVP], ?[Valence, Arousal])
% returns the valence and intensity implied by a 2-tuple of biofeedback
interpretFeedback([high, high], [highNegative, veryHigh]).
interpretFeedback([high, high], [lowNegative, veryHigh]).
interpretFeedback([high, high], [highNegative, high]).
interpretFeedback([high, high], [lowNegative, high]).
interpretFeedback([high, low], [highNegative, veryLow]).
interpretFeedback([high, low], [lowNegative, veryLow]).
interpretFeedback([high, low], [highNegative, low]).
interpretFeedback([high, low], [lowNegative, low]).
interpretFeedback([low, high], [highPositive, veryHigh]).
interpretFeedback([low, high], [lowPositive, veryHigh]).
interpretFeedback([low, high], [highPositive, high]).
interpretFeedback([low, high], [lowPositive, high]).
interpretFeedback([low, low], [highPositive, veryLow]).
interpretFeedback([low, low], [lowPositive, veryLow]).
interpretFeedback([low, low], [highPositive, low]).
interpretFeedback([low, low], [lowPositive, low]).

/*
interpretFeedback([GSR, BVP, EMG, Respiration], [Valence, Arousal]) :-
	(Respiration == low ->
		(BVP == low -> Valence1 = positive ; true),
		(GSR == low -> Arousal1 = low ; true)
	;
	Respiration == high ->
		(BVP == high -> Valence1 = negative ; true),
		(GSR == high -> Arousal1 = high ; true)
	),
	(EMG == low ->
		(BVP == low -> Valence2 = positive ; true),
		(GSR == low -> Arousal2 = low ; true)
	;
	EMG == high ->
		(BVP == high -> Valence2 = negative ; true),
		(GSR == high -> Arousal2 = high ; true)
	),
	(Valence1 == positive, Valence2 == positive -> Valence = highPositive;
	Valence1 == negative, Valence2 == negative -> Valence = highNegative;
	BVP == high -> Valence = lowNegative;
	BVP == low -> Valence = lowPositive),
	(Arousal1 == high, Arousal2 == high -> Arousal = veryHigh;
	Arousal1 == low, Arousal2 == low -> Arousal = veryLow;
	GSR == high -> Arousal = high;
	GSR == low -> Arousal = low).
*/

% twoDEmotion(+[Valence, Arousal], ?Emotion)
% returns the emotion implied by a tuple of valence and intensity
twoDEmotion([highNegative, veryHigh], anger).
twoDEmotion([highNegative, veryLow], boredom).
twoDEmotion([lowPositive, veryHigh], challenge).
twoDEmotion([highNegative, high], contempt).
twoDEmotion([lowNegative, high], dislike).
twoDEmotion([highNegative, high], distress).
twoDEmotion([lowNegative, high], disgust).
twoDEmotion([lowNegative, veryHigh], fear).
twoDEmotion([highNegative, high], frustration).
twoDEmotion([lowNegative, low], guilt).
twoDEmotion([lowPositive, high], hope).
twoDEmotion([highPositive, high], interest).
twoDEmotion([highPositive, veryLow], joy).
twoDEmotion([lowPositive, low], liking).
twoDEmotion([highPositive, low], pride).
twoDEmotion([lowNegative, low], regret).
twoDEmotion([lowPositive, veryLow], relief).
twoDEmotion([highNegative, low], sadness).
twoDEmotion([lowNegative, veryLow], shame).
twoDEmotion([highPositive, veryHigh], surprise).
