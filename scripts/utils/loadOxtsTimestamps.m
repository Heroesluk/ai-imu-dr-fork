function ts = loadOxtsTimestamps(ts_dir)

ts = [];

cOxtsSensorTimestampsFilePath = fullfile(ts_dir,'oxts','timestamps.txt');
if isfile(cOxtsSensorTimestampsFilePath)
    oxtsSensorTimestampsTable = readtable(cOxtsSensorTimestampsFilePath);
    oxtsSensorTimestampsTableHeight = height(oxtsSensorTimestampsTable);
    oxtsSensorTimeData = zeros(oxtsSensorTimestampsTableHeight, 1);
    for i = 1:oxtsSensorTimestampsTableHeight
        oxtsSensorIteratorDateTime = oxtsSensorTimestampsTable.Var1(i);
        oxtsSensorTimeData(i, 1) = oxtsSensorIteratorDateTime.Hour * 3600 + oxtsSensorIteratorDateTime.Minute * 60 + oxtsSensorIteratorDateTime.Second;
    end
    ts = oxtsSensorTimeData;
end
