close all;
clear;
addpath(genpath(pwd));

TAG = 'ReorganizeDatasetsFolderStructure';

cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_11';
cSmartPhoneFolderNameList = ["HUAWEI_Mate30" "HUAWEI_P20" "GOOGLE_Pixel3"];
cSmartPhoneFolderNameListLength = length(cSmartPhoneFolderNameList);

cReorganizedFolderName = 'Reorganized';
cReorganizedFolderPath = fullfile(cDatasetFolderPath,cReorganizedFolderName);
if ~isfolder(cReorganizedFolderPath)
    mkdir(cReorganizedFolderPath);
end

for i = 1:cSmartPhoneFolderNameListLength
    tSmartPhoneFolderName = cSmartPhoneFolderNameList(i);
    tSmartPhoneFolderPath = fullfile(cDatasetFolderPath,tSmartPhoneFolderName);
    tSmartPhoneFolderDir = dir(tSmartPhoneFolderPath);
    tSmartPhoneFolderDirLength = length(tSmartPhoneFolderDir);
    for j = 1:tSmartPhoneFolderDirLength
        tSmartPhoneTrackFolderNameStr = tSmartPhoneFolderDir(j).name;
        if ~strcmp(tSmartPhoneTrackFolderNameStr,'.') && ~strcmp(tSmartPhoneTrackFolderNameStr,'..')
            tSmartPhoneTrackFolderPath = fullfile(tSmartPhoneFolderPath,tSmartPhoneTrackFolderNameStr);
            if isfolder(tSmartPhoneTrackFolderPath)
                reorganizedTrackFolderPath = fullfile(cReorganizedFolderPath,tSmartPhoneTrackFolderNameStr);
                if ~isfolder(reorganizedTrackFolderPath)
                    mkdir(reorganizedTrackFolderPath);
                end
                reorganizedTrackSmartPhoneFolderPath = fullfile(reorganizedTrackFolderPath,tSmartPhoneFolderName);
                if ~isfolder(reorganizedTrackSmartPhoneFolderPath)
                    mkdir(reorganizedTrackSmartPhoneFolderPath);
                    status = copyfile(tSmartPhoneTrackFolderPath,reorganizedTrackSmartPhoneFolderPath);
                    logMsg = sprintf('Copied folder %s to %s',tSmartPhoneTrackFolderPath,reorganizedTrackSmartPhoneFolderPath);
                    log2terminal('I',TAG,logMsg);
                end
            end
        end
    end
end

