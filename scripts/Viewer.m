clear;

load 'DataConfig.mat';

cDatasetRepoFolderPath = 'C:\GithubRepositories\ai-imu-dr\kitti\2011_09_26\2011_09_26_drive_0009_extract';

kittiDatasetRaw = readOneKittiDataset(cDatasetRepoFolderPath);
kittiDatasetPlot = kittiDatasetRaw;

plotTs = kittiDatasetRaw(:,TS) - kittiDatasetRaw(1,TS);
kittiDatasetPlot(:,[ROLL PITCH YAW]) = rad2deg(kittiDatasetRaw(:,[ROLL PITCH YAW]));
xLimMin = floor(plotTs(1));
xLimMax = ceil(plotTs(end));
xLim = [xLimMin xLimMax]; 

figure();
subplotRow = 3;
subplotColumn = 1;

subplot(subplotRow,subplotColumn,1);
roll = rad2deg(kittiDatasetRaw(:,ROLL));
pitch = rad2deg(kittiDatasetRaw(:,PITCH));
yaw = rad2deg(kittiDatasetRaw(:,YAW));
plot(plotTs, roll, 'Color', 'red');
hold on; 
plot(plotTs, pitch, 'Color', 'green');
plot(plotTs, yaw, 'Color', 'blue');
xlim(xLim)
title('')
hold off;

subplot(subplotRow,subplotColumn,2);
plot(plotTs, kittiDatasetRaw(:,WX), 'Color', 'red');
hold on;
plot(plotTs, kittiDatasetRaw(:,WY), 'Color', 'green');
plot(plotTs, kittiDatasetRaw(:,WZ), 'Color', 'blue');
xlim(xLim)
title('Gyroscope')
hold off;

subplot(subplotRow,subplotColumn,3);
plot(plotTs, kittiDatasetRaw(:,AX), 'Color', 'red');
hold on;
plot(plotTs, kittiDatasetRaw(:,AY), 'Color', 'green');
plot(plotTs, kittiDatasetRaw(:,AZ), 'Color', 'blue');
xlim(xLim)
title('Accelerometer')
hold off;
