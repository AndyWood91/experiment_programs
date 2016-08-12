clc, clear all
rng('shuffle')

% variables modificables
numBlocks1A = 6;
numBlocks1B = 7;
numBlocks2 = 4;
interTrialInterval = 1;     % <--- 1
fixationInterval = 0.5;     % <--- 0.5
feedbackInterval = 3;       % <--- 3

% colect participant info
DATA.subject = input('Subject number ---> ');
% DATA.SOA = input('SOA? 1=250 / 2=1000 ---> '); % removed for this exp.
DATA.SOA = 250; % always this
DATA.group = input('Group/Sprites? (1/2) ---> ');
% if DATA.SOA==2; DATA.SOA=1000; else; DATA.SOA=250; end % removed for this exp.
DATA.age = input('Subject age ---> ');
DATA.sex = input('Subject gender (M/F) ---> ', 's');
DATA.hand = input('Subject hand (R/L) ---> ','s');
DATA.start_time = datestr(now,0);


% setup cogent
config_display(1,2,[0 0 0],[1 1 1],'Helvetica',16,4,0); %the change is for lunching the program in full screen.
config_sound;
config_keyboard(100,1,'nonexclusive');
start_cogent;

% hacer imagénes y secuencia
if DATA.group==1
    makeSprites1
else
    makeSprites2
end
[sequence, DATA.cues, DATA.outcomes] = makeSequence(DATA.SOA, numBlocks1A, numBlocks1B, numBlocks2);

numPretrainingTrials = sum(sequence(:,1) <= numBlocks1A);
DATA.trials = [];

% entrenamiento
for trial = 1:size(sequence, 1)
    
    trial
    
    % instrucciones
    if trial == 1;
        instrSet = 1;
        showInstructions(instrSet);
    elseif trial == numPretrainingTrials+1;
        instrSet = 2;
        showInstructions(instrSet);
    end
    
    % presentar ensayos
    if sequence(trial,4)==0 % si es un ensayo sin dot...
        responseVariables = trialCat(sequence(trial,:), interTrialInterval, fixationInterval, feedbackInterval);
    else % si es un ensayo con dot...
        responseVariables = trialDot(sequence(trial,:), interTrialInterval, fixationInterval, feedbackInterval);
    end

    % guardar datos
    DATA.trials = [DATA.trials; trial, sequence(trial,:), responseVariables];
    save(strcat('y054e_subj', (int2str(DATA.subject))),'DATA');

end



% % <--------------------------- IF YOU WANT TO REMOVE JUDGMENTS, REMOVE LINES FROM HERE...
% cgflip(0, 0, 0); pause(2)
% loadpict('instr13.jpg', 1);
% drawpict(1);
% waitkeydown(inf);
% cgflip(0,0,0); pause(1)
% judgmentStage
% save(strcat('y054e_subj', (int2str(DATA.subject))),'DATA');
% % <--------------------------- ... TO HERE



% end screen
cgflip(0,0,0); pause(2)
cgdrawsprite(1006,0,0); cgflip (0, 0, 0)
waitkeydown(inf, 52); % wait until ESC pressed
stop_cogent