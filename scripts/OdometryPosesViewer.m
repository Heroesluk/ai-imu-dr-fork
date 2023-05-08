clear;

addpath('E:\GitHubRepositories\KITTI\downloads\raw_data\devkit\matlab');
addpath(genpath(pwd));

TAG = 'OdometryPosesViewer';

load 'OdometryMappingConfig.mat';

cRawDatasetFolderPath = 'E:\GitHubRepositories\KITTI\raw_data';
cOxtsFolderName = 'oxts';
cOxtsliteDataMatFileName = 'data.mat';
cOxtslitePoseMatFileName = 'pose.mat';
cOdometryPosesThumbnailFileName = 'OdometryPosesThumbnail';

figure;
timeReferenceSubPlotRows = 3;
timeReferenceSubPlotColumns = 4;
odometryMappingSize = size(ODOMETRY_MAPPING,1);
for i = 1 : odometryMappingSize
    tSequenceNumberString = ODOMETRY_MAPPING{i,1};
    tSequenceNumber = str2double(tSequenceNumberString);
    tSequenceName = ODOMETRY_MAPPING{i,2};
    tSequenceNameSplit = strsplit(tSequenceName,'_');
    tRawDateFolderName = strjoin(tSequenceNameSplit(1:3),'_');
    tRawDataFolderName = strcat(tSequenceName,'_extract');
    tRawDataFolderPath = fullfile(cRawDatasetFolderPath,tRawDateFolderName,tRawDataFolderName);

    if isfolder(tRawDataFolderPath)
        cOxtsliteDataMatFilePath = fullfile(tRawDataFolderPath,cOxtsFolderName,cOxtsliteDataMatFileName);
        if ~isfile(cOxtsliteDataMatFilePath)
            tOxtsliteData = loadOxtsliteData(tRawDataFolderPath);
            save(cOxtsliteDataMatFilePath,'tOxtsliteData');
        else
            load(cOxtsliteDataMatFilePath);
        end

        cOxtslitePoseMatFilePath = fullfile(tRawDataFolderPath,cOxtsFolderName,cOxtslitePoseMatFileName);
        if ~isfile(cOxtslitePoseMatFilePath)
            tOxtslitePose = convertOxtsToPose(tOxtsliteData);
            save(cOxtslitePoseMatFilePath,'tOxtslitePose');
        else
            load(cOxtslitePoseMatFilePath);
        end

        subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,tSequenceNumber+1);
        pPose = tOxtslitePose;
        hold on; 
        axis equal;
        l = 3; % coordinate axis length
        A = [0 0 0 1; l 0 0 1; 0 0 0 1; 0 l 0 1; 0 0 0 1; 0 0 l 1]';
        for j=1:100:length(pPose)
            B = pPose{j}*A;
            plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',2); % x: red
            plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',2); % y: green
            plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',2); % z: blue
        end
        xlabel('x (m)');
        ylabel('y (m)');
        zlabel('z (m)');
        titleText = sprintf('%s',tSequenceNumberString);
        title(titleText);
        hold off;

    end

    logMsg = sprintf('Sequence: %s',tSequenceNumberString);
    log2terminal('D',TAG,logMsg);
end


% http://gs.xjtu.edu.cn/info/1209/7605.htm
% 参考《西安交通大学博士、硕士学位论文模板（2021版）》中对图的要求
% 图尺寸的一般宽高比应为6.67 cm×5.00 cm。特殊情况下， 也可为
% 9.00 cm×6.75 cm， 或13.5 cm×9.00 cm。总之， 一篇论文中， 同类图片的
% 大小应该一致，编排美观、整齐；
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 13.5, 9.00]);
set(gca, 'lineWidth', 1.1, 'FontSize', 9, 'FontName', 'Times');

xlabel('Sample','FontSize',12);
ylabel('Nanosecond','FontSize',12);

cOdometryPosesThumbnailFilePath = fullfile(cRawDatasetFolderPath,cOdometryPosesThumbnailFileName);
print(gcf,cOdometryPosesThumbnailFilePath,'-dpng','-r600');


