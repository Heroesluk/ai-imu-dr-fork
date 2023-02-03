clear;

load 'DataConfig.mat';

cDatasetRepoFolderPath = 'C:\GithubRepositories\ai-imu-dr\kitti\2011_09_26\2011_09_26_drive_0009_extract';

kittiDataset = readOneKittiDataset(cDatasetRepoFolderPath);

plotTs = kittiDataset(:,TS) - kittiDataset(1,TS);
xLimMin = floor(plotTs(1));
xLimMax = ceil(plotTs(end));
xLim = [xLimMin xLimMax]; 

figure();
subplotRow = 3;
subplotColumn = 1;

subplot(subplotRow,subplotColumn,1);
roll = rad2deg(kittiDataset(:,ROLL));
pitch = rad2deg(kittiDataset(:,PITCH));
yaw = rad2deg(kittiDataset(:,YAW));
plot(plotTs, roll, 'Color', 'red');
hold on; 
plot(plotTs, pitch, 'Color', 'green');
plot(plotTs, yaw, 'Color', 'blue');
xlim(xLim)
title('')
hold off;

subplot(subplotRow,subplotColumn,2);
plot(plotTs, kittiDataset(:,AF), 'Color', 'red');
hold on;
plot(plotTs, kittiDataset(:,AL), 'Color', 'green');
plot(plotTs, kittiDataset(:,AU), 'Color', 'blue');
xlim(xLim)
title('Accelerometer FLU')
hold off;

subplot(subplotRow,subplotColumn,3);
plot(plotTs, kittiDataset(:,AX), 'Color', 'red');
hold on;
plot(plotTs, kittiDataset(:,AY), 'Color', 'green');
plot(plotTs, kittiDataset(:,AZ), 'Color', 'blue');
xlim(xLim)
title('Accelerometer XYZ')
hold off;
