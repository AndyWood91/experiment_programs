
function [sessionPay, accSummary] = runTrials(exptPhase)

global MainWindow
global numAudioChannels
global scr_centre DATA datafilename
global cueToneArray cueToneArrayLength toneFreq
global noiseArray noiseArrayLength
global lowestTargetVolume highestTargetVolume
global white black yellow
global bigMultiplier smallMultiplier lossAmount
global exptSession
global awareInstrPause
global topKeyName bottomKeyName
global exptCondition

%  exptTrialSequence = [CueID, TargetID, CueType, CueLoc, TargetResponse, Validity, block, trial in block]
%  DATA.expttrialInfo(trial,:) = [exptSession, exptTrialSequence(trial, :), trials_since_break, timeout, softTimeoutTrial, correct, rt, trialPay, sessionPay, noiseVolume, fixationDuration, softTimeoutDuration];


KbName('UnifyKeyNames');

softTimeoutDurationEarly = 1.1;    % 1.1 soft timeout limit for early trials
softTimeoutDurationLate = 0.75;     % 0.75  soft timeout limit for later trials

if exptPhase == 0
    timeoutDuration = 9999;     % Essentially no timeout on practice trials
else
    timeoutDuration = 2;     % 2 timeout duration for experiment trials
end

itiDuration = 0.75;            % 0.75

minFixationDuration = 750;   % 750   % These are in milliseconds to make calculations easier. Pick a random value between these limits.
maxFixationDuration = 1000;   % 1000

feedbackDuration = [0.7, 2, 1.2];       %[0.001, 0.001, 0.001]    [0.7, 2, 1.2]  FB duration: Practice, first block of expt phase, later in expt phase

initialPause = 2;   % 2 ***
breakDuration = 20;  % 20 ***
awareInstrPause = 16;  % 16




targetLocs = 4;     % Number of target locations (top-left, top-right, bottom-left, bottom-right)


if exptPhase == 0
    lowestCueType = 5;
    highestCueType = 6;
    cueTypes = 2;       % Number of cue types (mid L, mid R)
    
    typeOfEachValidTrialPerBlock = 0;   % No valid trials during practice for either condition
    typeOfEachInvalidTrialPerBlock = 2;
    
    totalBlocks = 1;
    

else
    lowestCueType = 1;
    highestCueType = 4;
    cueTypes = 4;       % Number of cue types (high-reward L, high-reward R, low-reward L, low-reward R)

    if exptCondition == 1
        typeOfEachValidTrialPerBlock = 0;
        typeOfEachInvalidTrialPerBlock = 8;
        
    elseif exptCondition == 2
        typeOfEachValidTrialPerBlock = 2;
        typeOfEachInvalidTrialPerBlock = 6;
        
    else
        typeOfEachValidTrialPerBlock = 4;
        typeOfEachInvalidTrialPerBlock = 4;
        
        
    end
    
    totalBlocks = 14;       % 14

    winMultiplier = zeros(cueTypes,1);     % winMultiplier is a bad name now; it's actually the amount that they win
    winMultiplier(1) = bigMultiplier;         % Cue tone associated with big win: L
    winMultiplier(2) = bigMultiplier;         % Cue tone associated with big win: R
    winMultiplier(3) = smallMultiplier;         % Cue tone associated with small win: L
    winMultiplier(4) = smallMultiplier;         % Cue tone associated with small win: R

    
    loseMultiplier = zeros(cueTypes,1);     % loseMultiplier is a bad name now; it's actually the amount that they lose for errors. Set this the same (small value) for all cues
    loseMultiplier(1) = -lossAmount;         % Loss for cue tone associated with big win: L
    loseMultiplier(2) = -lossAmount;         % Loss for cue tone associated with big win: R
    loseMultiplier(3) = -lossAmount;         % Loss for cue tone associated with small win: L
    loseMultiplier(4) = -lossAmount;         % Loss for cue tone associated with small win: R
    
end


trialsPerBlock = typeOfEachValidTrialPerBlock * cueTypes * targetLocs / 2 + typeOfEachInvalidTrialPerBlock * cueTypes * targetLocs / 2;

exptTrials = trialsPerBlock * totalBlocks;

exptTrialsBeforeBreak = 1 * trialsPerBlock;     % 1 * trialsPerBlock = 64


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% GENERATE TRIAL SEQUENCE %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validTrialCueID = zeros(cueTypes * targetLocs / 2, 1);
validTrialTargetID =  zeros(cueTypes * targetLocs / 2, 1);

invalidTrialCueID = zeros(cueTypes * targetLocs / 2, 1);
invalidTrialTargetID =  zeros(cueTypes * targetLocs / 2, 1);


valPositionCounter = 0;
invPositionCounter = 0;

for cueType = lowestCueType : highestCueType
    for targetLoc = 1 : targetLocs
        
        if mod(cueType, 2) == mod(targetLoc, 2)     % This means that an odd-number cue (left side) must go with an odd-number target (left side) and vice versa
            valPositionCounter = valPositionCounter + 1;
            validTrialCueID(valPositionCounter) = cueType;
            validTrialTargetID(valPositionCounter) = targetLoc;

        else
            invPositionCounter = invPositionCounter + 1;
            invalidTrialCueID(invPositionCounter) = cueType;
            invalidTrialTargetID(invPositionCounter) = targetLoc;

        end
    end
end

validTrialsInBlockCueID = repmat(validTrialCueID, typeOfEachValidTrialPerBlock, 1);
validTrialsInBlockTargetID = repmat(validTrialTargetID, typeOfEachValidTrialPerBlock, 1);

invalidTrialsInBlockCueID = repmat(invalidTrialCueID, typeOfEachInvalidTrialPerBlock, 1);
invalidTrialsInBlockTargetID = repmat(invalidTrialTargetID, typeOfEachInvalidTrialPerBlock, 1);

blockCueID = [validTrialsInBlockCueID; invalidTrialsInBlockCueID];
blockTargetID = [validTrialsInBlockTargetID; invalidTrialsInBlockTargetID];


clear validTrialCueID validTrialTargetID invalidTrialCueID invalidTrialTargetID
clear validTrialsInBlockCueID validTrialsInBlockTargetID invalidTrialsInBlockCueID invalidTrialsInBlockTargetID


blockCueType = ones(trialsPerBlock, 1);
blockCueLoc = ones(trialsPerBlock, 1);
blockTargetResponse = ones(trialsPerBlock, 1);
blockValidity = ones(trialsPerBlock, 1);

for ii = 1 : trialsPerBlock
    
    if blockCueID(ii) > 2
        blockCueType(ii) = 2;    % Low reward
    end
    if blockCueID(ii) > 4
        blockCueType(ii) = 3;    % Mid tone on practice trials
    end
    
    
    if blockCueID(ii) == 2 || blockCueID(ii) == 4 || blockCueID(ii) == 6
        blockCueLoc(ii) = 2;    % Tone on right
    end
    
    if blockTargetID(ii) > 2
        blockTargetResponse(ii) = 2;    % Bottom response
    end
    
    if (blockCueLoc(ii) == 1 && blockTargetID(ii) == 2) || (blockCueLoc(ii) == 1 && blockTargetID(ii) == 4) || (blockCueLoc(ii) == 2 && blockTargetID(ii) == 1) || (blockCueLoc(ii) == 2 && blockTargetID(ii) == 3)
        blockValidity(ii) = 2;      % Not valid
    end
    
end

blockTrialTypes = [blockCueID, blockTargetID, blockCueType, blockCueLoc, blockTargetResponse, blockValidity];

exptTrialSequence = zeros(exptTrials, 2 + size(blockTrialTypes,2));
%  exptTrialSequence = [CueID, TargetID, CueType, CueLoc, TargetResponse, Validity, block, trial in block]


repeatCriterion = 5;    % No more than 5 trials in a row with same cue type, cue location, or target response
finalTrialCueType = 0;
finalTrialCueLoc = 0;
finalTrialTargetResponse = 0;

shuffles = 0;
for ii = 1 : totalBlocks
    
    badShuffle = 1;
    
    while badShuffle
        shuffledBlockTrialTypes = blockTrialTypes(randperm(size(blockTrialTypes,1)), :);
        shuffles = shuffles + 1;
        badShuffle = 0;
        
        if shuffledBlockTrialTypes(1, 3) == finalTrialCueType || shuffledBlockTrialTypes(1, 4) == finalTrialCueLoc || shuffledBlockTrialTypes(1, 5) == finalTrialTargetResponse
            badShuffle = 1;
        else
            
            for jj = repeatCriterion + 1 : trialsPerBlock
                
                allMatchCueType = 1;
                allMatchCueLoc = 1;
                allMatchTargetResponse = 1;
                for kk = 1 : repeatCriterion
                    
                    if shuffledBlockTrialTypes(jj, 3) ~= shuffledBlockTrialTypes(jj - kk, 3)
                        allMatchCueType = 0;
                    end
                    
                    if shuffledBlockTrialTypes(jj, 4) ~= shuffledBlockTrialTypes(jj - kk, 4)
                        allMatchCueLoc = 0;
                    end
                    
                    if shuffledBlockTrialTypes(jj, 5) ~= shuffledBlockTrialTypes(jj - kk, 5)
                        allMatchTargetResponse = 0;
                    end
                    
                end
                
                if exptPhase == 0
                    allMatchCueType = 0;    % In practice phase all trials have same type of cue, so don't use that as a re-shuffle criterion
                end
                
                if allMatchCueType || allMatchCueLoc || allMatchTargetResponse
                    badShuffle = 1;
                    break;
                end
                
            end    % For loop over trials
            
        end
        
    end     % While badShuffle
    
    
    for jj = 1 : trialsPerBlock
        for kk = 1 : size(blockTrialTypes,2)
            exptTrialSequence(jj + trialsPerBlock * (ii-1), kk) = shuffledBlockTrialTypes(jj, kk);
        end
        exptTrialSequence(jj + trialsPerBlock * (ii-1), 1 + size(blockTrialTypes,2)) = ii;   % Record block number in penultimate column
        exptTrialSequence(jj + trialsPerBlock * (ii-1), 2 + size(blockTrialTypes,2)) = jj;   % Record trial number in block in final column
    end

    
    finalTrialCueType = shuffledBlockTrialTypes(trialsPerBlock, 3);
    finalTrialCueLoc = shuffledBlockTrialTypes(trialsPerBlock, 4);
    finalTrialTargetResponse = shuffledBlockTrialTypes(trialsPerBlock, 5);
    
    
end      % For loop over blocks

clear blockTrialTypes shuffledBlockTrialTypes


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if exptPhase == 0
    DATA.practrialInfo = zeros(exptTrials, 6 + size(exptTrialSequence, 2));
else
    DATA.expttrialInfo = zeros(exptTrials, 11 + size(exptTrialSequence, 2));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


soundPAhandle = PsychPortAudio('Open', [], 1, [], toneFreq, numAudioChannels);

cueToneArrayToPlay = zeros(cueToneArrayLength, numAudioChannels);
noiseArrayToPlay = zeros(noiseArrayLength, numAudioChannels);

fix_size = 20;      % This is the side length of the fixation cross

% Create a rect for the fixation cross
fixRect = [scr_centre(1) - fix_size/2    scr_centre(2) - fix_size/2   scr_centre(1) + fix_size/2   scr_centre(2) + fix_size/2];

% Create an offscreen window, and draw the fixation cross in it.
fixationTex = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 fix_size fix_size]);
Screen('DrawLine', fixationTex, white, 0, fix_size/2, fix_size, fix_size/2, 2);
Screen('DrawLine', fixationTex, white, fix_size/2, 0, fix_size/2, fix_size, 2);


RestrictKeysForKbCheck([KbName(topKeyName), KbName(bottomKeyName)]);   % Only accept keypresses from the response keys

DATA.trialTimeouts = 0;

sessionPay = 0;

trials_since_break = 0;

accSummary = 0;
accuracySummary = 0;
numTrialsSummary = 0;

WaitSecs(initialPause);

for trial = 1 : exptTrials
    
    trials_since_break = trials_since_break + 1;
    
    
    if exptPhase == 0
        FB_duration = feedbackDuration(1);
    else
        if exptTrialSequence(trial, 7) == 1 && exptSession == 1    % If block 1, session 1
            FB_duration = feedbackDuration(2);
        else
            FB_duration = feedbackDuration(3);
        end
    end
    
    if trial <= trialsPerBlock/2
        softTimeoutDuration = softTimeoutDurationEarly * 1000;
    else
        softTimeoutDuration = softTimeoutDurationLate * 1000;
    end
    
    fixationDuration = randi([minFixationDuration, maxFixationDuration]) / 1000;
    
    
    cueToneArrayToPlay(:, :) = cueToneArray(exptTrialSequence(trial, 1), :, :);    % FillBuffer requires a channels * samples array. So create a subarray from the giant one that strips off the identifier, to give a samples * channels matrix...

    noiseVolume = round(((highestTargetVolume - lowestTargetVolume) * rand + lowestTargetVolume), 3);   % Generate random number between limits and round to 3 dp
    noiseArrayToPlay(:, :) = noiseVolume * noiseArray(exptTrialSequence(trial, 2), :, :);    % FillBuffer requires a channels * samples array. So create a subarray from the giant one that strips off the identifier, to give a samples * channels matrix...
    
    soundArrayToPlay = vertcat(cueToneArrayToPlay, noiseArrayToPlay);
    
    PsychPortAudio('FillBuffer', soundPAhandle, soundArrayToPlay');   % ...then take the transpose of that matrix 

    
    Screen(MainWindow, 'Flip');     % Clear screen
    
    Screen('DrawTexture', MainWindow, fixationTex, [], fixRect);
    
    Screen(MainWindow, 'Flip');     % Present fixation cross
    
    WaitSecs(fixationDuration);

    rtStart = GetSecs;

    PsychPortAudio('Start', soundPAhandle);
    PsychPortAudio('Stop', soundPAhandle, 1);

    timeout = 0;
    
    [keyCode, rtEnd, timeout] = accKbWait(rtStart, timeoutDuration);
    
    keyCodePressed = find(keyCode, 1, 'first');
    keyPressed = KbName(keyCodePressed);   % Get the name of the key that was pressed
    
    rt = 1000 * (rtEnd - rtStart);      % Response time in ms
    
    correct = 0;
    
    softTimeoutTrial = 0;
    trialPay = 0;
    
    if timeout == 1      % No key pressed (i.e. timeout)
        trialPay = 0;
        fbStr = 'TOO SLOW';
        fbStr2 = 'Please try to respond faster';
    else
        
        
%         if (keyPressed == '6^' && exptTrialSequence(trial, 5) == 1) || (keyPressed == 'b' && exptTrialSequence(trial, 5) == 2)
        if (strcmp(keyPressed, topKeyName) && exptTrialSequence(trial, 5) == 1) || (strcmp(keyPressed, bottomKeyName) && exptTrialSequence(trial, 5) == 2)
            correct = 1;
        end
        
        
        if exptPhase == 0       % If this is practice
            
            if correct
                fbStr = 'CORRECT';
            else
                fbStr = 'ERROR';
            end
               
            fbStr2 = '';
            
        else       % If this is NOT practice
            
            if rt > softTimeoutDuration      % If RT is greater than the "soft" timeout limit, don't get reward (but also don't get explicit timeout feedback)
                softTimeoutTrial = 1;
            end            
            
            
            if correct

                if softTimeoutTrial == 1
                    trialPay = 0;
                    fbStr = 'Too slow';
                else
                    trialPay = winMultiplier(exptTrialSequence(trial, 1));
                    fbStr = '';
                end
                
            else
                
                trialPay = loseMultiplier(exptTrialSequence(trial, 1));
                fbStr = 'ERROR';
                
            end
            
            if trialPay < 0
                fbStrTemp = ['Lose ', num2str(abs(trialPay)), ' '];
            else
                fbStrTemp = ['+', num2str(trialPay), ' '];
            end
                
            if abs(trialPay) == 1
                fbStr2 = [fbStrTemp, 'point'];
            else
                fbStr2 = [fbStrTemp, 'points'];
            end
            
            sessionPay = sessionPay + trialPay;
            
            
            
            Screen('TextSize', MainWindow, 34);
            if sessionPay < 0
                DrawFormattedText(MainWindow, ['-', separatethousands(-sessionPay, ','), ' points total'], 'center', 760, white);
            else
                DrawFormattedText(MainWindow, [separatethousands(sessionPay, ','), ' points total'], 'center', 760, white);
            end

        end    % If exptPhase == 1
        
    end          % If timeout
    
    
    accuracySummary = accuracySummary + correct;
    numTrialsSummary = numTrialsSummary + 1;
    
    Screen('TextSize', MainWindow, 64);
    if exptPhase == 0
        DrawFormattedText(MainWindow, fbStr, 'center', 'center', white);
    else
        DrawFormattedText(MainWindow, fbStr, 'center', 350, white);
    end
    
    Screen('TextSize', MainWindow, 54);
    DrawFormattedText(MainWindow, fbStr2, 'center', 'center', yellow);
    
    Screen('Flip', MainWindow);
    
    WaitSecs(FB_duration);
    
    
    Screen('Flip', MainWindow);
    WaitSecs(itiDuration);
    
    
    
    if exptPhase == 0
        DATA.practrialInfo(trial,:) = [exptSession, exptTrialSequence(trial, :), timeout, correct, rt, noiseVolume, fixationDuration];
        accSummary = round(100 * accuracySummary / numTrialsSummary, 1);

    
    else
        DATA.expttrialInfo(trial,:) = [exptSession, exptTrialSequence(trial, :), trials_since_break, timeout, softTimeoutTrial, correct, rt, trialPay, sessionPay, noiseVolume, fixationDuration, softTimeoutDuration];
        
        DATA.trialTimeouts = DATA.trialTimeouts + timeout;
        DATA.sessionPayment = sessionPay;
        
        
        if (mod(trial, exptTrialsBeforeBreak) == 0 && trial ~= exptTrials);
            save(datafilename, 'DATA');
            
            accSummary = round(100 * accuracySummary / numTrialsSummary, 1);
            
            longBreak = 0;
            if exptTrialSequence(trial, 7) == totalBlocks / 2    % If half-way through the blocks, have a long break
                longBreak = 1;
            end
            
            take_a_break(breakDuration, initialPause, sessionPay, accSummary, longBreak);
            RestrictKeysForKbCheck([KbName(topKeyName), KbName(bottomKeyName)]);   % Only accept keypresses from the response keys

            accuracySummary = 0;
            numTrialsSummary = 0;
            trials_since_break = 0;
        end
        
    end
    
    save(datafilename, 'DATA');
end


Screen('Close', fixationTex);
PsychPortAudio('Close', soundPAhandle);


end





function take_a_break(breakDur, pauseDur, totalPointsSoFar, accSummary, longBreak)

global MainWindow white scr_centre
global topKeyName bottomKeyName

if longBreak

    DrawFormattedText(MainWindow, ['Accuracy since previous break = ', num2str(accSummary),'% correct\n\nTotal so far = ', separatethousands(totalPointsSoFar, ','), ' points'], 'center', scr_centre(2) - 150, white, [], [],[], 1.1);
    DrawFormattedText(MainWindow, 'Please find the experimenter', 'center', scr_centre(2) + 100, white, 50, [],[], 1.1);

    Screen(MainWindow, 'Flip');
    
    RestrictKeysForKbCheck(KbName('8'));   % Only accept numeric keypad 8
    KbWait([], 2);
    RestrictKeysForKbCheck([]); % Re-enable all keys   
    
    
else
    
    [~, ny, ~] = DrawFormattedText(MainWindow, ['Time for a break\n\nSit back, relax for a moment! You will be able to carry on in ', num2str(breakDur),' seconds\n\nRemember that you should be trying to respond to the noise as accurately and as quickly as possible!'], 'center', 150, white, 60, [], [], 1.1);

    DrawFormattedText(MainWindow, ['Accuracy since previous break = ', num2str(accSummary),'% correct\n\nTotal so far = ', separatethousands(totalPointsSoFar, ','), ' points'], 'center', ny + 150, white, [], [],[], 1.1);

    Screen(MainWindow, 'Flip');
    WaitSecs(breakDur);

end

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar

DrawFormattedText(MainWindow, ['Please put your chin back in the chinrest,\nplace your index fingers on the ', upper(topKeyName), ' and ', upper(bottomKeyName), ' keys\nand press the spacebar when you are ready to continue'], 'center', 'center' , white, [], [], [], 1.1);
Screen(MainWindow, 'Flip');

KbWait([], 2);
Screen(MainWindow, 'Flip');

WaitSecs(pauseDur);

end
