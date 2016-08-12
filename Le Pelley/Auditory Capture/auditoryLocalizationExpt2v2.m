
clear all

% Screen('Preference', 'SkipSyncTests', 2 );      % Skips the Psychtoolbox calibrations - REMOVE THIS WHEN RUNNING FOR REAL!


Screen('CloseAll');

commandwindow;

clc;

functionFoldername = fullfile(pwd, 'functions');    % Generate file path for "functions" folder in current working directory
addpath(genpath(functionFoldername));       % Then add path to this folder and all subfolders


global MainWindow screenNum
global numAudioChannels
global scr_centre DATA datafilename
global centOrCents
global screenRes
global cueToneArray cueToneArrayLength toneFreq
global noiseArray noiseArrayLength
global cueToneHighestVolume lowestTargetVolume highestTargetVolume
global white black yellow gray
global bigMultiplier smallMultiplier lossAmount
global exptSession
global starting_total
global topKeyName bottomKeyName
global exptCondition


exptName = 'audioLocExp2_';

screenNum = 0;

% InitializePsychSound;
InitializePsychSound(1);
numAudioChannels = 8;
toneChannels = [6, 5];
noiseChannels = [3, 1, 4, 2];   % Top-left, top-right, bottom-left, bottom-right



% screenNum = 1;
% 
% % InitializePsychSound;
% InitializePsychSound;
% numAudioChannels = 2;
% toneChannels = [1,2];
% noiseChannels = [1, 2, 1, 2];   % Top-left, top-right, bottom-left, bottom-right
% 



bigMultiplier = 50;    % Points multiplier for trials with high-value distractor
smallMultiplier = 1;   % Points multiplier for trials with low-value distractor
lossAmount = 1;        % Points loss for errors

topKeyName = 't';
bottomKeyName = 'b';



if smallMultiplier == 1
    centOrCents = 'point';
else
    centOrCents = 'points';
end


cueToneHighestVolume = 1;
rightSpeakerVolumeMultiple = 1;   % 0.85 The right speaker is louder than the left one, so reduce volume of all sounds from this speaker
higherToneVolumeMultiple = 0.8;     % The medium and high tones are louder than the low one, so reduce their volume

lowestTargetVolume = 0.7;   % Program will choose a random number between these limits each time
highestTargetVolume = 0.9;



starting_total = 0;


if exist('ExptData', 'dir') == 0
    mkdir('ExptData');
end

exptSession = 1;


% p_number = 1;
% colBalance = 1;
% p_age = 123;
% p_sex = 'm';
% p_hand = 'r';
% datafilename = ['ExptData\audioLocE2P', num2str(p_number), '_S'];

inputError = 1;

while inputError == 1
    inputError = 0;
    
    p_number = input('Participant number  ---> ');
    
    datafilename = ['ExptData\', exptName, 'P', num2str(p_number), '_S'];
    
    if exist([datafilename, num2str(exptSession), '.mat'], 'file') == 2
        disp(['Session ', num2str(exptSession), ' data for participant ', num2str(p_number),' already exist'])
        inputError = 1;
    end
    
    if exptSession > 1
        if exist([datafilename, num2str(exptSession - 1), '.mat'], 'file') == 0
            disp(['No session ', num2str(exptSession - 1), ' data for participant ', num2str(p_number)])
            inputError = 1;
        end
        if exist([datafilename, num2str(1), '.mat'], 'file') == 0
            disp(['No session ', num2str(1), ' data for participant ', num2str(p_number)])
            inputError = 1;
        end
    end
    
end




if exptSession == 1
    
    exptCondition = 0;
    while exptCondition < 1 || exptCondition > 3
        exptCondition = input('V/IV condition (1-3)---> ');     % 1 = 100% invalid, 2 = 80% invalid, 3 = 50% invalid
        if isempty(exptCondition); exptCondition = 0; end
    end

    colBalance = 0;
    while colBalance < 1 || colBalance > 2
        colBalance = input('Counterbalance (1-2)---> ');
        if isempty(colBalance); colBalance = 0; end
    end
    
    p_age = input('Participant age ---> ');
    p_sex = 'a';
    while p_sex ~= 'm' && p_sex ~= 'f' && p_sex ~= 'M' && p_sex ~= 'F'
        p_sex = input('Participant gender (M/F) ---> ', 's');
        if isempty(p_sex); p_sex = 'a'; end
    end
    
    p_hand = 'a';
    while p_hand ~= 'r' && p_hand ~= 'l' && p_hand ~= 'R' && p_hand ~= 'L'
        p_hand = input('Participant hand (R/L) ---> ','s');
        if isempty(p_hand); p_hand = 'a'; end
    end
    
else
    
    load([datafilename, num2str(exptSession - 1), '.mat'])
    colBalance = DATA.counterbal;
    p_age = DATA.age;
    p_sex = DATA.sex;
    p_hand = DATA.hand;
    if isfield(DATA, 'totalBonus')
        starting_total = DATA.totalBonus;
    else
        starting_total = 0;
    end
        
    disp (['Age:  ', num2str(p_age)])
    disp (['Sex:  ', p_sex])
    disp (['Hand:  ', p_hand])
    disp (['Counterbalance:  ', num2str(colBalance)])
    
    y_to_continue = 'a';
    while y_to_continue ~= 'y' && y_to_continue ~= 'Y'
        y_to_continue = input('Is this OK? (y = continue, n = quit) --> ','s');
        if y_to_continue == 'n'
            Screen('CloseAll');
            clear all;
            error('Quitting program');
        end
        
        if isempty(y_to_continue); y_to_continue = 'a'; end
        
    end
    
end

DATA.subject = p_number;
DATA.exptCondition = exptCondition;
DATA.session = exptSession;
DATA.counterbal = colBalance;
DATA.age = p_age;
DATA.sex = p_sex;
DATA.hand = p_hand;
DATA.start_time = datestr(now,0);


DATA.session_Bonus = 0;
DATA.session_Points = 0;
DATA.actualBonusSession = 0;
DATA.totalBonus = 0;

datafilename = [datafilename, num2str(exptSession),'.mat'];


% *******************************************************


KbName('UnifyKeyNames');    % Important for some reason to standardise keyboard input across platforms / OSs.

% now set colors
white = [255 255 255];
black = [0 0 0];
yellow = [255 255 0];
gray = [40, 40, 40];

% generate a random seed using the clock, then use it to seed the random
% number generator
rng('shuffle');
randSeed = randi(30000);
DATA.rSeed = randSeed;
rng(randSeed);

% Get screen resolution, and find location of centre of screen
[scrWidth, scrHeight] = Screen('WindowSize',screenNum);
screenRes = [scrWidth scrHeight];
scr_centre = screenRes / 2;

MainWindow = Screen('OpenWindow', screenNum, black);
Screen('Preference', 'DefaultFontName', 'Courier New');
Screen('TextFont', MainWindow, 'Courier New');
Screen('TextSize', MainWindow, 46);
Screen('TextStyle', MainWindow, 1);

HideCursor;
DATA.frameRate = round(Screen(MainWindow, 'FrameRate'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% GENERATE CUE TONES %
%%%%%%%%%%%%%%%%%%%%%%

[tempToneArrayLow, toneFreq] = audioread('monoToneL.wav');     % read in low tone
[tempToneArrayMid, toneFreq] = audioread('monoToneM.wav');     % read in medium tone
[tempToneArrayHigh, toneFreq] = audioread('monoToneH.wav');     % read in high tone

toneArrayLengthLow = length(tempToneArrayLow);
toneArrayLengthMid = length(tempToneArrayMid);
toneArrayLengthHigh = length(tempToneArrayHigh);

cueToneArrayLength = max([toneArrayLengthLow, toneArrayLengthMid, toneArrayLengthHigh]);     % Find length of longest tone (in case they are not precisely the same length)

% Create equal length arrays for the three tones, and then pad the shorter
% tones with leading zeros so that the tone - target delay is identical for
% all tones
toneArrayLow = zeros(cueToneArrayLength, 1);
toneArrayMid = zeros(cueToneArrayLength, 1);
toneArrayHigh = zeros(cueToneArrayLength, 1);

toneLowLeadingZeros = cueToneArrayLength - toneArrayLengthLow;
toneMidLeadingZeros = cueToneArrayLength - toneArrayLengthMid;
toneHighLeadingZeros = cueToneArrayLength - toneArrayLengthHigh;

toneArrayLow(toneLowLeadingZeros + 1 : cueToneArrayLength) = tempToneArrayLow(:);
toneArrayMid(toneMidLeadingZeros + 1 : cueToneArrayLength) = tempToneArrayMid(:);
toneArrayHigh(toneHighLeadingZeros + 1 : cueToneArrayLength) = tempToneArrayHigh(:);


cueToneArray = zeros(6, cueToneArrayLength, numAudioChannels);   % First index of this array is the identifier of the tone. Second and third indices define the array for the sound itself (samples and channels).

if colBalance == 1
    cueToneArray(1, :, toneChannels(1)) = toneArrayLow(:) * cueToneHighestVolume;  % high value left
    cueToneArray(2, :, toneChannels(2)) = toneArrayLow(:) * cueToneHighestVolume * rightSpeakerVolumeMultiple;  % high value right
    cueToneArray(3, :, toneChannels(1)) = toneArrayHigh(:) * cueToneHighestVolume * higherToneVolumeMultiple;  % low value left
    cueToneArray(4, :, toneChannels(2)) = toneArrayHigh(:) * cueToneHighestVolume * rightSpeakerVolumeMultiple * higherToneVolumeMultiple;  % low value right
    
else
    cueToneArray(1, :, toneChannels(1)) = toneArrayHigh(:) * cueToneHighestVolume * higherToneVolumeMultiple;  % high value left
    cueToneArray(2, :, toneChannels(2)) = toneArrayHigh(:) * cueToneHighestVolume * rightSpeakerVolumeMultiple * higherToneVolumeMultiple;  % high value right
    cueToneArray(3, :, toneChannels(1)) = toneArrayLow(:) * cueToneHighestVolume;  % low value left
    cueToneArray(4, :, toneChannels(2)) = toneArrayLow(:) * cueToneHighestVolume * rightSpeakerVolumeMultiple;  % low value right
    
end

cueToneArray(5, :, toneChannels(1)) = toneArrayMid(:) * cueToneHighestVolume;      % These are only used for practice trials
cueToneArray(6, :, toneChannels(2)) = toneArrayMid(:) * cueToneHighestVolume * rightSpeakerVolumeMultiple * higherToneVolumeMultiple;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE TARGET NOISES %
%%%%%%%%%%%%%%%%%%%%%%%%%%

[tempNoiseArray, noiseFreq] = audioread('monoNoiseBurst.wav');     % read in mono white noise

noiseArrayLength = length(tempNoiseArray);

noiseArray = zeros(4, noiseArrayLength, numAudioChannels);   % First index of this array is the identifier of the noise. Second and third indices define the array for the sound itself (samples and channels).

for ii = 1 : 4
    noiseArray(ii, :, noiseChannels(ii)) = tempNoiseArray(:);    % So noiseArray defined by identifier 1 will have zeros in columns for all channels except the first noise channel. Identifier 2 will have zeros in all column channels except the second noise channel, and so on.
end

clear tempNoiseArray


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



initialInstructions;

numPracticeSessions = 0;
stillPractising = 1;

while stillPractising
    numPracticeSessions = numPracticeSessions + 1;
    [~, practiceAccuracy] = runTrials(0);     % Practice phase
    save(datafilename, 'DATA');
    
    DrawFormattedText(MainWindow, ['Accuracy = ', num2str(practiceAccuracy), '%'], 'center', 'center' , white);
    oldTextSize = Screen('TextSize', MainWindow, 26);
    DrawFormattedText(MainWindow, 'EXPERIMENTER: 8 to continue, 2 to repeat practice trials', 'center', 700, white);
    Screen(MainWindow, 'Flip');
    Screen('TextSize', MainWindow, oldTextSize);
    
    RestrictKeysForKbCheck([KbName('8'), KbName('2')]);   % Only accept keypresses from numeric keypad 8 and 2 keys
    KbWait([], 2);
    [~, ~, keyCode] = KbCheck;      % This stores which key is pressed (keyCode)
    keyCodePressed = find(keyCode, 1, 'first');     % If participant presses more than one key, KbCheck will create a keyCode array. Take the first element of this array as the response
    keyPressed = KbName(keyCodePressed);    % Get name of key that was pressed
    RestrictKeysForKbCheck([]); % Re-enable all keys

    if strcmp(keyPressed, '8')
        stillPractising = 0;
    end
    
    Screen(MainWindow, 'Flip');

end

exptInstructions;

[sessionPoints, ~] = runTrials(1);

if exptSession == 1
    awareInstructions;
    awareTest;
end


sessionBonus = 100 * (10 + (sessionPoints - 14500)/950);   % convert points into cents at rate based on pilot testing

sessionBonus = 10 * ceil(sessionBonus/10);        % ... round this value UP to nearest 10 cents
sessionBonus = sessionBonus / 100;    % ... then convert to dollars

if sessionBonus < 7.10        %check to see if participant earned less than $7.10; if so, adjust payment upwards
    actual_bonus_payment = 7.10;
elseif sessionBonus > 17.10
    actual_bonus_payment = 17.10;
else
    actual_bonus_payment = sessionBonus;
end

DATA.session_Bonus = sessionBonus;
DATA.session_Points = sessionPoints;
DATA.actualBonusSession = actual_bonus_payment;
DATA.totalBonus = actual_bonus_payment + starting_total;
DATA.end_time = datestr(now,0);

save(datafilename, 'DATA');


[~, ny, ~] = DrawFormattedText(MainWindow, ['EXPERIMENT COMPLETE\n\nPoints earned = ', separatethousands(sessionPoints, ','), '\n\nCash bonus = $', num2str(actual_bonus_payment, '%0.2f')], 'center', 'center' , white);

fid1 = fopen('ExptData\_TotalBonus_summary.csv', 'a');
fprintf(fid1,'%d,%f\n', p_number, actual_bonus_payment + starting_total);
fclose(fid1);

DrawFormattedText(MainWindow, '\n\n\nPlease fetch the experimenter', 'center', ny , white);

Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('ESCAPE'));   % Only accept escape key to quit
KbWait([], 2);




rmpath(genpath(functionFoldername));       % Then add path to this folder and all subfolders

Screen('Preference', 'SkipSyncTests',0);

Screen('CloseAll');

clear all
