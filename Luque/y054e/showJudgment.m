function respKey = showJudgment(cueCode, outCode)
    
    % decidir cuál es el outcome correcto
    switch outCode
        case 1; outText = 'A';
        case 2; outText = 'Z';
    end
	testQuestion = horzcat('to what extent do you think that the correct response would be ', outText, '?');

    % dibujar pregunta superior
    cgpencol(1,1,1); cgfont('Arial',26,0); cgalign('c','c')
    cgtext('If you saw these figures during the experiment...', 0, 250)

    % dibujar recuadro central
    cgpencol(1, 1, 1); cgpenwid(2); cgalign('c','c')
    cgdraw(-150, -100, -150, 200)
    cgdraw(-150, 200, 150, 200)
    cgdraw(150, 200, 150, -100)
    cgdraw(150, -100, -150, -100)
    cgdrawsprite(cueCode,0,50)

    % dibujar textos
    cgpencol(1,1,1); cgfont('Arial',26,0); cgalign('c','c')
    cgtext(testQuestion, 0, -150)
    cgpencol(1,1,1); cgfont('Arial',20,0); cgalign('c','c')
    cgtext('(Press a number from 1 to 7 to enter your response.)', 0, -180)

	% dibujar escala de juicios y lábeles
	cgpencol(1,0,0); cgrect(-150,-240,40,40)
	cgpencol(1,1,1); cgfont('Arial',26,0); cgtext('1',-150,-240)
	cgpencol(1,0,0); cgrect(-100,-240,40,40)
	cgpencol(1,1,1); cgfont('Arial',26,0); cgtext('2',-100,-240)
	cgpencol(1,0,0); cgrect(-50,-240,40,40)
	cgpencol(1,1,1); cgfont('Arial',26,0); cgtext('3',-50,-240)
	cgpencol(1,0,0); cgrect(0,-240,40,40)
	cgpencol(1,1,1); cgfont('Arial',26,0); cgtext('4',0,-240)
	cgpencol(1,0,0); cgrect(50,-240,40,40)
	cgpencol(1,1,1); cgfont('Arial',26,0); cgtext('5',50,-240)
	cgpencol(1,0,0); cgrect(100,-240,40,40)
	cgpencol(1,1,1); cgfont('Arial',26,0); cgtext('6',100,-240)
	cgpencol(1,0,0); cgrect(150,-240,40,40)
	cgpencol(1,1,1); cgfont('Arial',26,0); cgtext('7',150,-240)
    cgpencol(1,1,1); cgfont('Arial',20,0); cgalign('c','c')
    cgtext('YES', 220, -240)
    cgtext('NO', -220, -240)

    cgflip
    
    respKey = waitkeydown(inf,[28 29 30 31 32 33 34]);
    
    switch respKey(1)
        case 28; respKey = 1;
        case 29; respKey = 2;
        case 30; respKey = 3;
        case 31; respKey = 4;
        case 32; respKey = 5;
        case 33; respKey = 6;
        case 34; respKey = 7;
    end
    
    cgflip(0,0,0)

end