
function exptInstructions

global MainWindow white
global bigMultiplier smallMultiplier
global centOrCents
global instrCondition
global softTimeoutDurationLate

instructStr1 = 'The rest of this experiment is similar to the trials you have just completed. On each trial, you should move your eyes to the DIAMOND shape as quickly and directly as possible.';

instructStr2 = ['From now on, you will be able to earn money for correct responses. On each trial you will earn either 0 points, ', num2str(smallMultiplier), ' ', centOrCents, ', or ', num2str(bigMultiplier), ' points. The amount that you earn will depend on how fast and accurately you move your eyes to the diamond shape.'];

instructStr3 = ['If you take longer than ', num2str(round(softTimeoutDurationLate * 1000)), ' milliseconds to move your eyes to the diamond, you will receive no points. So you will need to move your eyes quickly!'];
instructStr4 = 'On most trials, one of the circles will be coloured. If you accidentally look at this circle before you look at the diamond, you will receive no points. So you should try to move your eyes straight to the diamond.';
instructStr5 = 'After each trial you will be told how many points you won, and your total points earned so far in this session.';
instructStr6 = 'At the end of the session the number of points that you have earned will be used to calculate your total reward payment. \n\n Most participants are able to earn between $7 and $15 in the experiment.';

show_Instructions(1, instructStr1, .1);
show_Instructions(2, instructStr2, .1);
show_Instructions(3, instructStr3, .1);

if instrCondition == 2
    show_Instructions(4, instructStr4, .1);
end

show_Instructions(5, instructStr5, .1);
show_Instructions(6, instructStr6, .1);

DrawFormattedText(MainWindow, 'Please tell the experimenter when you are ready to begin', 'center', 'center' , white);
DrawFormattedText(MainWindow, 'EXPERIMENTER: Press C to recalibrate, T to continue with test', 'center', 800, white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck([]); % Re-enable all keys


end


function show_Instructions(instrTrial, insStr, instrPause)

global MainWindow scr_centre black white yellow
global exptSession
global starting_total

x = 649;
y = 547;

exImageRect = [scr_centre(1) - x/2    scr_centre(2)-50    scr_centre(1) + x/2   scr_centre(2) + y - 50];


instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instrWin, 34);
Screen('TextStyle', instrWin, 1);

textColour = white;

[~, ~, instrBox] = DrawFormattedText(instrWin, insStr, 'left', 'center' , textColour, 60, [], [], 1.5);
instrBox_width = instrBox(3) - instrBox(1);
instrBox_height = instrBox(4) - instrBox(2);
textTop = 150;
destInstrBox = [scr_centre(1) - instrBox_width / 2   textTop   scr_centre(1) + instrBox_width / 2   textTop + instrBox_height];

Screen('DrawTexture', MainWindow, instrWin, instrBox, destInstrBox);

if instrTrial == 4
    ima1=imread('image3.jpg', 'jpg');
    Screen('PutImage', MainWindow, ima1, exImageRect); % put image on screen
end

% if instrTrial == 6 && exptSession > 1
%      totalStr = ['In the previous session, you earned $', num2str(starting_total, '%0.2f'), '.\n\nThis will be added to whatever you earn in this session.'];
%      DrawFormattedText(MainWindow, totalStr, scr_centre(1) - instrBox_width / 2, textTop + instrBox_height + 100, yellow, [], [], [], 1.5);
% end

Screen('Flip', MainWindow, []);

% WaitSecs(instrPause);
% 
% Screen('TextSize', MainWindow, 26);
% DrawFormattedText(MainWindow, 'PRESS SPACEBAR WHEN YOU HAVE READ\nAND UNDERSTOOD THESE INSTRUCTIONS', 'center', (scr_centre(2) * 2 - 200), cyan, [], [], [], 1.5);
% Screen('Flip', MainWindow);

Screen('TextSize', MainWindow, 34);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Close', instrWin);

end