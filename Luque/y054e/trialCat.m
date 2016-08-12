function responseVars = trialCat(trialVector, interTrialInterval, fixationInterval, feedbackInterval)


    % pre-trial
     cgflip(0, 0, 0); pause(interTrialInterval)

    % left/right arrows
    cgdrawsprite(3001,0,15,25,25); 
    cgdrawsprite(3002,0,-15,25,25);
    cgflip(0, 0, 0);
    pause(fixationInterval);
    
    % draw arrows, boxes, and stimuli
    cgdrawsprite(1002,0,0);
        cgdrawsprite(3001,0,15,25,25); 
    cgdrawsprite(3002,0,-15,25,25);

    cgdrawsprite(trialVector(7),-195,0) % left stimulus
    cgdrawsprite(trialVector(8), 195,0) % right stimulus
    cgflip(0, 0, 0);
    imgOnTime = time;
    
    % response category
    [RespKeyCat, RTCat, AccuracyCat] = responseCat(trialVector(9), imgOnTime);
    
    % feedback if incorrect
    if AccuracyCat ~= 1
        cgdrawsprite(1002,0,0); cgdrawsprite(1001,0,0)
        cgdrawsprite(trialVector(7),-195,0) % left stimulus
        cgdrawsprite(trialVector(8), 195,0) % right stimulus
        if trialVector(9) == 1 % si la respuesta correcta era la 1...
            cgdrawsprite(2001,0,0)
        elseif trialVector(9) == 2 % si la respuesta correcta era la 1...
            cgdrawsprite(2002,0,0)
        elseif trialVector(9) == 3 % si la respuesta correcta era la 1...
            cgdrawsprite(2003,0,0)
        elseif trialVector(9) == 4 % si la respuesta correcta era la 1...
            cgdrawsprite(2004,0,0)
        end
        cgflip(0, 0, 0)
        pause(feedbackInterval)
    end
    
    responseVars = [999999 999999 999999 RespKeyCat AccuracyCat RTCat];

end