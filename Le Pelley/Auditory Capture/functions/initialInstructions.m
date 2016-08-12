
function initialInstructions()

global MainWindow white
global topKeyName bottomKeyName

instructStr1 = 'On each trial a cross will appear, and you should keep your eyes fixed on this cross whenever it is on the screen.\n\nShortly after the cross appears, you will hear a beep and a ''rattle'' in quick succession. Your task is to respond to whether the rattle came out of one of the TOP speakers, or one of the BOTTOM speakers.';
instructStr2 = ['If you think that the rattle came from one of the top speakers, you should press the ', upper(topKeyName), ' key. If the rattle came from one of the bottom speakers, you should press the ', upper(bottomKeyName), ' key.\n\nThe location of the beep will not provide any information about where the rattle comes from, so you should ignore it.'];
instructStr3 = 'You should respond to the rattle as quickly and as accurately as possible. After each block of trials you will be told how accurate you were - you should try to achieve AT LEAST 85% correct responses.';

show_Instructions(1, instructStr1);
show_Instructions(2, instructStr2);
show_Instructions(3, instructStr3);

DrawFormattedText(MainWindow, 'Tell the experimenter when you are ready to begin', 'center', 'center' , white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('8'));   % Only accept numeric keypad 8
KbWait([], 2);
Screen(MainWindow, 'Flip');
RestrictKeysForKbCheck([]); % Re-enable all keys

end

function show_Instructions(instrTrial, insStr)

global MainWindow scr_centre black white yellow gray
global cueToneArray cueToneArrayLength toneFreq
global noiseArray noiseArrayLength
global lowestTargetVolume highestTargetVolume
global numAudioChannels

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar


oldTextSize = Screen('TextSize', MainWindow, 44);
oldTextStyle = Screen('TextStyle', MainWindow, 1);

textTop = 100;
characterWrap = 65;
DrawFormattedText(MainWindow, insStr, 120, textTop, white, characterWrap, [], [], 1.1);


if instrTrial == 1
    buttonRect = [0, 0, 250, 130];
    horizOffset = 400;
    toneButtonRect = CenterRectOnPoint(buttonRect, scr_centre(1) - horizOffset, 630);
    noiseTopButtonRect = CenterRectOnPoint(buttonRect, scr_centre(1), 630);
    noiseBottomButtonRect = CenterRectOnPoint(buttonRect, scr_centre(1) + horizOffset, 630);
    bothButtonRect = CenterRectOnPoint(buttonRect, scr_centre(1), 840);

    
    buttonWin = Screen('OpenOffscreenWindow', MainWindow, black, buttonRect);
    Screen('TextSize', buttonWin, 44);
    Screen('TextStyle', buttonWin, 1);

    
    DrawFormattedText(buttonWin, 'BEEP', 'center', 'center', yellow);
    Screen('FrameRect', buttonWin, yellow, [], 2);
    Screen('DrawTexture', MainWindow, buttonWin, [], toneButtonRect);

    Screen('FillRect', buttonWin, black);
    
    DrawFormattedText(buttonWin, 'RATTLE\nTOP', 'center', 'center', yellow);
    Screen('FrameRect', buttonWin, yellow, [], 2);
    Screen('DrawTexture', MainWindow, buttonWin, [], noiseTopButtonRect);
    
    Screen('FillRect', buttonWin, black);
    
    DrawFormattedText(buttonWin, 'RATTLE\nBOTTOM', 'center', 'center', yellow);
    Screen('FrameRect', buttonWin, yellow, [], 2);
    Screen('DrawTexture', MainWindow, buttonWin, [], noiseBottomButtonRect);
    
    Screen('FillRect', buttonWin, black);
    
    DrawFormattedText(buttonWin, 'BEEP &\nRATTLE', 'center', 'center', yellow);
    Screen('FrameRect', buttonWin, yellow, [], 2);
    Screen('DrawTexture', MainWindow, buttonWin, [], bothButtonRect);
    
    Screen('Close', buttonWin);
    
    
    buttonRect = [0, 0, 800, 60];
    continueButtonRect = CenterRectOnPoint(buttonRect, scr_centre(1), 1000);

    continueButtonWin = Screen('OpenOffscreenWindow', MainWindow, gray, buttonRect);
    Screen('TextSize', continueButtonWin, 44);
    Screen('TextStyle', continueButtonWin, 1);

    DrawFormattedText(continueButtonWin, 'Click here to continue', 'center', 'center', white);
    Screen('FrameRect', continueButtonWin, white, [], 2);

    
    ShowCursor('Arrow');
    Screen(MainWindow, 'Flip', [], 1);

    cueToneArrayToPlay = zeros(cueToneArrayLength, numAudioChannels);
    noiseArrayToPlay = zeros(noiseArrayLength, numAudioChannels);
    
    soundPAhandle = PsychPortAudio('Open', [], 1, [], toneFreq, numAudioChannels);

    continueButtonVisible = 0;
    clickedContinueButton = 0;
    timesClickedTone = 0;
    timesClickedNoiseTop = 0;
    timesClickedNoiseBottom = 0;
    timesClickedNoiseBoth = 0;
    
    while clickedContinueButton == 0
        
        [~, x, y, ~] = GetClicks(MainWindow, 0);
        if IsInRect (x, y, toneButtonRect)
            timesClickedTone = timesClickedTone + 1;
            
            soundID = 5 + mod(timesClickedTone, 2);  % Alternate playing the left and right mid tone (IDs 5 and 6)
            
            cueToneArrayToPlay(:, :) = cueToneArray(soundID, :, :);    % FillBuffer requires a channels * samples array. So create a subarray from the giant one that strips off the identifier, to give a samples * channels matrix...
            PsychPortAudio('FillBuffer', soundPAhandle, cueToneArrayToPlay');   % ...then take the transpose of that matrix 
            
            PsychPortAudio('Start', soundPAhandle);
            PsychPortAudio('Stop', soundPAhandle, 1);

        elseif IsInRect (x, y, noiseTopButtonRect)
            timesClickedNoiseTop = timesClickedNoiseTop + 1;
            
            soundID = 1 + mod(timesClickedNoiseTop, 2);  % Alternate playing the top-left and top-right noise (IDs 1 and 2)
            noiseVolume = round(((highestTargetVolume - lowestTargetVolume) * rand + lowestTargetVolume), 3);   % Generate random number between limits and round to 3 dp
            noiseArrayToPlay(:, :) = noiseVolume * noiseArray(soundID, :, :);    % FillBuffer requires a channels * samples array. So create a subarray from the giant one that strips off the identifier, to give a samples * channels matrix...
            
            PsychPortAudio('FillBuffer', soundPAhandle, noiseArrayToPlay');   % ...then take the transpose of that matrix
            
            PsychPortAudio('Start', soundPAhandle);
            PsychPortAudio('Stop', soundPAhandle, 1);

        
        elseif IsInRect (x, y, noiseBottomButtonRect)
            timesClickedNoiseBottom = timesClickedNoiseBottom + 1;
            
            soundID = 3 + mod(timesClickedNoiseBottom, 2);  % Alternate playing the bottom-left and bottom-right noise (IDs 3 and 4)
            noiseVolume = round(((highestTargetVolume - lowestTargetVolume) * rand + lowestTargetVolume), 3);   % Generate random number between limits and round to 3 dp
            noiseArrayToPlay(:, :) = noiseVolume * noiseArray(soundID, :, :);    % FillBuffer requires a channels * samples array. So create a subarray from the giant one that strips off the identifier, to give a samples * channels matrix...
            
            PsychPortAudio('FillBuffer', soundPAhandle, noiseArrayToPlay');   % ...then take the transpose of that matrix
            
            PsychPortAudio('Start', soundPAhandle);
            PsychPortAudio('Stop', soundPAhandle, 1);

        elseif IsInRect (x, y, bothButtonRect)
            timesClickedNoiseBoth = timesClickedNoiseBoth + 1;
            
            toneID = 4 + randi(2);      % Pick a random combination of tone and noise
            noiseID = randi(4);
            
            cueToneArrayToPlay(:, :) = cueToneArray(toneID, :, :);    % FillBuffer requires a channels * samples array. So create a subarray from the giant one that strips off the identifier, to give a samples * channels matrix...
            
            noiseVolume = round(((highestTargetVolume - lowestTargetVolume) * rand + lowestTargetVolume), 3);   % Generate random number between limits and round to 3 dp
            noiseArrayToPlay(:, :) = noiseVolume * noiseArray(noiseID, :, :);    % FillBuffer requires a channels * samples array. So create a subarray from the giant one that strips off the identifier, to give a samples * channels matrix...
            
            soundArrayToPlay = vertcat(cueToneArrayToPlay, noiseArrayToPlay);
            
            PsychPortAudio('FillBuffer', soundPAhandle, soundArrayToPlay');   % ...then take the transpose of that matrix
            
            PsychPortAudio('Start', soundPAhandle);
            PsychPortAudio('Stop', soundPAhandle, 1);
            
        end
        
        if timesClickedTone > 0 && timesClickedNoiseTop > 0 && timesClickedNoiseBottom > 0 && timesClickedNoiseBoth > 0 && continueButtonVisible == 0
            Screen('DrawTexture', MainWindow, continueButtonWin, [], continueButtonRect);
            Screen('Close', continueButtonWin);
            Screen(MainWindow, 'Flip');
            continueButtonVisible = 1;
        end
        
        if IsInRect (x, y, continueButtonRect) && continueButtonVisible == 1
            clickedContinueButton = 1;
            Screen(MainWindow, 'Flip');
            PsychPortAudio('Close', soundPAhandle);
        end
        
    end

    
else
    
    HideCursor;
    Screen(MainWindow, 'Flip');
    KbWait([], 2);

end

Screen('TextSize', MainWindow, oldTextSize);
Screen('TextStyle', MainWindow, oldTextStyle);


end