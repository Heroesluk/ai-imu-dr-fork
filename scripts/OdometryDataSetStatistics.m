clear;

load 'OdometryMappingConfig.mat';

cOdometryDatasetFolderPath = 'E:\GitHubRepositories\KITTI\odometry\dataset';
cOdometryStatisticsFileName = 'OdometryStatistics.csv';

kPosesFolderName = 'poses';
kSequencesFolderName = 'sequences';
kSequenceTimesFileName = 'times.txt';

sequencesFolderPath = fullfile(cOdometryDatasetFolderPath,kSequencesFolderName);
sequencesFolderDir = dir(sequencesFolderPath);
sequencesFolderDirLength = length(sequencesFolderDir);
odometryStatistics = cell(sequencesFolderDirLength-2,9);
for i = 1 : sequencesFolderDirLength
    sequenceName = sequencesFolderDir(i).name;

    if isequal(sequenceName,'.') || isequal(sequenceName,'..')
        continue;
    end

    if sequencesFolderDir(i).isdir
        saveIndex = i - 2;
        odometryStatistics{saveIndex,1} = sequenceName;

        sequenceTimesFilePath = fullfile(sequencesFolderPath,sequenceName,kSequenceTimesFileName);
        sequenceTimes = readmatrix(sequenceTimesFilePath);        
        odometryStatistics{saveIndex,2} = length(sequenceTimes);
        odometryStatistics{saveIndex,3} = sequenceTimes(end);

        sequenceTrain = find(ismember(ODOMETRY_MAPPING(:,1),sequenceName));
        if length(sequenceTrain) == 1
            odometryStatistics{saveIndex,4} = ODOMETRY_MAPPING{sequenceTrain,2};
            filter = ODOMETRY_MAPPING{sequenceTrain,3};
            odometryStatistics{saveIndex,5} = filter(1);
            odometryStatistics{saveIndex,6} = filter(2);

            sequencePosesFileName = strcat(sequenceName,'.txt');
            sequencePosesFilePath = fullfile(cOdometryDatasetFolderPath,kPosesFolderName,sequencePosesFileName);
            sequencePoses = readmatrix(sequencePosesFilePath);
            sequencePosition = sequencePoses(:,[4 8 12]);
            distance = sum(sqrt(sum((sequencePosition(2:end,:)-sequencePosition(1:end-1,:)).^2, 2)));
            odometryStatistics{saveIndex,7} = distance;
        end

    end
end

odometryStatisticsFilePath = fullfile(cOdometryDatasetFolderPath,cOdometryStatisticsFileName);
writecell(odometryStatistics,odometryStatisticsFilePath);

