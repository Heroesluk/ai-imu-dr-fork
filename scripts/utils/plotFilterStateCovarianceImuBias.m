function [] = plotFilterStateCovarianceImuBias(folderPath)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

filterState = loadFilterStateIntegratedGroundTruth(folderPath);

printFolderPath = fullfile(folderPath,'dayZeroOClockAlign');
saveFigFileName = "StateCovarianceImuBias";

filterStateTime = getFilterStateTime(filterState);
filterStateCovariance = getFilterStateCovariance(filterState);

filterStateTimeMin = min(filterStateTime);
filterStateTimeFloor = floor(filterStateTimeMin);
filterStateTimeSize = size(filterStateTime,1);
filterStateImuGyroscopeBiasCovarianceX = reshape(filterStateCovariance(10,10,:),filterStateTimeSize,1);
filterStateImuGyroscopeBiasCovarianceY = reshape(filterStateCovariance(11,11,:),filterStateTimeSize,1);
filterStateImuGyroscopeBiasCovarianceZ = reshape(filterStateCovariance(12,12,:),filterStateTimeSize,1);
filterStateImuAccelerometerBiasCovarianceX = reshape(filterStateCovariance(13,13,:),filterStateTimeSize,1);
filterStateImuAccelerometerBiasCovarianceY = reshape(filterStateCovariance(14,14,:),filterStateTimeSize,1);
filterStateImuAccelerometerBiasCovarianceZ = reshape(filterStateCovariance(15,15,:),filterStateTimeSize,1);


figureHandle = figure;
timeReferenceSubPlotRows = 2;
timeReferenceSubPlotColumns = 1;
pX = filterStateTime - filterStateTimeFloor;

axesObject1 = subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
pY4 = horzcat(filterStateImuGyroscopeBiasCovarianceX,filterStateImuGyroscopeBiasCovarianceY,filterStateImuGyroscopeBiasCovarianceZ);
hold on;
lineObject11 = plot(pX,pY4(:,1));
lineObject12 = plot(pX,pY4(:,2));
lineObject13 = plot(pX,pY4(:,3));
title('IMU Gyroscope Bias Covariance');
xlabel("Time (s)");
ylabel("Covariance ((rad/s)^2)");
legend4 = legend();
grid on;
hold off;

axesObject2 = subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
pY5 = horzcat(filterStateImuAccelerometerBiasCovarianceX,filterStateImuAccelerometerBiasCovarianceY,filterStateImuAccelerometerBiasCovarianceZ);
hold on;
lineObject21 = plot(pX,pY5(:,1));
lineObject22 = plot(pX,pY5(:,2));
lineObject23 = plot(pX,pY5(:,3));
title('IMU Accelerometer Bias Covariance');
xlabel("Time (s)");
ylabel("Covariance ((m/s^2)^2)");
legend5 = legend();
grid on;
hold off;

% Line 属性
% 线条
set(lineObject11,'Color',"r");
set(lineObject12,'Color',"g");
set(lineObject13,'Color',"b");
set(lineObject21,'Color',"r");
set(lineObject22,'Color',"g");
set(lineObject23,'Color',"b");

% 图例
set(lineObject11,'DisplayName',"X");
set(lineObject12,'DisplayName',"Y");
set(lineObject13,'DisplayName',"Z");
set(lineObject21,'DisplayName',"X");
set(lineObject22,'DisplayName',"Y");
set(lineObject23,'DisplayName',"Z");

% Legend 属性
% 字体
set(legend4,'FontName','Times New Roman');
set(legend5,'FontName','Times New Roman');
set(legend4,'FontSize',10);
set(legend5,'FontSize',10);

% Preparation of Articles for IEEE TRANSACTIONS and JOURNALS (2022)
% IV. GUIDELINES FOR GRAPHICS PREPARATION AND SUBMISSION

% H. Accepted Fonts Within Figures
% Times New Roman,
% Helvetica, Arial
% Cambria
% Symbol
% Axes 属性
% https://ww2.mathworks.cn/help/matlab/ref/matlab.graphics.axis.axes-properties.html
% 字体
set(axesObject1,'FontName','Times New Roman');
set(axesObject2,'FontName','Times New Roman');

% I. Using Labels Within Figures
% Figure labels should be legible, approximately 8- to 10-point type.
% 字体大小
set(axesObject1,'FontSize',10);
set(axesObject2,'FontSize',10);

saveFigFilePath = fullfile(printFolderPath,saveFigFileName);
saveas(gcf,saveFigFilePath,'fig')

% D. Sizing of Graphics
% one column wide (3.5 inches / 88 mm / 21 picas)
% page wide (7.16 inches / 181 millimeters / 43 picas)
% maximum depth ( 8.5 inches / 216 millimeters / 54 picas)
% https://www.mathworks.com/help/matlab/ref/matlab.ui.figure-properties.html
% Figure 属性
% 位置和大小
figurePropertiesPositionLeft = 0;
figurePropertiesPositionBottom = 0;
figurePropertiesPositionWidth = 18.1;
figureAspectRatio = 4/3;
figurePropertiesPositionHeight = figurePropertiesPositionWidth/figureAspectRatio;
figurePropertiesPosition = [ ...
    figurePropertiesPositionLeft ...
    figurePropertiesPositionBottom ...
    figurePropertiesPositionWidth ...
    figurePropertiesPositionHeight ...
    ];
set(gcf,'Units','centimeters');
set(gcf,'Position',figurePropertiesPosition);
% 打印和导出
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','landscape');
figurePropertiesPaperSize = [figurePropertiesPositionWidth figurePropertiesPositionHeight];
set(gcf,'PaperSize',figurePropertiesPaperSize);
set(gcf,'PaperPosition',figurePropertiesPosition);

% 位置
% set(gca,'Units','centimeters');
% set(gca,'OuterPosition',gcf().Position);

hold off;

printFileName = strcat(saveFigFileName,".png");
printFilePath = fullfile(printFolderPath,printFileName);
% C. File Formats for Graphics
% PostScript (PS)
% Encapsulated PostScript (.EPS)
% Tagged Image File Format (.TIFF)
% Portable Document Format (.PDF)
% JPEG
% Portable Network Graphics (.PNG)
% E. Resolution
% Author photographs, color, and grayscale figures should be at least 300dpi. 
% Line art, including tables should be a minimum of 600dpi.
% print(gcf,printFilePath,'-dpng','-r600');
exportgraphics(gcf,printFilePath,'Resolution',600)

close(figureHandle);

end