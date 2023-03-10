function [outputArg1] = loadSpanRawImuData(spanRawImuDataFilePath)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

TAG = 'loadSpanRawImuData';

[folderPath,name,~] = fileparts(spanRawImuDataFilePath);
loadedSpanRawImuDataFileName = strcat(name,'.mat');
loadedSpanRawImuDataFilePath = fullfile(folderPath,loadedSpanRawImuDataFileName);

if exist(loadedSpanRawImuDataFilePath,'file')
    loadedSpanRawImuDataStructure = load(loadedSpanRawImuDataFilePath);
    outputArg1 = loadedSpanRawImuDataStructure.spanRawImuData;
else

    LOG_HEADER = '$RAWIMU';
    LOG_HEADER_LENGTH = strlength(LOG_HEADER);
    LOG_HEADER_POS = LOG_HEADER_LENGTH + 1;

    fid = fopen(spanRawImuDataFilePath);

    % SPAN on OEM6 Firmware Reference Manual OM-2000144 Rev8 December 2016 5.2.41 RAWIMU
    spanRawImuDataFormatSpec = LOG_HEADER;
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % GPS week
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % Week second
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % Gyroscope X
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % Gyroscope Y
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % Gyroscope Z
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % Accelerometer X
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % Accelerometer Y
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % Accelerometer Z
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, ',%f64');    % Temperature
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, '*%s');    %
    spanRawImuDataFormatSpec = strcat(spanRawImuDataFormatSpec, '\n');

    spanRawImuData = [];

    t1DateTime = datetime('now');
    t1DateStr = datestr(t1DateTime,'yyyy-mm-dd HH:MM:ss.FFF');
    logMsg = sprintf('Start time %s',t1DateStr);
    log2terminal('I',TAG,logMsg);
    n = 0;
    while ~feof(fid)
        tLine = fgetl(fid);
        n = n + 1;
        tLineLength = strlength(tLine);
        if tLineLength >= LOG_HEADER_LENGTH
            extractLogHeader = extractBefore(tLine,LOG_HEADER_POS);
            if strcmp(extractLogHeader,LOG_HEADER)
                scannedLineRawImuData = textscan(fid,spanRawImuDataFormatSpec);
                scannedRawImuData = cell2mat(scannedLineRawImuData(1,1:9));
                spanRawImuData = [spanRawImuData;scannedRawImuData];
            end
        end
    end
    t2DateTime = datetime('now');
    dt = t2DateTime - t1DateTime;
    dtSecond = seconds(dt);
    t2DateStr = datestr(t2DateTime,'yyyy-mm-dd HH:MM:ss.FFF');
    logMsg = sprintf('End time %s',t2DateStr);
    log2terminal('I',TAG,logMsg);
    logMsg = sprintf('Scanned line: %d, time spent %.0f s',n,dtSecond);
    log2terminal('I',TAG,logMsg);

    fclose(fid);

    save(loadedSpanRawImuDataFilePath,'spanRawImuData');
    outputArg1 = spanRawImuData;
end


end