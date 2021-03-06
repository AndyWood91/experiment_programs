function showInstructions2

global MainWindow
global bColour white screenWidth
global cueBalance

instrWindow = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextFont', instrWindow, 'Segoe UI');
Screen('TextStyle', instrWindow, 0);

yellow = [255, 255, 0];

if cueBalance == 1
    rewardString = 'BIRD';
else
    rewardString = 'CAR';
end


instrString = 'Great job!\n\nFrom now on you can win points for correct responses.\n\nThis is important because you will receive money at the end of the experiment, based on how many points you have earned. Most participants are able to earn between $7 and $12.';
instrString3 = ['If the stream of images includes a picture of a ', rewardString,', you will be able to WIN 50 POINTS on that trial if you respond correctly to the target.\n\nHowever, note that the ', rewardString,' will never be the target stimulus, so you will do better at the task if you try to ignore it.\n\nOn all other trials (when the stream doesn''t contain a picture of a ', rewardString,'), you will not receive any points for making a correct response.'];
instrString4 = 'Remember, at the end of the experiment, the number of points that you have earned will be used to calculate how much you get paid. So you should try to respond as accurately as you can, in order to earn as many points as possible.\n\nPlease let the experimenter know when you are ready to begin the task.';

Screen('TextSize', instrWindow, 40);

DrawFormattedText(instrWindow, instrString, 150, 150, white, 90, [], [], 1.3);
Screen('DrawTexture', MainWindow, instrWindow);

Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('FillRect', instrWindow, bColour);
DrawFormattedText(instrWindow, instrString3, 150, 150, white, 90, [], [], 1.3);
Screen('DrawTexture', MainWindow, instrWindow);
Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('FillRect', instrWindow, bColour);
DrawFormattedText(instrWindow, instrString4, 150, 150, yellow, 90, [], [], 1.3);
Screen('DrawTexture', MainWindow, instrWindow);
Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Flip', MainWindow);

Screen('Close', instrWindow);


end