function [] = plotCoordinateFrame(coordinateMatrix)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

coordinateWorldAxisLength = 1; % coordinate axis length
coordinateWorldAxisScaled = coordinateMatrix .* coordinateWorldAxisLength;

coordinateWorldOrigin = [0 0 0];
coordinateWorldAxisX = coordinateWorldAxisScaled(:,1);
coordinateWorldAxisY = coordinateWorldAxisScaled(:,2);
coordinateWorldAxisZ = coordinateWorldAxisScaled(:,3);

quiverCustom(coordinateWorldOrigin(1),coordinateWorldOrigin(2),coordinateWorldOrigin(3),coordinateWorldAxisX(1),coordinateWorldAxisX(2),coordinateWorldAxisX(3),'Color','r');
quiverCustom(coordinateWorldOrigin(1),coordinateWorldOrigin(2),coordinateWorldOrigin(3),coordinateWorldAxisY(1),coordinateWorldAxisY(2),coordinateWorldAxisY(3),'Color','g');
quiverCustom(coordinateWorldOrigin(1),coordinateWorldOrigin(2),coordinateWorldOrigin(3),coordinateWorldAxisZ(1),coordinateWorldAxisZ(2),coordinateWorldAxisZ(3),'Color','b');
hTextFontWeight = 'bold';
hTextX = text(coordinateWorldAxisX(1),coordinateWorldAxisX(2),coordinateWorldAxisX(3),'X');
hTextX.FontWeight = hTextFontWeight;
hTextY = text(coordinateWorldAxisY(1),coordinateWorldAxisY(2),coordinateWorldAxisY(3),'Y');
hTextY.FontWeight = hTextFontWeight;
hTextZ = text(coordinateWorldAxisZ(1),coordinateWorldAxisZ(2),coordinateWorldAxisZ(3),'Z');
hTextZ.FontWeight = hTextFontWeight;


end