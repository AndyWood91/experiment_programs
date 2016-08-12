    function [RespKey, RT, Accuracy] = responseCat(Category, imgOnTime)

    [RespKey, RT] = waitkeydown(inf,[1 26]); %wait for A or Z
    
    % determine accuracy of response
    Accuracy = 0;
    if numel(RespKey) == 1 % accuracy = 0 for cases of multiple key presses
        switch RespKey
            case 1 % <A>
                if Category == 1; Accuracy = 1; end
            case 26 % <Z>
                if Category == 2; Accuracy = 1; end
        end
    else
        RespKey = RespKey(1);
        RT = RT(1);
        Accuracy = 222222; %mark double key press as 222222
    end

    % compute RT
    RT = RT - imgOnTime;
    
    end