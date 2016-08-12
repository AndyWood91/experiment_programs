
function [trial, allDeviationCounter] = runTrials(exptPhase)       % Return final trial number (used for collating EG data)

global MainWindow DATA datafilename EGdataFilenameBase
global xCentre yCentre
global bgdColour
global debugVersion eyeVersion
global white yellow

if debugVersion
    fixationDuration = 0.5;
    postFixationBlankDuration = 0.4;
    itemDurationArray = [2, 1];  % Practice, Main task
    maskDuration = 0.2;
    blankDuration = 0.5;
    feedbackDurationArray = [1.5, 1];  % Practice, Main task
    itiDuration = 1;
    initialPause = 0.001;
    breakDuration = 0.001;
else
    fixationDuration = 0.5;
    postFixationBlankDuration = 0.4;
    itemDurationArray = [2, 1];  % Practice, Main task
    maskDuration = 0.2;
    blankDuration = 0.5;
    feedbackDurationArray = [1.5, 1];  % Practice, Main task
    itiDuration = 1;
    initialPause = 1;
    breakDuration = 20;
end


instructionPhase = false;
if exptPhase == 0
    instructionPhase = true;
end

eyePhase = false;
if eyeVersion && exptPhase == 2
    eyePhase = true;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up trial types, blocks etc

numTrialTypes = 2;    % 2 trial types (3 items vs 6 items)

numItemsTrialType = zeros(numTrialTypes, 1);
numItemsTrialType(1) = 3;
numItemsTrialType(2) = 6;


if debugVersion
    if exptPhase == 1
        trialsPerBlock = 2;     % 5 trials per block practice
        trialsPerBreak = trialsPerBlock;
        numTrials = trialsPerBlock;     % 5 practice trials
    else
        trialsPerBlock = 2;
        trialsPerBreak = trialsPerBlock;
        numTrials = trialsPerBlock * 3;
    end
    
    
else
    if exptPhase == 1
        trialsPerBlock = 5;     % 5 trials per block practice
        trialsPerBreak = trialsPerBlock;
        numTrials = trialsPerBlock;     % 5 practice trials
    else
        trialsPerBlock = 30;     % 30 trials per block main task
        trialsPerBreak = trialsPerBlock;
        numTrials = trialsPerBlock * 14;    % 14 blocks main task
    end
end


if instructionPhase
    numTrials = 1;
else
    
    trialType = ones(trialsPerBlock, 1);

    if exptPhase == 1
        trialType(trialsPerBlock - 1) = 2;  % final two trials of practice phase are hard type
        trialType(trialsPerBlock) = 2;  
    
    elseif exptPhase == 2
        trialType(1 + trialsPerBlock/2 : trialsPerBlock) = 2;   % If it's the main task, have equal number of 3-item and 6-item trials...
        trialType = Shuffle(trialType);     % ... and shuffle the order of trial types.
    end
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up instructions
instrLeft = 100;
instrTop = 100;
instrWrap = 100;
instructStr1 = 'On each trial a cross will appear, to warn you that the trial is about to start.';
instructStr2 = 'Then a set of shapes will appear briefly; an example is shown below. Each shape will be a circle with a ''bead'' on it. You should try to note the positions of the beads.';
instructStr3 = 'Then a mask will appear briefly...';
instructStr4 = 'You will then be shown one of the circles, and your task is to use the mouse to position the bead as close to where it was in the original circle as possible. When you are happy with the position of the bead, press space to confirm your response.';
instructStr5 = 'You will then be told the deviation between your response and the actual angle of the bead - your aim should be to make the deviation as small as possible.';
instructStr6 = 'This is quite a difficult task, but please try your best! The three participants who score the lowest average deviation across the experiment will each receive a bonus of $20.\n\nYou will now have a chance to practice the task.\n\nPlease press the spacebar when you are ready to begin.';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set item properties

itemArrayRadius = 300;

circlePen = 2;
cRadius = 60;   % 60
gemDiameter = 20;   % 20

numGemsMask = 15;    % 15

fixationSize = 10;

circleRect = [0, 0, 2 * cRadius, 2 * cRadius];
gemRect = [0, 0, gemDiameter, gemDiameter];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set colours for stimuli

numColours = 8;
colourArray = zeros(numColours,3);
colourArray(1, :) = [255, 40, 40];      % red
colourArray(2, :) = [200, 200, 0];      % yellow
colourArray(3, :) = [0, 190, 0];        % green
colourArray(4, :) = [0, 200, 200];      % cyan
colourArray(5, :) = [0, 128, 255];      % blue
colourArray(6, :) = [230, 20, 230];     % magenta
colourArray(7, :) = [200, 140, 0];      % brown
colourArray(8, :) = [255, 128, 128];    % salmon

colourSelector = 1:8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up textures and windows
circleTex = Screen('OpenOffscreenWindow', MainWindow, [bgdColour, 0], circleRect);
Screen('BlendFunction', circleTex, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('FrameOval', circleTex, white, circleRect, circlePen, circlePen);

gemTex = Screen('OpenOffscreenWindow', MainWindow, [bgdColour, 0], gemRect);    % Create window with zero alpha value (i.e. transparent)
Screen('BlendFunction', gemTex, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('FillOval', gemTex, [white, 255], gemRect, gemDiameter);        % Draw circle with 100% alpha (i.e. opaque)

[maskItemTex, maskRect] = Screen('OpenOffscreenWindow', MainWindow, [bgdColour, 0], circleRect + gemRect);  
Screen('BlendFunction', maskItemTex, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('FrameOval', maskItemTex, white, CenterRect(circleRect, maskRect), circlePen, circlePen);
[maskCentreX, maskCentreY] = RectCenter(maskRect);

angleBetweenMaskGems = round(360/numGemsMask);
for ii = 1 : numGemsMask
    maskGemX = maskCentreX + cRadius * cosd(angleBetweenMaskGems * ii);
    maskGemY = maskCentreY - cRadius * sind(angleBetweenMaskGems * ii);
    Screen('DrawTexture', maskItemTex, gemTex, [], CenterRectOnPoint(gemRect, maskGemX, maskGemY));
end

fixateScreen = Screen(MainWindow, 'OpenOffscreenWindow', bgdColour);
Screen('DrawLine', fixateScreen, white, xCentre - fixationSize, yCentre, xCentre + fixationSize, yCentre, 2);
Screen('DrawLine', fixateScreen, white, xCentre, yCentre - fixationSize, xCentre, yCentre + fixationSize, 2);

maskWindow = Screen('OpenOffscreenWindow', MainWindow, bgdColour);  
Screen('BlendFunction', maskWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

stimDisplayWindow = Screen('OpenOffscreenWindow', MainWindow, bgdColour);  
Screen('BlendFunction', stimDisplayWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up feedback limits

deviationLimit = zeros(4,1);
deviationLimit(1) = 10;     % Deviations smaller than this are labelled OUTSTANDING!
deviationLimit(2) = 20;     % Deviations smaller than this are labelled Very good!
deviationLimit(3) = 35;     % Deviations smaller than this are labelled Good
deviationLimit(4) = 45;     % Deviations smaller than this are labelled OK
% Anything larger is labelled Poor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


maxNumItems = max(numItemsTrialType);
itemAngle = zeros(1, maxNumItems);
itemCentreX = zeros(1, maxNumItems);
itemCentreY = zeros(1, maxNumItems);
itemColour = zeros(maxNumItems, 3);
actualGemAngle = zeros(1, maxNumItems);

Screen('TextFont', MainWindow, 'Segoe UI Semibold');
Screen('TextSize', MainWindow, 48);

format long e;

instrLineSpacing = 1.2;


if ~instructionPhase
    itemDuration = itemDurationArray(exptPhase);
    feedbackDuration = feedbackDurationArray(exptPhase);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% START THE TRIALS!

trialInBlock = 0;
trialSinceBreak = 0;
blkDeviationCounter = 0;
allDeviationCounter = 0;
block = 1;

if eyePhase
    tetio_startTracking; % start recording
end


WaitSecs(initialPause);

for trial = 1 : numTrials
    
    trialInBlock = trialInBlock + 1;
    trialSinceBreak = trialSinceBreak + 1;
    
    if instructionPhase
        numItems = 3;
        RestrictKeysForKbCheck(KbName('RightArrow'));
    else
        numItems = numItemsTrialType(trialType(trialInBlock));
    end
    
    Screen('FillRect', stimDisplayWindow, bgdColour);  % Blank stimulus screen from previous trial
    Screen('FillRect', maskWindow, bgdColour);  % Blank mask screen from previous trial
    
    gemVisible = false;
    
    trialColourSelector = Shuffle(colourSelector);
    
    if instructionPhase
        offsetAngle = 180;
    else
        offsetAngle = randi(360);
    end
    
    angleBetweenItems = round(360/numItems);
    
    itemAngle(:) = 0;
    itemCentreX(:) = 0;
    itemCentreY(:) = 0;
    actualGemAngle(:) = 0;
    
    for ii = 1 : numItems
        itemAngle(ii) = offsetAngle + angleBetweenItems * (ii - 1);
        itemAngle(ii) = itemAngle(ii) - 360 * floor (itemAngle(ii)/360);
        itemCentreX(ii) = round(xCentre + itemArrayRadius * cosd(itemAngle(ii)));
        itemCentreY(ii) = round(yCentre - itemArrayRadius * sind(itemAngle(ii)));
        
        itemColour(ii, :) = colourArray(trialColourSelector(ii), :);
        
        Screen('DrawTexture', stimDisplayWindow, circleTex, [], CenterRectOnPoint(circleRect, itemCentreX(ii), itemCentreY(ii)), [], [], [], itemColour(ii, :));
        
        maskAngle = randi(360);
        Screen('DrawTexture', maskWindow, maskItemTex, [], CenterRectOnPoint(circleRect, itemCentreX(ii), itemCentreY(ii)), maskAngle, [], [], itemColour(ii, :));
        
        actualGemAngle(ii) = randi(360);
        
        if instructionPhase
            actualGemAngle(1) = 70;
        end
        
        actualGemX = itemCentreX(ii) + cRadius * cosd(actualGemAngle(ii));
        actualGemY = itemCentreY(ii) - cRadius * sind(actualGemAngle(ii));
        
        Screen('DrawTexture', stimDisplayWindow, gemTex, [], CenterRectOnPoint(gemRect, actualGemX, actualGemY), [], [], [], itemColour(ii, :));
        
    end
    
    cX = itemCentreX(1);    % Use first item as target on every trial (angle and colour of this item is random, so this is fine)
    cY = itemCentreY(1);
    actualTargetAngle = actualGemAngle(1);
    targetColour = itemColour(1, :);
    
    Screen('DrawTexture', MainWindow, fixateScreen);

    if instructionPhase
        Screen('TextFont', MainWindow, 'Segoe UI');
        Screen('TextSize', MainWindow, 40);
        DrawFormattedText(MainWindow, instructStr1, instrLeft, instrTop, yellow, instrWrap, [], [], instrLineSpacing);
    end
    
    if ~instructionPhase
        WaitSecs(itiDuration);
    end

    
    startTime = Screen('Flip', MainWindow);     % Present fixation
    
    if eyePhase
        tetio_readGazeData; % Empty eye tracker buffer
    end
    
    
    if instructionPhase
        Screen('DrawTexture', MainWindow, stimDisplayWindow);
        DrawFormattedText(MainWindow, instructStr2, instrLeft, instrTop, yellow, instrWrap, [], [], instrLineSpacing);
        KbWait([], 2);
        Screen('Flip', MainWindow);
    else
        
        startTime = Screen('Flip', MainWindow, startTime + fixationDuration);     % Blank screen after fixation

        if eyePhase
            [leftEyeFix, rightEyeFix, tsFix, ~] = tetio_readGazeData;   % Read gaze data for fixation period
        end
        
        Screen('DrawTexture', MainWindow, stimDisplayWindow);
        
        startTime = Screen('Flip', MainWindow, startTime + postFixationBlankDuration);     % PRESENT ITEMS!!!

        if eyePhase
            [leftEyePostFix, rightEyePostFix, tsPostFix, ~] = tetio_readGazeData;   % Read gaze data for post-fixation period
        end
        
    end
    
    Screen('DrawTexture', MainWindow, maskWindow);
    if instructionPhase
        DrawFormattedText(MainWindow, instructStr3, instrLeft, instrTop, yellow, instrWrap, [], [], instrLineSpacing);
        KbWait([], 2);
        Screen('Flip', MainWindow);
    else
        

        startTime = Screen('Flip', MainWindow, startTime + itemDuration);   % Present mask

        if eyePhase
            [leftEyeItems, rightEyeItems, tsItems, ~] = tetio_readGazeData;   % Read gaze data for items period
        end
    
    end
    
    if ~instructionPhase
        startTime = Screen('Flip', MainWindow, startTime + maskDuration);   % Blank screen
    end
    
    
    Screen('DrawTexture', MainWindow, circleTex, [], CenterRectOnPoint(circleRect, cX, cY), [], [], [], targetColour);
    
    if instructionPhase
        DrawFormattedText(MainWindow, instructStr4, instrLeft, instrTop, yellow, instrWrap, [], [], instrLineSpacing);
        KbWait([], 2);
        startRT = Screen('Flip', MainWindow);
        Screen('TextFont', MainWindow, 'Segoe UI Semibold');
        Screen('TextSize', MainWindow, 48);
    else
        startRT = Screen('Flip', MainWindow, startTime + blankDuration);   % Present probe item
    end
    
    RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar

    SetMouse(xCentre, yCentre, MainWindow);
    ShowCursor('Hand');
    
    
    while ~KbCheck || ~gemVisible
        
        [mX, mY, mButtons] = GetMouse;
        
        if sum(mButtons) > 0
            
            gemVisible = true;
            
            estGemAngle = atand((cY-mY)/(mX-cX));
            estGemAngle = round(estGemAngle);
            
            if cX > mX
                estGemAngle = 180 + estGemAngle;
            end
            if estGemAngle < 0
                estGemAngle = 360 + estGemAngle;
            end
            
            estGemX = cX + cRadius * cosd(estGemAngle);
            estGemY = cY - cRadius * sind(estGemAngle);
            
            Screen('DrawTexture', MainWindow, circleTex, [], CenterRectOnPoint(circleRect, cX, cY), [], [], [], targetColour);
            Screen('DrawTexture', MainWindow, gemTex, [], CenterRectOnPoint(gemRect, estGemX, estGemY), [], [], [], targetColour);
    
            Screen('Flip', MainWindow);
            
        end
        
    end
    
    rt = GetSecs - startRT;     % Record time of keypress and calculate RT - not soooper accurate but good enough given that RT isn't v important here
    
    HideCursor;
    
    Screen('Flip', MainWindow);

    angularDeviation = min([abs(actualTargetAngle - estGemAngle), 360 - abs(actualTargetAngle - estGemAngle)]);

    if angularDeviation < deviationLimit(1)
        fbString = 'OUTSTANDING!';
    elseif angularDeviation < deviationLimit(2)
        fbString = 'Very good!';
    elseif angularDeviation < deviationLimit(3)
        fbString = 'Good';
    elseif angularDeviation < deviationLimit(4)
        fbString = 'OK';
    else
        fbString = 'Poor';
    end
    
    blkDeviationCounter = blkDeviationCounter + angularDeviation;
    allDeviationCounter = allDeviationCounter + angularDeviation;
    
    DrawFormattedText(MainWindow, ['Deviation = ', num2str(angularDeviation), 176, '\n\n', fbString], 'center', 'center', white);     % The 176 in this line is the ASCII code for degree symbol

    
    if instructionPhase
        Screen('TextFont', MainWindow, 'Segoe UI');
        Screen('TextSize', MainWindow, 40);
        DrawFormattedText(MainWindow, instructStr5, instrLeft, instrTop, yellow, instrWrap, [], [], instrLineSpacing);
        Screen('Flip', MainWindow);
        RestrictKeysForKbCheck(KbName('RightArrow'));
        KbWait([], 2);
        DrawFormattedText(MainWindow, instructStr6, instrLeft, instrTop, yellow, instrWrap, [], [], instrLineSpacing);
        Screen('Flip', MainWindow);
        RestrictKeysForKbCheck(KbName('Space'));
        KbWait([], 2);
    else
        Screen('Flip', MainWindow);
        WaitSecs(feedbackDuration);
    end
    
    Screen('Flip', MainWindow);
    
    coloursConcat = str2double(sprintf('%d',trialColourSelector(:)));     % Concatenate the array of memory set stimuli so they fit in one column of the data array

    
    if ~instructionPhase
        
        trialData = [block, trial, trialInBlock, trialSinceBreak, trialType(trialInBlock), numItems, estGemAngle, angularDeviation, rt, actualGemAngle(1, :), itemAngle(1, :), itemCentreX(1, :), itemCentreY(1, :), coloursConcat, mX, mY];
        if trial == 1
            DATA.trialInfo(exptPhase).trialData = zeros(numTrials, size(trialData,2));
        end
        DATA.trialInfo(exptPhase).trialData(trial,:) = trialData(:);
        
    end
    
    
    if eyePhase
    
        EGdataFilename = [EGdataFilenameBase, 'T', num2str(trial), '.mat'];

        GAZEDATA.fixData = [double(tsFix), leftEyeFix, rightEyeFix];
        GAZEDATA.postFixData = [double(tsPostFix), leftEyePostFix, rightEyePostFix];
        GAZEDATA.itemsData = [double(tsItems), leftEyeItems, rightEyeItems];
        
        save(EGdataFilename, 'GAZEDATA');

    end
    
    
    
    if trial ~= numTrials
        
        if trialInBlock == trialsPerBlock
            block = block + 1;
            trialType = Shuffle(trialType);
            trialInBlock = 0;
        end

        
        if mod(trial, trialsPerBreak) == 0
            save(datafilename, 'DATA');
            
            meanDeviationBlk = round(blkDeviationCounter / trialsPerBreak);
            meanDeviationAll = round(allDeviationCounter / trial);
            takeABreak(breakDuration, meanDeviationBlk, meanDeviationAll, initialPause, eyePhase);
            trialSinceBreak = 0;
            blkDeviationCounter = 0;
            
        end
    end
    
end

if eyePhase
    tetio_stopTracking; % start recording
end


save(datafilename, 'DATA');

Screen('Close', circleTex);
Screen('Close', gemTex);
Screen('Close', maskItemTex);
Screen('Close', fixateScreen);
Screen('Close', maskWindow);
Screen('Close', stimDisplayWindow);


end





function takeABreak(breakDuration, meanDeviationBlk, meanDeviationAll, initialPause, eyePhase)

global MainWindow white yellow

if eyePhase
    tetio_stopTracking; % start recording
end

[previousFontName, ~, ~] = Screen('TextFont', MainWindow, 'Segoe UI Semibold');
previousFontSize = Screen('TextSize', MainWindow, 50);


[~, ny1, ~] = DrawFormattedText(MainWindow, 'Time for a break!\n\n\n', 'center', 250, white);
[~, ny1, ~] = DrawFormattedText(MainWindow, ['Average deviation in previous block: ', num2str(meanDeviationBlk), 176, '\n\nAverage deviation for all trials so far: ', num2str(meanDeviationAll), 176], 'center', ny1, yellow);

Screen('TextFont', MainWindow, 'Segoe UI');
Screen('TextSize', MainWindow, 36);

DrawFormattedText(MainWindow, ['Relax for a moment! You will be able to carry on in ', num2str(breakDuration),' seconds.'], 'center', ny1 + 200, white);


Screen(MainWindow, 'Flip', [], 1);
WaitSecs(breakDuration);
DrawFormattedText(MainWindow, 'Please place your chin in the chinrest\n\nand press any key to continue', 'center', 900, yellow);
Screen(MainWindow, 'Flip');

Screen('TextFont', MainWindow, previousFontName);
Screen('TextSize', MainWindow, previousFontSize);

RestrictKeysForKbCheck([]);   % Any key
KbWait([], 2);

Screen(MainWindow, 'Flip');

if eyePhase
    tetio_startTracking; % start recording
end

WaitSecs(initialPause);

end
