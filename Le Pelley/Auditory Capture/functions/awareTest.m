function awareTest()

global MainWindow scr_centre DATA datafilename
global cueToneArray cueToneArrayLength toneFreq
global white black gray yellow
global bigMultiplier smallMultiplier
global centOrCents
global numAudioChannels


awareTest_iti = 1;

numToneReps = 5;
pauseBetweenTones = 0.5; 

cueTypes = 4;       % Number of cue types (high-reward L, high-reward R, low-reward L, low-reward R)


toneButtonRect = [0, 0, 350, 130];

buttonWin = Screen('OpenOffscreenWindow', MainWindow, black, toneButtonRect);
Screen('TextSize', buttonWin, 32);
Screen('TextStyle', buttonWin, 1);

DrawFormattedText(buttonWin, 'Click here\nto hear beep', 'center', 'center', white, [], [], [], 1.1);
Screen('FrameRect', buttonWin, white, [], 2);




valButtonWidth = 300;
valButtonHeight = 130;
valButtonTop = 550;
valButtonDisplacement = 230;


confButtons = 5;
confButtonWidth = 100;
confButtonHeight = 100;
confButtonTop = 840;
confButtonBetween = 150;


valButtonWin = zeros(2,1);
for i = 1 : 2
    valButtonWin(i) = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 valButtonWidth valButtonHeight]);
    Screen('FillRect', valButtonWin(i), gray);
    Screen('TextSize', valButtonWin(i), 40);
    Screen('TextFont', valButtonWin(i), 'Calibri');
end


DrawFormattedText(valButtonWin(1), [num2str(smallMultiplier), ' ', centOrCents], 'center', 'center', yellow);
DrawFormattedText(valButtonWin(2), [num2str(bigMultiplier), ' points'], 'center', 'center', yellow);

valButtonRect = zeros(2,4);
valButtonRect(1,:) = [scr_centre(1) - valButtonWidth/2 - valButtonDisplacement   valButtonTop   scr_centre(1) + valButtonWidth/2 - valButtonDisplacement  valButtonTop + valButtonHeight];
valButtonRect(2,:) = [scr_centre(1) - valButtonWidth/2 + valButtonDisplacement   valButtonTop   scr_centre(1) + valButtonWidth/2 + valButtonDisplacement  valButtonTop + valButtonHeight];


confButtonWin = zeros(confButtons,1);
confButtonRect = zeros(confButtons, 4);
for i = 1 : confButtons
    confButtonWin(i) = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 confButtonWidth confButtonHeight]);
    Screen('FillRect', confButtonWin(i), gray);
    Screen('TextFont', confButtonWin(i), 'Arial');
    Screen('TextSize', confButtonWin(i), 46);
    DrawFormattedText(confButtonWin(i), num2str(i), 'center', 'center', white);
    
    confButtonRect(i,:) = [scr_centre(1) + confButtonWidth * (i - 1 - confButtons/2) + confButtonBetween * (i-1 - (confButtons - 1)/2)    confButtonTop    scr_centre(1) + confButtonWidth * (i - 1 - confButtons/2) + confButtonBetween * (i-1 - (confButtons - 1)/2) + confButtonWidth    confButtonTop + confButtonHeight];
    
end

instructStr1 = ['Click below to hear a beep (you will hear it ', num2str(numToneReps), ' times)'];
instructStr2a = 'What amount did you win for correct responses on trials\nwith this type of beep?';
instructStr2c = 'Use the mouse to select the appropriate amount\n(if you want to hear the beep again, you can click on the button above)';
instructStr3 = 'How confident are you of this choice?';

instructStr4 = 'Not at all\nconfident';
instructStr5 = 'Very\nconfident';

instructStr4Win = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instructStr4Win, 30);
Screen('TextFont', instructStr4Win, 'Arial');
[~,~,instr4boundsRect] = DrawFormattedText(instructStr4Win, instructStr4, 'center', 'center', white, [], [], [], 1.3);
instr4width = instr4boundsRect(3) -  instr4boundsRect(1);
instr4height = instr4boundsRect(4) -  instr4boundsRect(2);

instructStr5Win = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instructStr5Win, 30);
Screen('TextFont', instructStr5Win, 'Arial');
[~,~,instr5boundsRect] = DrawFormattedText(instructStr5Win, instructStr5, 'center', 'center', white, [], [], [], 1.3);
instr5width = instr5boundsRect(3) -  instr5boundsRect(1);
instr5height = instr5boundsRect(4) -  instr5boundsRect(2);



DATA.awareTestInfo = zeros(cueTypes, 4);



% Create and shuffle the test trial types

trialOrder = 1:cueTypes;
trialOrder = trialOrder(randperm(length(trialOrder)));


soundPAhandle = PsychPortAudio('Open', [], 1, [], toneFreq, numAudioChannels);

cueToneArrayToPlay = zeros(cueToneArrayLength, numAudioChannels);

ShowCursor('Arrow');


for trial = 1 : cueTypes
    
    [~, ny, ~] = DrawFormattedText(MainWindow, instructStr1, 'center', 80, white);
    
    MWtoneButtonRect = CenterRectOnPoint(toneButtonRect, scr_centre(1), ny + toneButtonRect(4)/2 + 60);

    Screen('DrawTexture', MainWindow, buttonWin, [], MWtoneButtonRect);
    
    cueToneArrayToPlay(:, :) = cueToneArray(trialOrder(trial), :, :);    % FillBuffer requires a channels * samples array. So create a subarray from the giant one that strips off the identifier, to give a samples * channels matrix...
    PsychPortAudio('FillBuffer', soundPAhandle, cueToneArrayToPlay');   % ...then take the transpose of that matrix

    Screen('Flip', MainWindow, [], 1);
    
    instructStr2aTop = ny + toneButtonRect(4) + 140;    
    [~, ny, ~] = DrawFormattedText(MainWindow, instructStr2a, 'center', instructStr2aTop, white, [], [], [], 1.1);
    
    oldTextSize = Screen('TextSize', MainWindow, 24);
    DrawFormattedText(MainWindow, instructStr2c, 'center', ny + 80, white, [], [], [], 1.1);
    Screen('TextSize', MainWindow, oldTextSize);
    
    for i = 1 : 2
        Screen('DrawTexture', MainWindow, valButtonWin(i), [], valButtonRect(i,:));
    end

    
    
    heardTone = 0;
    
    while heardTone == 0
        [~, x, y, ~] = GetClicks(MainWindow, 0);
        if IsInRect (x, y, MWtoneButtonRect)
            heardTone = 1;
            for ii = 1 : numToneReps
                PsychPortAudio('Start', soundPAhandle);
                PsychPortAudio('Stop', soundPAhandle, 1);
                WaitSecs(pauseBetweenTones);
            end
        end
    end
    
    Screen('Flip', MainWindow, [], 1);

    
    for i = 1 : confButtons
        Screen('DrawTexture', MainWindow, confButtonWin(i), [], confButtonRect(i,:));
    end
    
    rate_instr_below = 30;
    Screen('DrawTexture', MainWindow, instructStr4Win, instr4boundsRect, [confButtonRect(1,1) + confButtonWidth/2 - instr4width/2     confButtonTop + confButtonHeight + rate_instr_below   confButtonRect(1,1) + confButtonWidth/2 + instr4width/2    confButtonTop + confButtonHeight + rate_instr_below + instr4height]);
    Screen('DrawTexture', MainWindow, instructStr5Win, instr5boundsRect, [confButtonRect(5,1) + confButtonWidth/2 - instr5width/2     confButtonTop + confButtonHeight + rate_instr_below   confButtonRect(5,1) + confButtonWidth/2 + instr5width/2    confButtonTop + confButtonHeight + rate_instr_below + instr5height]);
    
    
    Screen('FillRect', MainWindow, black, [0, MWtoneButtonRect(4) + 20, 1920, valButtonTop - 20]);    % Cover up instr2
    
    
    clickedValButton = 0;
    while clickedValButton == 0
        [~, x, y, ~] = GetClicks(MainWindow, 0);
        if IsInRect (x, y, MWtoneButtonRect)
            for ii = 1 : numToneReps
                PsychPortAudio('Start', soundPAhandle);
                PsychPortAudio('Stop', soundPAhandle, 1);
                WaitSecs(pauseBetweenTones);
            end
        else
            
            for i = 1 : 2
                if x > valButtonRect(i,1) && x < valButtonRect(i,3) && y > valButtonRect(i,2) && y < valButtonRect(i,4)
                    clickedValButton = i;
                end
            end
        end
    end
    
    if clickedValButton == 1
        Screen('FillRect', MainWindow, black, valButtonRect(2,:));	% Hide button that hasn't been clicked
    else
        Screen('FillRect', MainWindow, black, valButtonRect(1,:));
    end
    
    
    DrawFormattedText(MainWindow, instructStr3, 'center', confButtonTop - 40, white);
    
    
    Screen('Flip', MainWindow);
    
    clickedConfButton = 0;
    while clickedConfButton == 0
        [~, x, y, ~] = GetClicks(MainWindow, 0);
        if IsInRect (x, y, MWtoneButtonRect)
            for ii = 1 : numToneReps
                PsychPortAudio('Start', soundPAhandle);
                PsychPortAudio('Stop', soundPAhandle, 1);
                WaitSecs(pauseBetweenTones);
            end
        else
            for i = 1 : confButtons
                if x > confButtonRect(i,1) && x < confButtonRect(i,3) && y > confButtonRect(i,2) && y < confButtonRect(i,4)
                    clickedConfButton = i;
                end
            end
        end
    end
    
    
    DATA.awareTestInfo(trial,:) = [trial, trialOrder(trial), clickedValButton, clickedConfButton];
    
    Screen('Flip', MainWindow);
    
    WaitSecs(awareTest_iti);
end

save(datafilename, 'DATA');

for i = 1:2
    Screen('Close', valButtonWin(i));
end
for i = 1:confButtons
    Screen('Close', confButtonWin(i));
end

Screen('Close', instructStr4Win);
Screen('Close', instructStr5Win);
PsychPortAudio('Close', soundPAhandle);

end