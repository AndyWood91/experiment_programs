% IDENTICAL TO MAKESPRITES1, BUT WITHOUT LINES

%y054
% índice de sprites
% 1001 - cruz de fijación
% 1002 - cajas
% 1003 - category labels 1 and 2
% 1004 - category labels 3 and 4
% 1006 - end screen
% 2001-2004 - feedback categories
% 3001-3004 - arrows
% 101-112 - cues
% 301 - dot

% fixation
cgmakesprite(1001,50,50,0,0,0); cgsetsprite(1001)
cgpencol(1, 1, 1); cgpenwid(2); cgalign('c','c')
cgdraw(0, -10, 0, 10)
cgdraw(10, 0, -10, 0)

% boxes
cgmakesprite(1002,800,600,0,0,0); cgsetsprite(1002)
cgpencol(1, 1, 1); cgpenwid(2); cgalign('c','c')
cgdraw(-340, 145, -340, -145)
cgdraw(-340, 145, -50, 145)
cgdraw(-340, -145, -50, -145)
cgdraw(-50, 145, -50, -145)
cgdraw(50, 145, 50, -145)
cgdraw(50, 145, 340, 145)
cgdraw(50, -145, 340, -145)
cgdraw(340, 145, 340, -145)

% categorylabels
cgmakesprite(1003,300,150,0,0,0); cgsetsprite(1003)
cgpencol(1, 1, 1); cgpenwid(2); cgalign('c','c')
cgdraw(-150, -75, -150, 75)
cgdraw(-150, 75, 150, 75)
cgdraw(150, 75, 150, -75)
cgdraw(150, -75, -150, -75)
cgfont('Arial', 30); cgtext('UP', 0, 40)
cgfont('Arial', 20); cgtext('or', 0, 0)
cgfont('Arial', 30); cgtext('DOWN?', 0, -40)
    
% endscreen'
cgmakesprite(1006,400,200,0,0,0); cgsetsprite(1006)
cgpencol(1, 1, 1); cgpenwid(2); cgalign('c','c')
cgfont('Arial',30); cgtext('END OF THE EXPERIMENT.', 0, 50)
cgfont('Arial', 20); cgtext('Thanks for your collaboration!', 0, -20);
cgfont('Arial', 15); cgtext('Press ESC to quit.', 0, -80)

% incorrecto: la categoría correcta es la 1
cgmakesprite(2001,350,100,0,0,0); cgsetsprite(2001)
cgpencol(1, 1, 1); cgpenwid(2); cgalign('c','c')
cgdraw(-175, -50, -175, 50)
cgdraw(-175, 50, 175, 50)
cgdraw(175, 50, 175, -50)
cgdraw(175, -50, -175, -50)
cgpencol(1, 0, 0)
cgfont('Arial', 30); cgtext('ERROR!', 0, 18)
cgfont('Arial', 22); cgtext('The correct response was A', 0, -15)

% incorrecto: la categoría correcta es la 2
cgmakesprite(2002,350,100,0,0,0); cgsetsprite(2002)
cgpencol(1, 1, 1); cgpenwid(2); cgalign('c','c')
cgdraw(-175, -50, -175, 50)
cgdraw(-175, 50, 175, 50)
cgdraw(175, 50, 175, -50)
cgdraw(175, -50, -175, -50)
cgpencol(1, 0, 0)
cgfont('Arial', 30); cgtext('ERROR!', 0, 18)
cgfont('Arial', 22); cgtext('The correct response was Z', 0, -15)

% incorrecto dot probe
cgmakesprite(2003,350,100,0,0,0); cgsetsprite(2003)
cgpencol(1, 1, 1); cgpenwid(2); cgalign('c','c')
cgdraw(-175, -50, -175, 50)
cgdraw(-175, 50, 175, 50)
cgdraw(175, 50, 175, -50)
cgdraw(175, -50, -175, -50)
cgpencol(1, 0, 0)
cgfont('Arial', 30); cgtext('ERROR!', 0, 0)

% arrow up
cgmakesprite(3001,100,100,0,0,0); cgsetsprite(3001)
cgpencol(1,1,1); cgfont('Arial',120,0); cgtext('A',0,0)

% arrow down
cgmakesprite(3002,100,100,0,0,0); cgsetsprite(3002)
cgpencol(1,1,1); cgfont('Arial',120,0); cgtext('Z',0,0)

% arrow left
cgmakesprite(3003,100,100,0,0,0); cgsetsprite(3003)
cgpencol(1, 1, 1); cgpenwid(8); cgalign('c','c')
cgdraw(-45, 0, 45, 0)
cgdraw(-15, -30, -45, 0)
cgdraw(-15, 30, -45, 0)

% arrow right
cgmakesprite(3004,100,100,0,0,0); cgsetsprite(3004)
cgpencol(1, 1, 1); cgpenwid(8); cgalign('c','c')
cgdraw(-45, 0, 45, 0)
cgdraw(15, -30, 45, 0)
cgdraw(15, 30, 45, 0)

% cues
cgmakesprite(101,200,200,0,0,0); cgsetsprite(101)
cgpencol(0.6,0.4,0); cgpenwid(1); cgellipse(0, 0, 170, 170, 'f')  %BROWN
%cgpencol(1,1,1); cgfont('Arial',100,0); cgtext('A',0,0)

cgmakesprite(102,200,200,0,0,0); cgsetsprite(102)
cgpencol(0,0.8,0.2); cgpenwid(1); cgellipse(0, 0, 170, 170, 'f') %GREEN
%cgpencol(1,1,1); cgfont('Arial',100,0); cgtext('B',0,0)

cgmakesprite(103,200,200,0,0,0); cgsetsprite(103)
cgpencol(0, 0.5, 1); cgpenwid(1); cgellipse(0, 0, 170, 170, 'f') %BLUE
%cgpencol(1,1,1); cgfont('Arial',100,0); cgtext('X',0,0)

cgmakesprite(104,200,200,0,0,0); cgsetsprite(104)
cgpencol(1,0,0); cgpenwid(1); cgellipse(0, 0, 170, 170, 'f') %RED
%cgpencol(1,1,1); cgfont('Arial',100,0); cgtext('Y',0,0)

% dot white
cgmakesprite(301,30,30,0,0,0); cgsetsprite(301)
cgpencol(1,1,1); cgrect(0, 0, 30, 30)

cgsetsprite(0)
