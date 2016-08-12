% tengo que preguntar por las claves A-L (12)
% con outcomes 3-4, empezando siempre por respuesta 3

% datos que generaba makeSequence:
%       function [sequence, Cues, Outcomes12, Outcomes34] = makeSequence
%       [sequence, DATA.cues, DATA.outcomes12, DATA.outcomes34] = makeSequence;



% JUICIOS ELEMENTALES
% -------------------

cues4judg = DATA.cues(randperm(length(DATA.cues)));

for a=1:8 % for every cue    
    
    for b = 1:2 % for every outcome
        
        cueLetter = cues4judg(a);
        judg = showJudgment(cueLetter, b);
        if cues4judg(a) == DATA.cues(1) & b == DATA.outcomes(1); DATA.judgA1 = judg, end
        if cues4judg(a) == DATA.cues(1) & b == DATA.outcomes(2); DATA.judgA2 = judg, end
        if cues4judg(a) == DATA.cues(2) & b == DATA.outcomes(1); DATA.judgB1 = judg, end
        if cues4judg(a) == DATA.cues(2) & b == DATA.outcomes(2); DATA.judgB2 = judg, end
        if cues4judg(a) == DATA.cues(3) & b == DATA.outcomes(1); DATA.judgC1 = judg, end
        if cues4judg(a) == DATA.cues(3) & b == DATA.outcomes(2); DATA.judgC2 = judg, end
        if cues4judg(a) == DATA.cues(4) & b == DATA.outcomes(1); DATA.judgD1 = judg, end
        if cues4judg(a) == DATA.cues(4) & b == DATA.outcomes(2); DATA.judgD2 = judg, end
        if cues4judg(a) == DATA.cues(5) & b == DATA.outcomes(1); DATA.judgX1 = judg, end
        if cues4judg(a) == DATA.cues(5) & b == DATA.outcomes(2); DATA.judgX2 = judg, end
        if cues4judg(a) == DATA.cues(6) & b == DATA.outcomes(1); DATA.judgY1 = judg, end
        if cues4judg(a) == DATA.cues(6) & b == DATA.outcomes(2); DATA.judgY2 = judg, end
        if cues4judg(a) == DATA.cues(7) & b == DATA.outcomes(1); DATA.judgW1 = judg, end
        if cues4judg(a) == DATA.cues(7) & b == DATA.outcomes(2); DATA.judgW2 = judg, end
        if cues4judg(a) == DATA.cues(8) & b == DATA.outcomes(1); DATA.judgZ1 = judg, end
        if cues4judg(a) == DATA.cues(8) & b == DATA.outcomes(2); DATA.judgZ2 = judg, end
        pause(1)
        
    end

end




% JUICIOS DE COMPUESTOS
% ---------------------

order = randperm(8);

cueA = DATA.cues(1);
cueB = DATA.cues(2);
cueC = DATA.cues(3);
cueD = DATA.cues(4);
cueX = DATA.cues(5);
cueY = DATA.cues(6);
cueW = DATA.cues(7);
cueZ = DATA.cues(8);

for z =1:8
    switch order(z)
        
        case 1 % test de XZ
            judg = showJudgCompound([cueX cueZ], 1);
            if DATA.outcomes(1) == 1; DATA.judgXZ1 = judg, end
            if DATA.outcomes(1) == 2; DATA.judgXZ2 = judg, end
            pause(1)
            judg = showJudgCompound([cueX cueZ], 2);
            if DATA.outcomes(1) == 2; DATA.judgXZ1 = judg, end
            if DATA.outcomes(1) == 1; DATA.judgXZ2 = judg, end
            pause(1)
            
        case 2 % test de YW
            judg = showJudgCompound([cueY cueW], 1);
            if DATA.outcomes(1) == 1; DATA.judgYW1 = judg, end
            if DATA.outcomes(1) == 2; DATA.judgYW2 = judg, end
            pause(1)
            judg = showJudgCompound([cueY cueW], 2);
            if DATA.outcomes(1) == 2; DATA.judgYW1 = judg, end
            if DATA.outcomes(1) == 1; DATA.judgYW2 = judg, end
            pause(1)
        
        case 3 % test de AY
            judg = showJudgCompound([cueA cueY], 1);
            if DATA.outcomes(1) == 1; DATA.judgAY1 = judg, end
            if DATA.outcomes(1) == 2; DATA.judgAY2 = judg, end
            pause(1)
            judg = showJudgCompound([cueA cueY], 2);
            if DATA.outcomes(1) == 2; DATA.judgAY1 = judg, end
            if DATA.outcomes(1) == 1; DATA.judgAY2 = judg, end
            pause(1)

        case 4 % test de BX
            judg = showJudgCompound([cueB cueX], 1);
            if DATA.outcomes(1) == 1; DATA.judgBX1 = judg, end
            if DATA.outcomes(1) == 2; DATA.judgBX2 = judg, end
            pause(1)
            judg = showJudgCompound([cueB cueX], 2);
            if DATA.outcomes(1) == 2; DATA.judgBX1 = judg, end
            if DATA.outcomes(1) == 1; DATA.judgBX2 = judg, end
            pause(1)
            
        case 5 % test de CZ
            judg = showJudgCompound([cueC cueZ], 1);
            if DATA.outcomes(1) == 1; DATA.judgCZ1 = judg, end
            if DATA.outcomes(1) == 2; DATA.judgCZ2 = judg, end
            pause(1)
            judg = showJudgCompound([cueC cueZ], 2);
            if DATA.outcomes(1) == 2; DATA.judgCZ1 = judg, end
            if DATA.outcomes(1) == 1; DATA.judgCZ2 = judg, end
            pause(1)
            
        case 6 % test de DW
            judg = showJudgCompound([cueD cueW], 1);
            if DATA.outcomes(1) == 1; DATA.judgDW1 = judg, end
            if DATA.outcomes(1) == 2; DATA.judgDW2 = judg, end
            pause(1)
            judg = showJudgCompound([cueD cueW], 2);
            if DATA.outcomes(1) == 2; DATA.judgDW1 = judg, end
            if DATA.outcomes(1) == 1; DATA.judgDW2 = judg, end
            pause(1)

        case 7 % test de AD
            judg = showJudgCompound([cueA cueD], 1);
            if DATA.outcomes(1) == 1; DATA.judgAD1 = judg, end
            if DATA.outcomes(1) == 2; DATA.judgAD2 = judg, end
            pause(1)
            judg = showJudgCompound([cueA cueD], 2);
            if DATA.outcomes(1) == 2; DATA.judgAD1 = judg, end
            if DATA.outcomes(1) == 1; DATA.judgAD2 = judg, end
            pause(1)

        case 8 % test de BC
            judg = showJudgCompound([cueB cueC], 1);
            if DATA.outcomes(1) == 1; DATA.judgBC1 = judg, end
            if DATA.outcomes(1) == 2; DATA.judgBC2 = judg, end
            pause(1)
            judg = showJudgCompound([cueB cueC], 2);
            if DATA.outcomes(1) == 2; DATA.judgBC1 = judg, end
            if DATA.outcomes(1) == 1; DATA.judgBC2 = judg, end
            pause(1)

    end
    
end