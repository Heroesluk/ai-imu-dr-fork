function [] = plotPreprocessImuMeasurement(folderPath)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

preprocessRawFlatData = loadPreprocessRawFlat(folderPath);

printFolderPath = fullfile(folderPath,'dayZeroOClockAlign');
saveFigFileName = "PhoneMeasurementImu";

preprocessTime = getPreprocessTime(preprocessRawFlatData);
preprocessTimeMin = min(preprocessTime);
preprocessTimeMinFloor = floor(preprocessTimeMin);
preprocessPhoneImuGyroscope = getPreprocessPhoneImuGyroscope(preprocessRawFlatData);
preprocessPhoneImuAccelerometer = getPreprocessPhoneImuAccelerometer(preprocessRawFlatData);


figureHandle = figure();
timeReferenceSubPlotRows = 2;
timeReferenceSubPlotColumns = 1;
pTime = preprocessTime - preprocessTimeMinFloor;

pImuGyroscopeAxesObject = subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
pImuGyroscopeData = preprocessPhoneImuGyroscope;
hold on;
pImuGyroscopeXLineObject = plot(pTime,pImuGyroscopeData(:,1));
pImuGyroscopeYLineObject = plot(pTime,pImuGyroscopeData(:,2));
pImuGyroscopeZLineObject = plot(pTime,pImuGyroscopeData(:,3));
title('Gyroscope');
xlabel('Sample (s)');
ylabel('Value (°/s)');
pImuGyroscopeLegendHandle = legend();
hold off;

pImuAccelerometerAxesObject = subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
pImuAccelerometerData = preprocessPhoneImuAccelerometer;
hold on;
pImuAccelerometerXLineObject = plot(pTime,pImuAccelerometerData(:,1));
pImuAccelerometerYLineObject = plot(pTime,pImuAccelerometerData(:,2));
pImuAccelerometerZLineObject = plot(pTime,pImuAccelerometerData(:,3));
title('Accelerometer');
xlabel('Sample (s)');
ylabel('Value (m/s^{2})');
pImuAccelerometerLegendHandle = legend();
hold off;

% Line 属性
% 线条
set(pImuGyroscopeXLineObject,'Color',"r");
set(pImuGyroscopeYLineObject,'Color',"g");
set(pImuGyroscopeZLineObject,'Color',"b");
set(pImuAccelerometerXLineObject,'Color',"r");
set(pImuAccelerometerYLineObject,'Color',"g");
set(pImuAccelerometerZLineObject,'Color',"b");

% 图例
set(pImuGyroscopeXLineObject,'DisplayName',"X");
set(pImuGyroscopeYLineObject,'DisplayName',"Y");
set(pImuGyroscopeZLineObject,'DisplayName',"Z");
set(pImuAccelerometerXLineObject,'DisplayName',"X");
set(pImuAccelerometerYLineObject,'DisplayName',"Y");
set(pImuAccelerometerZLineObject,'DisplayName',"Z");

% Legend 属性
% 字体
set(pImuGyroscopeLegendHandle,'FontName','Times New Roman');
set(pImuGyroscopeLegendHandle,'FontSize',10);
set(pImuAccelerometerLegendHandle,'FontName','Times New Roman');
set(pImuAccelerometerLegendHandle,'FontSize',10);

grid on;

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
set(pImuGyroscopeAxesObject,'FontName','Times New Roman');
set(pImuAccelerometerAxesObject,'FontName','Times New Roman');

% I. Using Labels Within Figures
% Figure labels should be legible, approximately 8- to 10-point type.
% 字体大小
set(pImuGyroscopeAxesObject,'FontSize',10);
set(pImuAccelerometerAxesObject,'FontSize',10);

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