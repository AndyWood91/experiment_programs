
function awareInstructions()

global bigMultiplier smallMultiplier
global centOrCents
global awareInstrPause

instructStr1 = ['The main task is now finished - it''s fine to take your chin out of the chin rest.\n\nDuring this task, the amount that you could win on each trial was determined by the type of beep that occurred on that trial. When certain types of beep occurred, you could win ', num2str(smallMultiplier), ' ', centOrCents, ', and when other types of beep occurred, you could win ', num2str(bigMultiplier), ' points.'];
instructStr1 = [instructStr1, '\n\nIn the final phase we will test whether you learned about the relationship between the type of beep and the amount that you could win.'];

if isempty(awareInstrPause)
    awareInstrPause = 0.01;   % If this hasn't been set anywhere else (it should have been) set it here
end

show_Instructions(1, instructStr1, awareInstrPause);

end


function show_Instructions(~, insStr, instrPause)

global MainWindow scr_centre white gray


oldTextSize = Screen('TextSize', MainWindow, 46);
oldTextStyle = Screen('TextStyle', MainWindow, 1);

textTop = 100;
characterWrap = 60;
DrawFormattedText(MainWindow, insStr, 120, textTop, white, characterWrap, [], [], 1.1);


Screen('Flip', MainWindow, [], 1);

contButtonWidth = 1000;
contButtonHeight = 100;
contButtonTop = 880;

contButtonWin = Screen('OpenOffscreenWindow', MainWindow, gray, [0 0 contButtonWidth contButtonHeight]);
Screen('TextSize', contButtonWin, 38);
Screen('TextFont', contButtonWin, 'Arial');
DrawFormattedText(contButtonWin, 'Click here using the mouse to continue', 'center', 'center', white);

contButtonRect = [scr_centre(1) - contButtonWidth/2   contButtonTop  scr_centre(1) + contButtonWidth/2  contButtonTop + contButtonHeight];
Screen('DrawTexture', MainWindow, contButtonWin, [], contButtonRect);


WaitSecs(instrPause);

Screen('Flip', MainWindow);
ShowCursor('Arrow');


clickedContButton = 0;
while clickedContButton == 0
    [~, x, y, ~] = GetClicks(MainWindow, 0);

    if x > contButtonRect(1) && x < contButtonRect(3) && y > contButtonRect(2) && y < contButtonRect(4)
        clickedContButton = 1;
    end

end


Screen('TextSize', MainWindow, oldTextSize);
Screen('TextStyle', MainWindow, oldTextStyle);

Screen('Close', contButtonWin);

end