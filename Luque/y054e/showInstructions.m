function showInstructions(instructionSet)

    pauseduration = 0.1;

    cgflip(0,0,0); pause(0.1);

    switch instructionSet

        case 1 % primer bloque de instrucciones
            for n = 1:6
                instr = strcat('instr', int2str(n), '.jpg');
                loadpict(instr, 1);
                drawpict(1);
                pause(pauseduration)
                waitkeydown(inf);
                cgflip(0,0,0)
            end
            
        case 2 % segundo bloque de instrucciones
            for n = 7:12
                instr = strcat('instr', int2str(n), '.jpg');
                loadpict(instr, 1);
                drawpict(1);
                pause(pauseduration)
                waitkeydown(inf);
                cgflip(0,0,0)
            end
            
    end
        
    cgflip(0,0,0)
    pause(0.1)

end