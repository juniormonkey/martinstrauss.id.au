:- use_module(biofeedback).
:- use_module(dialogue-in).
:- use_module(dialogue-out).
:- use_module(mood-personality).
:- use_module(referee).
%:- use_module(responses).		% don't need it
:- use_module(roseman).
:- use_module(smithellsworth).

loop(Mood, Inputfile, Outputfile) :-
	% get user's "stimulus" and user's emotion
	input(BEmotion, Stimulus, Inputfile, Outputfile),
	(
		appraise(Stimulus, RAppraisals, SEAppraisals), % appraise the stimulus
		cognitiverate(Mood, RAppraisals, SEAppraisals, BEmotion,
			NewMood, _Emotions),		% do all the hard work
		%debug(Emotions, NewMood),
		outputMood(NewMood, Outputfile),						% output the mood
		outputResponse(NewMood, Stimulus, Outputfile),	% output the response
		loop(NewMood, Inputfile, Outputfile);				% do it all again
		%	'y' is the exit char, so don't do it all again, just output mood
		y = Stimulus -> outputMood(Mood, Outputfile);
		%	this catches the case when the earlier steps fail.
		outputMood(Mood, Outputfile),
		loop(Mood, Inputfile, Outputfile)
	).
	
% debug - write the current emotion and mood to the output
debug(Emotions, NewMood) :-
	write('(Emotion: '), write(Emotions), write(')'), nl,
	whatMood(NewMood, ThisMood, Intensity),
	write('(Mood: '), write(ThisMood), write(', '), write(Intensity), 
	write(')'), nl, nl.

% input - read the biofeedback and stimulus from Inputfile;
%			BEmotion is the user's emotion, Stimulus is the stimulus
input(BEmotion, Stimulus, Inputfile, Outputfile) :-
	getBiofeedback([GSR, BVP, EMG, Respiration], Inputfile, Outputfile),
	bioFindEmotion([GSR, BVP, EMG, Respiration], Emotions),
	writeOptions(Emotions, Outputfile),
	bioFindEmotion([GSR, BVP, EMG, Respiration], BEmotion),
	outputBEmotions(BEmotion, Outputfile),
	getStimulus(Stimulus, Inputfile, Outputfile).
	%read(Stimulus).
	
% outputMood - determine the mood name from the mood vector Mood and
%					write it to Outputfile
outputMood(Mood, Outputfile) :-
	open(Outputfile, write, Output, [buffer(false)]),
	whatMood(Mood, ThisMood, Intensity),
	write(Output, 'Mood: '), write(Output, ThisMood), 
	write(Output, ', '), write(Output, Intensity), nl(Output),
	write(user_error, 'Mood: '), write(user_error, ThisMood),
	write(user_error, ', '), write(user_error, Intensity), nl(user_error),
	write(Output, 'MoodVector: '), write(Output, Mood), nl(Output),
	write(user_error, 'MoodVector: '), write(user_error, Mood), nl(user_error),
	close(Output).

% outputBEmotions - write the user's emotion (in BEmotions) to Outputfile
outputBEmotions(BEmotions, Outputfile) :-
	open(Outputfile, write, Output, [buffer(false)]),
	write(Output, 'YourMood: '), write(Output, BEmotions), nl(Output),
	write(user_error, 'YourMood: '), write(user_error, BEmotions),
		nl(user_error),
	close(Output).

% outputResponse - generate a response from Mood and Stimulus, and 
%						write it to Outputfile
outputResponse(Mood, Stimulus, Outputfile) :-
	response(Mood, Stimulus, Response),
	open(Outputfile, write, Output, [buffer(false)]),
	write(Output, '"'), write(Output, Response), write(Output, '"'),
	nl(Output), nl(Output),
	write(user_error, '"'), write(user_error, Response), write(user_error, '"'),
	nl(user_error), nl(user_error),
	close(Output).

% getBiofeedback - prompts for the biofeedback to Outputfile, then reads
%						biofeedback from Inputfile (into Feedback).
getBiofeedback(Feedback, Inputfile, Outputfile) :- 
	open(Outputfile, write, Output, [buffer(false)]),
	write(Output, 'Biofeedback: '), nl(Output),
	write(user_error, 'Biofeedback: '), nl(user_error),
	close(Output),
	open(Inputfile, read, Input),
	read(Input, Feedback), close(Input),
	write(user_error, Feedback), nl(user_error).
	%read(Feedback).

% writeOptions - finds all the valid stimulus options consistent with the
%						emotions in Emotions, and writes them to Outputfile

% NOTE: there is no checking that the option you select is actually one of the
% options presented to you.  If you know what the options are, you can cheat.
% But cheating's no fun.
writeOptions(Emotions, Outputfile) :-
	options([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		Emotions, Stimuli),
	open(Outputfile, write, Output, [buffer(false)]),
	write(Output, 'Options: '), write(Output, Stimuli), nl(Output),
	close(Output),
	write(user_error, 'Options: '), write(user_error, Stimuli), nl(user_error).

% getStimulus - prompts for the stimulus to Outputfile, then reads the user's
%					selection from Inputfile into Stimulus
getStimulus(Stimulus, Inputfile, Outputfile) :-
	open(Outputfile, write, Output, [buffer(false)]),
	write(Output, 'Stimulus: '), nl(Output),
	close(Output),
	write(user_error, 'Stimulus: '), nl(user_error),
	open(Inputfile, read, Input),
	read(Input, TmpStimulus), close(Input),
	(TmpStimulus = 'x' -> getStimulus(Stimulus, Inputfile, Outputfile) ;
	Stimulus = TmpStimulus, write(user_error, Stimulus), nl(user_error)).
