function [sequence, Cues, Outcomes] = makeSequence(SOA, numBlocks1A, numBlocks1B, numBlocks2)

% MEANING OF EACH COLUMN IN SEQUENCE
%   1: block
%   2: tipo ensayo
%   3: order of cues: 1 = predictiveL / 2 = predictiveR
%   4: lugar del dot: 1 = L / 2 = R / 0=ENSAYO DE CATEGORIZACIÓN
%   5: congruency: 0 = incongruent (dot on nonpredictive)
%                  1 = congruent (dot on predictive)
%   7: left cue
%   8: right cue
%   9: outcome

    % ASIGNACIÓN DE CLAVES Y OUTCOMES
    Cues = [101:104];
    Outcomes = [1:2];
     Cues = Cues(randperm(length(Cues)));              % <---- ANULAR PARA QUITAR RANDOMIZACIÓN
     Outcomes = Outcomes(randperm(length(Outcomes)));  % <---- ANULAR PARA QUITAR RANDOMIZACIÓN
    CueA = Cues(1);
    CueB = Cues(2);
	CueX = Cues(3);
    CueY = Cues(4);
	Out1 = Outcomes(1);
    Out2 = Outcomes(2);
    
    % PREPARAR ENSAYOS
    % 1: tipo ensayo
    % 2 order of cues: 1 = predictiveL / 2 = predictiveR
    % 3 lugar del dot: 1 = L / 2 = R / 0=ENSAYO DE CATEGORIZACIÓN
    % 4 congruency: 0 = incongruent (dot on nonpredictive)
    %               1 = congruent (dot on predictive)
    % 5 SOA: 250
    % 6 left cue // 7 right cue // 8 outcome
    
    
    % DEFINICIÓN DE ENSAYOS
    trialAX1L = [1001 1 1 1 SOA CueA CueX Out1]; % AX-1
    trialAX1R = [1001 1 2 0 SOA CueA CueX Out1];
    trialAX1c = [1001 1 0 0 000 CueA CueX Out1];
    trialXA1L = [1001 2 1 0 SOA CueX CueA Out1];
    trialXA1R = [1001 2 2 1 SOA CueX CueA Out1];
    trialXA1c = [1001 2 0 0 000 CueX CueA Out1];
    trialBX2L = [1002 1 1 1 SOA CueB CueX Out2]; % BX-2
    trialBX2R = [1002 1 2 0 SOA CueB CueX Out2];
    trialBX2c = [1002 1 0 0 000 CueB CueX Out2];
    trialXB2L = [1002 2 1 0 SOA CueX CueB Out2];
    trialXB2R = [1002 2 2 1 SOA CueX CueB Out2];
    trialXB2c = [1002 2 0 0 000 CueX CueB Out2];
    trialAY1L = [1003 1 1 1 SOA CueA CueY Out1]; % AY-1
    trialAY1R = [1003 1 2 0 SOA CueA CueY Out1];
    trialAY1c = [1003 1 0 0 000 CueA CueY Out1];
    trialYA1L = [1003 2 1 0 SOA CueY CueA Out1];
    trialYA1R = [1003 2 2 1 SOA CueY CueA Out1];
    trialYA1c = [1003 2 0 0 000 CueY CueA Out1];
    trialBY2L = [1004 1 1 1 SOA CueB CueY Out2]; % BY-2
    trialBY2R = [1004 1 2 0 SOA CueB CueY Out2];
    trialBY2c = [1004 1 0 0 000 CueB CueY Out2];
    trialYB2L = [1004 2 1 0 SOA CueY CueB Out2];
    trialYB2R = [1004 2 2 1 SOA CueY CueB Out2];
    trialYB2c = [1004 2 0 0 000 CueY CueB Out2];
    trialBY1L = [1005 1 1 1 SOA CueB CueY Out1]; % BY-1
    trialBY1R = [1005 1 2 0 SOA CueB CueY Out1];
    trialBY1c = [1005 1 0 0 000 CueB CueY Out1];
    trialYB1L = [1005 2 1 0 SOA CueY CueB Out1];
    trialYB1R = [1005 2 2 1 SOA CueY CueB Out1];
    trialYB1c = [1005 2 0 0 250 CueY CueB Out1];
    
   
    % HACER LA SECUENCIA DE ENSAYOS
    sequence = [];
    
    % Stage 1A
    % sólo incluyo LEFT trials porque esto dará igual después...
    for n = 1:numBlocks1A
        block = [];
        block = [block; trialAX1c; trialXA1c];
        block = [block; trialBX2c; trialXB2c];
        block = [block; trialAY1c; trialYA1c];
        block = [block; trialBY2c; trialYB2c];        
        block = RandomizeRows(block); % randomizar orden
        block(:, 9) = n; % indexa de qué bloque viene
        sequence = [sequence; block];
    end

    % Stage 1B
    for n = (numBlocks1A + 1):(numBlocks1A + numBlocks1B)
        block = []; subblock1 = []; subblock2 = [];
        
        % ensayos dot probe
        subblock1 = [subblock1; trialAX1L; trialAX1R; trialXA1L; trialXA1R]; % ensayos AX-1
        subblock1 = [subblock1; trialBX2L; trialBX2R; trialXB2L; trialXB2R];
        subblock1 = [subblock1; trialAY1L; trialAY1R; trialYA1L; trialYA1R]; % ensayos BY-2
        subblock1 = [subblock1; trialBY2L; trialBY2R; trialYB2L; trialYB2R];
        
        % ensayos categorización
        subblock2 = [subblock2; trialAX1c; trialAX1c; trialXA1c; trialXA1c]; % ensayos AX-1
        subblock2 = [subblock2; trialBX2c; trialBX2c; trialXB2c; trialXB2c];
        subblock2 = [subblock2; trialAY1c; trialAY1c; trialYA1c; trialYA1c]; % ensayos BY-2
        subblock2 = [subblock2; trialBY2c; trialBY2c; trialYB2c; trialYB2c];
        
        subblock1 = RandomizeRows(subblock1);
        subblock2 = RandomizeRows(subblock2);
        block = shuffleBlocks(subblock1, subblock2);
        block(:, 9) = n;
        sequence = [sequence; block];
    end
    
    % Stage 2
    for n = (numBlocks1A + numBlocks1B + 1):(numBlocks1A + numBlocks1B + numBlocks2)
        block = []; subblock1 = []; subblock2 = [];
        
        % ensayos dot probe
        subblock1 = [subblock1; trialAX1L; trialAX1R; trialXA1L; trialXA1R]; % ensayos AX-1
        subblock1 = [subblock1; trialAX1L; trialAX1R; trialXA1L; trialXA1R];
        subblock1 = [subblock1; trialAX1L; trialAX1R; trialXA1L; trialXA1R];
        subblock1 = [subblock1; trialBY2L; trialBY2R; trialYB2L; trialYB2R]; % ensayos BY-2
        subblock1 = [subblock1; trialBY2L; trialBY2R; trialYB2L; trialYB2R];
        subblock1 = [subblock1; trialBY1L; trialBY1R; trialYB1L; trialYB1R]; % ensayos BY-1

        % ensayos categorización
        subblock2 = [subblock2; trialAX1c; trialAX1c; trialXA1c; trialXA1c]; % ensayos AX-1
        subblock2 = [subblock2; trialAX1c; trialAX1c; trialXA1c; trialXA1c];
        subblock2 = [subblock2; trialAX1c; trialAX1c; trialXA1c; trialXA1c];
        subblock2 = [subblock2; trialBY2c; trialBY2c; trialYB2c; trialYB2c]; % ensayos BY-2
        subblock2 = [subblock2; trialBY2c; trialBY2c; trialYB2c; trialYB2c];
        subblock2 = [subblock2; trialBY1c; trialBY1c; trialYB1c; trialYB1c]; % ensayos BY-1

        subblock1 = RandomizeRows(subblock1);
        subblock2 = RandomizeRows(subblock2);
        block = shuffleBlocks(subblock1, subblock2);
        block(:, 9) = n;
        sequence = [sequence; block];
    end
    
    % reordenar para poner bloque al principio
    sequence = [sequence(:, 9), sequence(:, 1:8)];
    
    % subfunction
    function [Y] = RandomizeRows(X)
    %Given a matrix X as input, its sorts the rows randomly
        [numRows, numCols] = size(X);
        indices = randperm(numRows);
        Y = X(indices, :);
    end
   
    function blockf = shuffleBlocks(block1, block2)
        blockf = [];
        for z=1:size(block1,1)
            blockf = [blockf; block1(z,:); block2(z,:)];
        end
    end

end