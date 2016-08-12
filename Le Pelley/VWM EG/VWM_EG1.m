
clear all

Screen('CloseAll');

clc;

functionFoldername = fullfile(pwd, 'functions');    % Generate file path for "functions" folder in current working directory
addpath(genpath(functionFoldername));       % Then add path to this folder and all subfolders

global MainWindow
global xCentre yCentre
global pNumber
global DATA datafilename EGdataFilenameBase
global white yellow
global bgdColour
global debugVersion eyeVersion
global calibrationNum

debugVersion = false;
eyeVersion = true;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

commandwindow;

calibrationNum = 0;

if debugVersion     % Parameters for development / debugging
    Screen('Preference', 'SkipSyncTests', 2);      % Skips the Psychtoolbox calibrations
    screenNum = 0;
    fprintf('\n\nEXPERIMENT IS BEING RUN IN DEBUGGING MODE!!! IF YOU ARE RUNNING A ''REAL'' EXPT, QUIT AND CHANGE testVersion TO ZERO\n\n');
else     % Parameters for running the real experiment
    Screen('Preference', 'SkipSyncTests', 0);
    screenNum = 0;
end


KbName('UnifyKeyNames');    % Important for some reason to standardise keyboard input across platforms / OSs.

if exist('Data', 'dir') == 0
    mkdir('Data');
end
if exist('Data\BehavData', 'dir') == 0
    mkdir('Data\BehavData');
end

if eyeVersion
    
    disp('Initializing tetio...');
    tetio_init();
    
    disp('Browsing for trackers...');
    trackerinfo = tetio_getTrackers();
    trackerId = trackerinfo(1).ProductId;
    
    fprintf('Connecting to tracker "%s"...\n', trackerId);
    tetio_connectTracker(trackerId)
    
    currentFrameRate = tetio_getFrameRate;
    fprintf('Connected!  Sample rate: %d Hz.\n', currentFrameRate);
    
    DATA.trackerID = trackerId;
    
    if exist('Data\CalibrationData', 'dir') == 0
        mkdir('Data\CalibrationData');
    end
    if exist('Data\EyeData', 'dir') == 0
        mkdir('Data\EyeData');
    end
    
    
end

if debugVersion
    pNumber = 1;
    p_sex = 'm';
    p_age = 123;
    pEmail = 'flibble@flibble.com';
    datafilename = ['Data\BehavData\VWM_EG_P', num2str(pNumber), '.mat'];
    
else
    
    inputError = 1;
    
    while inputError == 1
        inputError = 0;
        
        pNumber = input('Participant number  ---> ');
        
        datafilename = ['Data\BehavData\VWM_EG_P', num2str(pNumber), '.mat'];
        
        if exist(datafilename, 'file') == 2
            disp(['Data for participant ', num2str(pNumber),' already exist'])
            inputError = 1;
        end
        
    end
    
    p_sex = 'a';
    while p_sex ~= 'm' && p_sex ~= 'f' && p_sex ~= 'M' && p_sex ~= 'F'
        p_sex = input('Participant gender (M/F) ---> ', 's');
        if isempty(p_sex); p_sex = 'a'; end
    end
    
    p_age = input('Participant age ---> ');
    
    p_hand = 'a';
    while p_hand ~= 'r' && p_hand ~= 'l' && p_hand ~= 'R' && p_hand ~= 'L'
        p_hand = input('Participant hand (R/L) ---> ','s');
        if isempty(p_hand); p_hand = 'a'; end
    end
    
    fprintf('\nIf you would like to register for the chance to win a bonus of $20, please enter an email address.\nIf you do not wish to register, you can leave this blank.\n');
    pEmail = input('Email ---> ', 's');
    
end



DATA.subject = pNumber;
DATA.age = p_age;
DATA.sex = p_sex;
DATA.pEmail = pEmail;
DATA.start_time = datestr(now,0);


if eyeVersion
    EGfolderName = 'Data\EyeData';
    mkdir(EGfolderName, ['P', num2str(pNumber)]);
    EGdataFilenameBase = [EGfolderName, '\P', num2str(pNumber), '\GazeDataP', num2str(pNumber)];
end


% generate a random seed using the clock, then use it to seed the random
% number generator
rng('shuffle');
randSeed = randi(30000);
DATA.rSeed = randSeed;
rng(randSeed);


% set colors
grayVal = 128;
white = [255, 255, 255];
black = [0, 0, 0];
gray = [grayVal, grayVal, grayVal];
yellow = [255, 255, 0];

bgdColour = gray;

HideCursor;


[MainWindow, windowRect] = Screen('OpenWindow', screenNum, bgdColour);

[xCentre, yCentre] = RectCenter(windowRect);

Screen('Preference', 'DefaultFontName', 'Segoe UI');
Screen('BlendFunction', MainWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

Screen('TextFont', MainWindow, 'Segoe UI');
Screen('TextSize', MainWindow, 34);
Screen('TextStyle', MainWindow, 0);

oldFont = Screen('TextFont', MainWindow);   % Record these, because the eye-tracker calibration (which comes later) will screw with them
oldSize = Screen('TextSize', MainWindow);
oldStyle = Screen('TextStyle', MainWindow);



DATA.frameRate = round(Screen('FrameRate', MainWindow));

HideCursor;


startSecs = GetSecs;

runTrials(0);   % instructions

runTrials(1);   % Practice

Screen('TextFont', MainWindow, 'Segoe UI');
Screen('TextSize', MainWindow, 48);
DrawFormattedText(MainWindow, 'Next we need to calibrate the eye-tracker.\n\nPlease let the experimenter know when you are ready.', 'center', 'center', yellow);
Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('C'));
KbWait([], 2);
Screen('Flip', MainWindow);


if eyeVersion
    RestrictKeysForKbCheck([]);
    runPTBcalibration;
end

Screen('TextFont', MainWindow, oldFont);
Screen('TextSize', MainWindow, oldSize);
Screen('TextStyle', MainWindow, oldStyle);


Screen('TextFont', MainWindow, 'Segoe UI');
Screen('TextSize', MainWindow, 48);
DrawFormattedText(MainWindow, 'You are now ready to begin the main experiment.\n\nPlease let the experimenter know when you are ready.', 'center', 'center', yellow);
Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('RightArrow'));
KbWait([], 2);
Screen('Flip', MainWindow);

[maxTrial, totalDeviation] = runTrials(2);

avgDeviationTotal = round(totalDeviation / maxTrial);

DATA.avgDeviation = avgDeviationTotal;
DATA.end_time = datestr(now,0);
DATA.exptDuration = GetSecs - startSecs;

save(datafilename, 'DATA');


Screen('TextFont', MainWindow, 'Segoe UI Semibold');
Screen('TextSize', MainWindow, 48);

DrawFormattedText(MainWindow, ['EXPERIMENT COMPLETE!\n\nOverall average deviation: ', num2str(avgDeviationTotal), 176, '\n\nYou will be contacted if you have won the bonus for having\none of the three lowest average deviations.\n\nThanks for taking part!\n\nPlease fetch the experimenter.'], 'center', 'center', white, 80, [], [], 1.3);

Screen('Flip', MainWindow);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now condense all the EG data files for individual trials into a single
% file for each participant, and delete the originals
if eyeVersion
    
    overallEGdataFilename = [EGfolderName, '\GazeDataP', num2str(pNumber), '.mat'];
    
    for trial = 1 : maxTrial
        inputFilename = [EGdataFilenameBase, 'T', num2str(trial), '.mat'];
        load(inputFilename);
        ALLGAZEDATA.itemsDataTrial(trial).itemsData = GAZEDATA.itemsData;
        ALLGAZEDATA.fixDataTrial(trial).fixData = GAZEDATA.fixData;
        ALLGAZEDATA.postFixDataTrial(trial).postFixData = GAZEDATA.postFixData;
        clear GAZEDATA;
    end
    save(overallEGdataFilename, 'ALLGAZEDATA');
    rmdir([EGfolderName, '\P', num2str(pNumber)], 's');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


RestrictKeysForKbCheck(KbName('ESCAPE'));   % Only accept escape key to quit
KbWait([], 2);
RestrictKeysForKbCheck([]); % Re-enable all keys

rmpath(genpath(functionFoldername));

Screen('Preference', 'SkipSyncTests',0);

Screen('CloseAll');

clear all

