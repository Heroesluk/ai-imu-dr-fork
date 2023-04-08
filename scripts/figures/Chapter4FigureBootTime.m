close all;
clear;

S2MS = 1e3;
MS2S = 1/S2MS;
S2NS = 1e9;
NS2S = 1/S2NS;
MS2NS = 1e6;
NS2MS = 1/MS2NS;

cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_16\0004';

kRawFolderName = 'raw';

kMotionSensorAccelerometerUncalibratedFileName = 'MotionSensorAccelerometerUncalibrated.csv';

motionSensorAccelerometerUncalibratedFilePath = fullfile(cDatasetFolderPath,kRawFolderName,kMotionSensorAccelerometerUncalibratedFileName);
motionSensorAccelerometerUncalibratedRawData = readmatrix(motionSensorAccelerometerUncalibratedFilePath);
N = length(motionSensorAccelerometerUncalibratedRawData);
systemTime = motionSensorAccelerometerUncalibratedRawData(:,1);
systemClockTime = motionSensorAccelerometerUncalibratedRawData(:,2);

bootTimeNanosSystemBase = systemTime * MS2NS - systemClockTime;
minBootTimeNanosSystemBase = min(bootTimeNanosSystemBase);
pReferenceBootTimeNanosSystemBase = floor(minBootTimeNanosSystemBase * NS2MS) * MS2NS;
figure();
pBootTimeNanosSystemBase = bootTimeNanosSystemBase - pReferenceBootTimeNanosSystemBase;
plot(pBootTimeNanosSystemBase);

set(gcf, 'PaperUnits', 'centimeters');

% http://gs.xjtu.edu.cn/info/1209/7605.htm
% 参考《西安交通大学博士、硕士学位论文模板（2021版）》中对图的要求
% 图尺寸的一般宽高比应为6.67 cm×5.00 cm。特殊情况下， 也可为
% 9.00 cm×6.75 cm， 或13.5 cm×9.00 cm。总之， 一篇论文中， 同类图片的
% 大小应该一致，编排美观、整齐；
set(gcf, 'PaperPosition', [0, 0, 9, 6.75]);
set(gca, 'lineWidth', 1.1, 'FontSize', 9, 'FontName', 'Times');

xlabel('Sample','FontSize',12);
ylabel('Nanosecond','FontSize',12);


print(gcf,'f','-dpng','-r600');




