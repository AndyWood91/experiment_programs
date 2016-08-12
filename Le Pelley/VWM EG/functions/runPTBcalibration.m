
global Calib calibCoordinatesX calibCoordinatesY
global xCentre yCentre
global pNumber
global calibrationNum

scrWidth = xCentre * 2;
scrHeight = yCentre * 2;

calibCoordinatesX = scrWidth * [0.2, 0.8, 0.5, 0.8, 0.2];
calibCoordinatesY = scrHeight * [0.2, 0.2, 0.5, 0.8, 0.8];


%% This is the calibration stage
SetCalibParamsPTB; 

TrackStatusPTB;

calibPoints = HandleCalibWorkflowPsychToolBox(Calib); % calibPoints is what you will want to save (or add to your data file)

%% Closes everything down

calibrationNum = calibrationNum + 1;

filepath = ['Data\CalibrationData\P', num2str(pNumber), '_Cal', num2str(calibrationNum)];

save(filepath,'calibPoints');

clear calibPoints;
clear filePath;