
function exptInstructions

global MainWindow white
global bigMultiplier smallMultiplier lossAmount
global centOrCents

instructStr1 = 'The rest of this experiment is similar to the trials you have just completed. On each trial, you should respond as quickly and accurately as possible, according to whether the rattle came from one of the TOP speakers or one of the BOTTOM speakers.';

if lossAmount == 1
    tempString = 'point';
else
    tempString = 'points';
end

instructStr2 = ['From now on, you will be able to earn money for correct responses. On each trial you will earn either ', num2str(smallMultiplier), ' ', centOrCents, ', or ', num2str(bigMultiplier), ' points.\n\nAt the end of the experiment the number of points that you have earned will be used to calculate your total reward payment.\n\nMost participants are able to earn between $10 and $15 in this experiment.'];

instructStr3 = ['You should respond as quickly as you can - if you do not respond quickly enough, you will receive no points.\n\nIt is also important that you respond accurately. If you make an error, you will LOSE ', num2str(lossAmount), ' ', tempString, '.\n\nAfter every block of trials, you will be told how accurate you were in that block - you should try to achieve AT LEAST 85% correct responses.'];
instructStr4 = 'After each trial you will be told how many points you won on that trial, and your total points earned so far.\n\nRemember that the more points you earn, the more money you will receive at the end of the experiment!';

show_Instructions(1, instructStr1, .1);
show_Instructions(2, instructStr2, .1);
show_Instructions(3, instructStr3, .1);
show_Instructions(4, instructStr4, .1);

DrawFormattedText(MainWindow, 'Please tell the experimenter when you are ready to begin', 'center', 'center' , white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('8'));   % Only accept numeric keypad 8
KbWait([], 2);
Screen(MainWindow, 'Flip');
RestrictKeysForKbCheck([]); % Re-enable all keys


end


function show_Instructions(~, insStr, ~)

global MainWindow scr_centre black white


oldTextSize = Screen('TextSize', MainWindow, 46);
oldTextStyle = Screen('TextStyle', MainWindow, 1);

textTop = 100;
characterWrap = 60;
DrawFormattedText(MainWindow, insStr, 120, textTop, white, characterWrap, [], [], 1.1);

Screen('Flip', MainWindow, []);

Screen('TextSize', MainWindow, 34);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);


Screen('TextSize', MainWindow, oldTextSize);
Screen('TextStyle', MainWindow, oldTextStyle);

end