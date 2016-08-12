function [RespKey, RT, Accuracy] = responseDot(Location, imgOnTime)

    [RespKey, RT] = waitkeydown(inf,[97 98]); %wait for left or right keypress
    
    % determine accuracy of response
    Accuracy = 0;
    if numel(RespKey) == 1 % accuracy = 0 for cases of multiple key presses
        switch RespKey
            case 97 % left
                if Location == 1; Accuracy = 1; end
            case 98 % right
                if Location == 2; Accuracy = 1; end
        end
    else
        RespKey = RespKey(1);
        RT = RT(1);
        Accuracy = 222222; %mark double key press as 222222
    end

    % compute RT
    RT = RT - imgOnTime;
        
end