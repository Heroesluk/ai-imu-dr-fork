NS2MS = 1e-6;
S2MS = 1e3;
MS2S = 1/S2MS;

% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_14\0006';

cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\HUAWEI\0021';
% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\SAMSUNG\0021';
% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\PIXEL\0010';  

% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_03_01\HUAWEI\0001';
% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_03_01\PIXEL\0001';

kRawFolderName = 'raw';

kSeneorGNSSFileName = 'GnssLocation.csv';

seneorGNSSFilePath = fullfile(cDatasetFolderPath,kRawFolderName,kSeneorGNSSFileName);
seneorGNSSRawData = readmatrix(seneorGNSSFilePath);

N = length(seneorGNSSRawData);

systemCurrentTimeHeadMillis = seneorGNSSRawData(1,1);
systemCurrentTimeHeadSecond = systemCurrentTimeHeadMillis * MS2S;
systemCurrentTimeHeadDateTime = datetime(systemCurrentTimeHeadSecond,'ConvertFrom','posixtime','TimeZone','Asia/Shanghai');
zeroReferenceTimeDateTime = datetime(systemCurrentTimeHeadDateTime.Year,systemCurrentTimeHeadDateTime.Month,systemCurrentTimeHeadDateTime.Day);
zeroReferenceTimeSecond = convertTo(zeroReferenceTimeDateTime,'posixtime');
zeroReferenceTimeTimeMillis = zeroReferenceTimeSecond * S2MS;

systemClockElapsedRealtimeMillis = seneorGNSSRawData(:,2) .* NS2MS;
locationElapsedRealtimeMillis = seneorGNSSRawData(:,4) .* NS2MS;
locationMinusSystemClockElapsedRealtimeNanos = seneorGNSSRawData(:,4) - seneorGNSSRawData(:,2);
locationMinusSystemClockElapsedRealtimeMillis = locationMinusSystemClockElapsedRealtimeNanos .* NS2MS;

figure;
plot(seneorGNSSRawData(:,7),seneorGNSSRawData(:,8));


systemCurrentTimeMinusClockElapsedRealtimeMillis = seneorGNSSRawData(:,1) - systemClockElapsedRealtimeMillis;
rSystemCurrentTimeMinusClockElapsedRealtimeMillis = systemCurrentTimeMinusClockElapsedRealtimeMillis - zeroReferenceTimeTimeMillis;
% figure;
% plot(rSystemCurrentTimeMinusClockElapsedRealtimeMillis);

locationTimeMinusElapsedRealtimeMillis = seneorGNSSRawData(:,3) - systemClockElapsedRealtimeMillis;
rLocationTimeMinusElapsedRealtimeMillis = locationTimeMinusElapsedRealtimeMillis - zeroReferenceTimeTimeMillis;
% figure;
% plot(rLocationTimeMinusElapsedRealtimeMillis);

locationTimeMinusLoactionPlueSystemElapsedRealtimeMillis = systemCurrentTimeMinusClockElapsedRealtimeMillis + systemClockElapsedRealtimeMillis;
dLocationMinusSystemCurrentTimeMillis = locationTimeMinusLoactionPlueSystemElapsedRealtimeMillis - locationTimeMinusLoactionPlueSystemElapsedRealtimeMillis;
% figure;
% plot(dLocationMinusSystemCurrentTimeMillis);

systemCurrentTimePlusLocationMinusSystemClockERMillis = seneorGNSSRawData(:,1) + locationMinusSystemClockElapsedRealtimeMillis;
rSystemCurrentTimePlusLocationMinusSystemClockERMillis = systemCurrentTimePlusLocationMinusSystemClockERMillis - zeroReferenceTimeTimeMillis;
rSystemCurrentTimePlusLocationMinusSystemClockERSecond = rSystemCurrentTimePlusLocationMinusSystemClockERMillis * MS2S;

dSystemCurrentTimePlusocationMinusSystemClockERMillis = rSystemCurrentTimePlusLocationMinusSystemClockERMillis(2:N,1) - rSystemCurrentTimePlusLocationMinusSystemClockERMillis(1:(N-1),1);
% figure('name', '4');
% plot(rSystemCurrentTimePlusocationMinusSystemClockERMillis);

% figure('name', '5');
% plot(dSystemCurrentTimePlusocationMinusSystemClockERMillis - 1000);


figure('name', '6');
plot(systemCurrentTimePlusLocationMinusSystemClockERMillis - seneorGNSSRawData(:,3));


% figure;
% plot(seneorGNSSRawData(:,1) - seneorGNSSRawData(:,3));


locationTimePlusSystemClockMinusLocationERMillis = seneorGNSSRawData(:,3) - locationMinusSystemClockElapsedRealtimeMillis;
rLocationTimePlusSystemClockMinusLocationERMillis = locationTimePlusSystemClockMinusLocationERMillis - zeroReferenceTimeTimeMillis;
rLocationTimePlusSystemClockMinusLocationERSecond = rLocationTimePlusSystemClockMinusLocationERMillis * MS2S;

dLocationTimePlusSystemClockMinusLocationERSecond = rLocationTimePlusSystemClockMinusLocationERSecond(2:N,1) - rLocationTimePlusSystemClockMinusLocationERSecond(1:(N-1),1);
figure('name', '4');
plot(locationTimePlusSystemClockMinusLocationERMillis - seneorGNSSRawData(:,1));

