function [] = plotPreprocessGroundTruthSE2(folderPath)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

preprocessRawFlatData = loadPreprocessRawFlat(folderPath);

printFolderPath = fullfile(folderPath,'dayZeroOClockAlign');
saveFigFileName = "GroundTruthSE2";

preprocessTime = getPreprocessTime(preprocessRawFlatData);
preprocessGroundTruthNavOrientation = getPreprocessGroundTruthNavOrientationRotationMatrix(preprocessRawFlatData);
preprocessGroundTruthNavVelocity = getPreprocessGroundTruthNavVelocity(preprocessRawFlatData);
preprocessGroundTruthNavPosition = getPreprocessGroundTruthNavPosition(preprocessRawFlatData);

pCarXLength = 1.900;
pCarYLength = 4.835;
pCarZLength = 1.780;
pCarCoordinateAxisScale = 1.0;
pCarCoordinateAxisXLineLength = pCarXLength * pCarCoordinateAxisScale;
pCarCoordinateAxisYLineLength = pCarYLength * pCarCoordinateAxisScale;
pCarCoordinateAxisZLineLength = pCarZLength * pCarCoordinateAxisScale;
pCarCoordinateAxisLineWidth = 1;
for i=plotFilterStateZTimeindexStart:1:plotFilterStateZTimeindexEnd
    sensorCoordinateAxisInSensorCoordinateSystem = [0 0 0 1; pCarCoordinateAxisXLineLength 0 0 1; 0 0 0 1; 0 pCarCoordinateAxisYLineLength 0 1; 0 0 0 1; 0 0 pCarCoordinateAxisZLineLength 1]';
    pSEBracket3FromS2N = SE3(preprocessGroundTruthNavOrientation(:,:,i),preprocessGroundTruthNavPosition(i,:)).double;
    pSensorCoordinateAxisInNavCoordinateSystem = pSEBracket3FromS2N * sensorCoordinateAxisInSensorCoordinateSystem;
    plot3(pSensorCoordinateAxisInNavCoordinateSystem(1,1:2),pSensorCoordinateAxisInNavCoordinateSystem(2,1:2),pSensorCoordinateAxisInNavCoordinateSystem(3,1:2),'Color','r','LineStyle','--','LineWidth',pCarCoordinateAxisLineWidth);
    plot3(pSensorCoordinateAxisInNavCoordinateSystem(1,3:4),pSensorCoordinateAxisInNavCoordinateSystem(2,3:4),pSensorCoordinateAxisInNavCoordinateSystem(3,3:4),'Color','g','LineStyle','--','LineWidth',pCarCoordinateAxisLineWidth);
    plot3(pSensorCoordinateAxisInNavCoordinateSystem(1,5:6),pSensorCoordinateAxisInNavCoordinateSystem(2,5:6),pSensorCoordinateAxisInNavCoordinateSystem(3,5:6),'Color','b','LineStyle','--','LineWidth',pCarCoordinateAxisLineWidth);
end


close(figureHandle);

end