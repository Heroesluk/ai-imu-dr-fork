function [outputArg1] = readOneKittiDataset(folderPath)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明

cOxtsSensorFolderName = 'oxts';
cKittiDatasetFileName = 'dataoxts.mat';
cKittiDatasetFilePath = fullfile(folderPath,cOxtsSensorFolderName,cKittiDatasetFileName);

if exist(cKittiDatasetFilePath,'file')
    cKittiDatasetStructure = load(cKittiDatasetFilePath);
    outputArg1 = cKittiDatasetStructure.oxtsSensorData;
else
    cOxtsSensorDataFolderName = 'data';
    cOxtsSensorTimestampsFileName = 'timestamps.txt';
    
    cOxtsSensorTimestampsFilePath = fullfile(folderPath,cOxtsSensorFolderName,cOxtsSensorTimestampsFileName);
    oxtsSensorTimestampsTable = readtable(cOxtsSensorTimestampsFilePath);
    oxtsSensorTimestampsTableHeight = height(oxtsSensorTimestampsTable);
    oxtsSensorTimeData = zeros(oxtsSensorTimestampsTableHeight, 1);
    for i = 1:oxtsSensorTimestampsTableHeight
        oxtsSensorIteratorDateTime = oxtsSensorTimestampsTable.Var1(i);
        oxtsSensorTimeData(i, 1) = oxtsSensorIteratorDateTime.Hour * 3600 + oxtsSensorIteratorDateTime.Minute * 60 + oxtsSensorIteratorDateTime.Second;
    end
    
    oxtsSensorData = zeros(oxtsSensorTimestampsTableHeight, 31);
    oxtsSensorData(:,1) = oxtsSensorTimeData;
    cOxtsSensorDataFolderPath = fullfile(folderPath,cOxtsSensorFolderName,cOxtsSensorDataFolderName);
    oxtsSensorDataDir = dir(cOxtsSensorDataFolderPath);
    for i = 1 : length(oxtsSensorDataDir)
        if oxtsSensorDataDir(i).isdir
            continue;
        end
        
        oxtsSensorDataNameStr = oxtsSensorDataDir(i).name;
        oxtsSensorDataPath = fullfile(cOxtsSensorDataFolderPath,oxtsSensorDataNameStr);
        oxtsSensorDataIterator = readmatrix(oxtsSensorDataPath,'Delimiter', ' ');
        [~,oxtsSensorDataName,~] = fileparts(oxtsSensorDataPath);
        oxtsSensorDataNameNum = str2double(oxtsSensorDataName);
        oxtsSensorData(oxtsSensorDataNameNum+1,2:end) = oxtsSensorDataIterator;
    end
    
    save(cKittiDatasetFilePath,'oxtsSensorData');
    outputArg1 = oxtsSensorData;
end

end

