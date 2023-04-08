clear;

load 'OdometryMappingConfig.mat';

cDownloadFolderPath = 'E:\GitHubRepositories\KITTI\raw_data';

odometryMappingLength = length(ODOMETRY_MAPPING);
for i = 1 : odometryMappingLength
    sequenceName = ODOMETRY_MAPPING{i,2};
    for j = 0 : 9
        thumbnailSequence = sprintf('%02d',j);
        thumbnailName = strcat(thumbnailSequence, '.jpg');
        thumbnailFilePath = fullfile(cDownloadFolderPath,sequenceName,'thumbnails',thumbnailName);
        thumbnailUrl = sprintf('https://s3.eu-central-1.amazonaws.com/avg-kitti/raw_data/%s/thumbnails/%s',sequenceName,thumbnailName);
        try
            thumbnailFileFullPath = websave(thumbnailFilePath, thumbnailUrl);
            fprintf('Save %s\n', thumbnailFileFullPath);
        catch ME
            disp(ME.message);
        end
    end
end
