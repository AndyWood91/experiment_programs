function [rewardPropCorrect, runningTotalPoints] = runTrials(exptPhase)

global DATA MainWindow
global bColour white screenWidth screenHeight
global soundPAhandle winSoundArray
global datafilename

global rewardImages numRewardImages
global neutImages numNeutImages
global baselineImages numBaselineImages
global targetImages numTargetImages targetRotation


%% Set parameters

itemsPerStream = 18;

lagType1 = 2;
lagType2 = 4;
lagType3 = 10;

exptBlocks = 6;    % 6 change this if you want fewer blocks in the experiment
numTrialsInMainExpt = 45;       % 45

finalDistractDuration = 0.1;    % 0.1     100 ms distractor duration
finalStandardDuration = 0.06;    % 0.06     60 ms standard duration

initialPauseDuration = 1;   % 1 Pause at start of each block
itiDuration = 0.5;          % 0.5
fixationDuration = 0.5;     % 0.5
feedbackDuration = 0.9;     % 0.9
blockInstrPause = 10;       % 15


runningTotalPoints = 0;

earliestDistractPosition = 3;
latestDistractPosition = 6;

largeamount = 50;


green = [0, 255, 0];
% red = [255, 0, 0];
% yellow = [255, 255, 0];
% grey = [100, 100, 100];


fixationSize = 20;  % Side length of fixation cross


leftResponseName = KbName('LeftArrow');
rightResponseName = KbName('RightArrow');

numRewardTrials = 0;
numRewardTrialsCorrect = 0;


%% Create windows for various things

% Window for response screen, with arrows as a prompt
answerscreen = Screen(MainWindow, 'OpenOffscreenWindow', bColour);   % This is currently left blank...

scaleFactor = 0.6;
arrowImgMatrix=imread('images\leftArrow.jpg', 'jpg');
arrowHeight = scaleFactor * size(arrowImgMatrix,1);
arrowWidth = scaleFactor * size(arrowImgMatrix,2);
arrowImageTexture = Screen('MakeTexture', MainWindow, arrowImgMatrix);

arrowSeparation = 70;

Screen('DrawTexture', answerscreen, arrowImageTexture, [], [screenWidth/2 - arrowSeparation - arrowWidth, screenHeight/2 - arrowHeight/2, screenWidth/2 - arrowSeparation, screenHeight/2 + arrowHeight/2]);
Screen('DrawTexture', answerscreen, arrowImageTexture, [], [screenWidth/2 + arrowSeparation, screenHeight/2 - arrowHeight/2, screenWidth/2 + arrowSeparation + arrowWidth, screenHeight/2 + arrowHeight/2], 180);

Screen('Close', arrowImageTexture);
Screen('TextFont', answerscreen, 'Segoe UI Semibold');
Screen('TextStyle', answerscreen, 0);
Screen('TextSize', answerscreen, 80);

DrawFormattedText(answerscreen, '?', 'center', 'center', [191,191,191]);


% Window for fixation screen

fixateScreen = Screen(MainWindow, 'OpenOffscreenWindow', bColour);
Screen('DrawLine', fixateScreen, white, screenWidth/2 - fixationSize/2, screenHeight/2, screenWidth/2 + fixationSize/2, screenHeight/2, 2);
Screen('DrawLine', fixateScreen, white, screenWidth/2, screenHeight/2 - fixationSize/2, screenWidth/2, screenHeight/2 + fixationSize/2, 2);


%% Set arrays for different image types

rewardNumberArray = 1 : numRewardImages;
neutNumberArray = 1 : numNeutImages;
baselineNumberArray = 1 : numBaselineImages;
targetNumberArray = 1 : numTargetImages;


%% Create windows for the RSVP frames
for ii = 1 : itemsPerStream
    rsvpStimulus(ii) = Screen('OpenOffscreenWindow', MainWindow, bColour);      % Creates a full-screen window for each frame of the RSVP stream. On each trial we will copy the items to be shown into these windows.
end

%% Create some rects for centring the RSVP items in the main window

fullScreenRect = [0, 0, screenWidth, screenHeight];

[imageWidth, imageHeight] = Screen('WindowSize', baselineImages(1));

imageRect = [0, 0, imageWidth, imageHeight];


%% Create full-size windows and draw the boring feedback (Correct / error) into them
boringFeedbackFontSize = 48;

correctFeedbackWindow = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextSize', correctFeedbackWindow, boringFeedbackFontSize);
Screen('TextFont', correctFeedbackWindow, 'Segoe UI');
Screen('TextStyle', correctFeedbackWindow, 0);
DrawFormattedText(correctFeedbackWindow, 'correct', 'center', 'center', white);

errorFeedbackWindow = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextSize', errorFeedbackWindow, boringFeedbackFontSize);
Screen('TextFont', errorFeedbackWindow, 'Segoe UI');
Screen('TextStyle', errorFeedbackWindow, 0);
DrawFormattedText(errorFeedbackWindow, 'error', 'center', 'center', white);


%% Create small offscreen windows and draw the reward feedback into them

bonusTexRect = [0, 0, 480, 180];

bonusTexGain = Screen('OpenOffscreenWindow', MainWindow, bColour, bonusTexRect);
Screen('FrameRect', bonusTexGain, green, bonusTexRect, 6);
Screen('TextSize', bonusTexGain, 54);
Screen('TextFont', bonusTexGain, 'Segoe UI');
Screen('TextStyle', bonusTexGain, 1);
DrawFormattedText(bonusTexGain, ['CORRECT\nWIN ', num2str(largeamount), ' POINTS!!'], 'center', 'center', green);

% bonusTexLoss = Screen('OpenOffscreenWindow', MainWindow, bColour, bonusTexRect);
% Screen('FrameRect', bonusTexLoss, red, bonusTexRect, 6);
% Screen('TextSize', bonusTexLoss, 54);
% Screen('TextFont', bonusTexLoss, 'Segoe UI');
% Screen('TextStyle', bonusTexLoss, 1);
% DrawFormattedText(bonusTexLoss, ['ERROR\nLOSE ', num2str(largeamount), ' POINTS'], 'center', 'center', red);


%% Set the trial types

if exptPhase == 1      % Initial practice
    numBlocks = 1;
    numTrials = 8;
    
    distractType = zeros(numTrials, 1);
    lag = zeros(numTrials, 1);
    
    distractType(:) = 3;     % All baseline trials
    
    lag(1:2) = lagType1;
    lag(3:4) = lagType2;
    lag(5:8) = lagType3;
    
elseif exptPhase == 2     % Main expt
    
    numBlocks = exptBlocks;
    numTrials = numTrialsInMainExpt;
    distractType = zeros(numTrials, 1);
    lag = zeros(numTrials, 1);
    
    distractType(1) = 1;   % Reward
    distractType(2) = 1;   % Reward
    distractType(3) = 2;   % Neutral
    distractType(4) = 2;   % Neutral
    distractType(5) = 3;   % Baseline
    
    for ii = 6 : numTrials
        distractType(ii) = distractType(ii-5);
    end
    
    lag(1:5) = lagType1;
    lag(6:10) = lagType2;
    lag(11:15) = lagType3;
    
    for ii = 16 : numTrials
        lag(ii) = lag(ii-15);
    end
    
end

totalTrials = numBlocks * numTrials;

trialOrder = 1 : numTrials;

rsvpDuration = zeros(itemsPerStream, 1);

PsychPortAudio('FillBuffer', soundPAhandle, winSoundArray');

%% Run the trials!


Screen('Flip', MainWindow);     % blank screen

trialCounter = 0;


for block = 1 : numBlocks

    if block > 1
        showBlockInstruction(blockInstrPause, block, numBlocks, runningTotalPoints);
    end
    
    WaitSecs(initialPauseDuration);
    
    trialOrder = Shuffle(trialOrder);     % Shuffle trial order
    
    for trial = 1 : numTrials    % this is the number of the trial WITHIN EACH BLOCK (i.e. resets to zero at start of block)
        
        trialCounter = trialCounter + 1;    % This records the number of the trial WITHIN THE CURRENT PHASE (doesn't reset each block)
        
        RestrictKeysForKbCheck([leftResponseName, rightResponseName]);   % Only accept keypresses from the response keys
        
        Screen('Flip', MainWindow);     % blank screen
        WaitSecs(itiDuration);
        
        
        % Set all the trial parameters
        trialLag = lag(trialOrder(trial));
        trialDistractType = distractType(trialOrder(trial));
        
        possibleDistractPositions = earliestDistractPosition : latestDistractPosition;
        trialDistractPosition = Sample(possibleDistractPositions);   % Draws a random sample from the array of possible distractor positions
        
        trialTargetPosition = trialDistractPosition + trialLag;
        
        baselineNumberArray = Shuffle(baselineNumberArray);
        
        trialDistractID = baselineNumberArray(trialDistractPosition);
        
        for ii = 1 : itemsPerStream
            Screen('DrawTexture', rsvpStimulus(ii), baselineImages(baselineNumberArray(ii)), [], CenterRect(imageRect, fullScreenRect));
        end
        
        if trialDistractType == 1
            trialDistractID = Sample(rewardNumberArray);
            Screen('DrawTexture', rsvpStimulus(trialDistractPosition), rewardImages(trialDistractID), [], CenterRect(imageRect, fullScreenRect));
            
        elseif trialDistractType == 2
            trialDistractID = Sample(neutNumberArray);
            Screen('DrawTexture', rsvpStimulus(trialDistractPosition), neutImages(trialDistractID), [], CenterRect(imageRect, fullScreenRect));
            
        end
        
        trialTargetID = Sample(targetNumberArray);
        Screen('DrawTexture', rsvpStimulus(trialTargetPosition), targetImages(trialTargetID), [], CenterRect(imageRect, fullScreenRect));
        
        trialTargetRotation = targetRotation(trialTargetID);
        
        
        % Set durations
        if exptPhase == 1       % Practice
            
            if trial <= 2
                standardDuration = 0.2;
                distractDuration = 0.2;
            elseif trial > 2 && trial <= 4
                standardDuration = 0.15;
                distractDuration = 0.15;
            elseif trial > 4 && trial <= 6
                standardDuration = 0.1;
                distractDuration = 0.1;
            elseif trial > 6
                standardDuration = finalStandardDuration;
                distractDuration = finalDistractDuration;
            end
            
        else
            standardDuration = finalStandardDuration;
            distractDuration = finalDistractDuration;
        end
        
        
        for ii = 1 : itemsPerStream
            rsvpDuration(ii) = standardDuration;
        end
        rsvpDuration(trialDistractPosition) = distractDuration;
        
        
        
        % Start showing the items
        
        Screen('DrawTexture', MainWindow, fixateScreen);
        Screen('Flip', MainWindow);
        WaitSecs(fixationDuration);
        
        Screen('DrawTexture', MainWindow, rsvpStimulus(1));
        stimStartTime = Screen('Flip', MainWindow);     % Wait for ISI period, then present stimulus
        rsvpStartTime = stimStartTime;
        
        for ii = 2 : itemsPerStream
            Screen('DrawTexture', MainWindow, rsvpStimulus(ii));
            stimStartTime = Screen('Flip', MainWindow, stimStartTime + rsvpDuration(ii-1));
        end
        
        Screen('DrawTexture', MainWindow, answerscreen);
        rtStart = Screen('Flip', MainWindow, stimStartTime + rsvpDuration(itemsPerStream));
        
        rsvpStreamTime = rtStart - rsvpStartTime;   % Gives duration of all RSVP items; use this to check presentation timing is accurate.
        
        [keyCode, rtEnd, ~] = accKbWait();
        
        keyCodePressed = find(keyCode, 1, 'first');
        
        rt = rtEnd - rtStart;      % Response time
        
        trialCorrect = 0;
        if trialTargetRotation == 1     % Target rotated left
            if keyCodePressed == leftResponseName; trialCorrect = 1; end
        else
            if keyCodePressed == rightResponseName; trialCorrect = 1; end
        end
        
        
        if trialDistractType == 1      % If this is a reward trial
            
            numRewardTrials = numRewardTrials + 1;      % This is used for calculating % correct on reward trials (for bonus payment)
            
            if trialCorrect == 1
                PsychPortAudio('Start', soundPAhandle);
                Screen('DrawTexture', MainWindow, bonusTexGain, [], CenterRect(bonusTexRect, fullScreenRect));
                runningTotalPoints = runningTotalPoints + largeamount;
                numRewardTrialsCorrect = numRewardTrialsCorrect + 1;
            else
                Screen('DrawTexture', MainWindow, errorFeedbackWindow);
            end
            
        else                           % If this is a non-reward trial
            if trialCorrect == 1
                Screen('DrawTexture', MainWindow, correctFeedbackWindow);
            else
                Screen('DrawTexture', MainWindow, errorFeedbackWindow);
            end
        end
        
        Screen('Flip', MainWindow);
        WaitSecs(feedbackDuration);
        
        
        trialData = [block, trial, trialDistractType, trialLag, trialDistractPosition, trialTargetPosition, trialTargetRotation, trialDistractID, trialTargetID, trialCorrect, rt, runningTotalPoints, rsvpStreamTime];
        
        if trialCounter == 1
            DATA.trialInfo(exptPhase).trialData = zeros(totalTrials, size(trialData,2));
        end
        
        DATA.trialInfo(exptPhase).trialData(trialCounter,:) = trialData(:);
        
        save(datafilename, 'DATA');

    end     % trials
    
    
end     % blocks

rewardPropCorrect = numRewardTrialsCorrect / numRewardTrials;


Screen('Close', answerscreen);
Screen('Close', fixateScreen);
Screen('Close', rsvpStimulus(:));
Screen('Close', correctFeedbackWindow);
Screen('Close', errorFeedbackWindow);
Screen('Close', bonusTexGain);
% Screen('Close', bonusTexLoss);
% Screen('Close', informRewardWindow);
% Screen('Close', informNonRewardWindow);
% Screen('Close', noInformWindow);


end

%%
function showBlockInstruction(blockPause, block, numBlocks, runningTotalPoints)

global MainWindow bColour white

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar

instrWindow = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextFont', instrWindow, 'Segoe UI');
Screen('TextStyle', instrWindow, 0);
Screen('TextSize', instrWindow, 40);


Screen('TextStyle', instrWindow, 1);
creditString = ['You have completed ', num2str(block-1), ' out of ', num2str(numBlocks), ' blocks.\n\nSo far you have earned ', separatethousands(runningTotalPoints, ','),' points.'];
[~, ny, ~] = DrawFormattedText(instrWindow, creditString, 150, 150, [255, 255, 0]);

Screen('TextStyle', instrWindow, 0);
DrawFormattedText(instrWindow, 'Please take a break; you will be able to carry on in a few moments.', 150, ny + 100, white);
Screen('DrawTexture', MainWindow, instrWindow);
Screen('Flip', MainWindow);


WaitSecs(blockPause);

Screen('TextStyle', instrWindow, 1);
DrawFormattedText(instrWindow, 'Press space when you are ready to continue', 'center', 900, [0, 255, 255]);
Screen('DrawTexture', MainWindow, instrWindow);
Screen('Flip', MainWindow);


Screen('Close', instrWindow);


KbWait([], 2);
Screen('Flip', MainWindow);

end