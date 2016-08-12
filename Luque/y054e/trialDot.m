function responseVars = trialDot(trialVector, interTrialInterval, fixationInterval, feedbackInterval)

    % pre-trial
     cgflip(0, 0, 0); pause(interTrialInterval)

    % left/right arrows
    cgdrawsprite(3003,-15,0,25,25); 
    cgdrawsprite(3004,15,0,25,25);
    cgflip(0, 0, 0);
    pause(fixationInterval);
            
    % draw fixation, boxes, and stimuli
    cgdrawsprite(1002,0,0);
    cgdrawsprite(3003,-15,0,25,25); 
    cgdrawsprite(3004,15,0,25,25);
    cgdrawsprite(trialVector(7),-195,0) % left stimulus
    cgdrawsprite(trialVector(8), 195,0) % right stimulus
    cgflip(0, 0, 0)
    pause(trialVector(6)/1000) % DEPENDE DEL SOA

	% draw fixation, boxes, stimuli, and dot probe
	cgdrawsprite(1002,0,0);
    cgdrawsprite(3003,-15,0,25,25); 
    cgdrawsprite(3004,15,0,25,25);
    cgdrawsprite(trialVector(7),-195,0) % left stimulus
    cgdrawsprite(trialVector(8), 195,0) % right stimulus
	if trialVector(4) == 1 % dot on the left
        cgdrawsprite(301,-195,0)
	elseif trialVector(4) == 2 % dot on the right
        cgdrawsprite(301,195,0)
    end
	cgflip(0, 0, 0)
	imgOnTime = time;
    
	% response dot probe
	[RespKeyDot, RTDot, AccuracyDot] = responseDot(trialVector(4), imgOnTime);
    
    % feedback if incorrect
    if AccuracyDot ~= 1 
        cgdrawsprite(1002,0,0); cgdrawsprite(1001,0,0)
        cgdrawsprite(trialVector(7),-195,0) % left stimulus
        cgdrawsprite(trialVector(8), 195,0) % right stimulus
        cgdrawsprite(2003,0,0)
        cgflip(0, 0, 0)
        pause(feedbackInterval)
    end
    
    responseVars = [RespKeyDot AccuracyDot RTDot 999999 999999 999999]

end