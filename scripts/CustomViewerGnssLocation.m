NS2MS = 1e-6;
S2MS = 1e3;
MS2S = 1/S2MS;

% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_14\0006';

% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\HUAWEI\0021';
% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\SAMSUNG\0021';
% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\PIXEL\0010';  

% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_03_01\HUAWEI\0001';
% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_03_01\PIXEL\0001';

cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_10\HUAWEI_Mate30\0018';
% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_10\GOOGLE_Pixel3\0018';


kRawFolderName = 'raw';

kSeneorGNSSFileName = 'GnssLocation.csv';

seneorGNSSFilePath = fullfile(cDatasetFolderPath,kRawFolderName,kSeneorGNSSFileName);
seneorGNSSRawData = readmatrix(seneorGNSSFilePath);
N = length(seneorGNSSRawData);

figure;
plot(seneorGNSSRawData(:,7),seneorGNSSRawData(:,8));

systemTime = seneorGNSSRawData(:,1);
systemClockTime = seneorGNSSRawData(:,2);
gpsSystemClockTimeOffset = seneorGNSSRawData(:,3);
locationSystemTime = seneorGNSSRawData(:,4);
locationsystemClockTime = seneorGNSSRawData(:,5);

[referenceZeroOClockDateTimeFromSystemClock, referenceZeroOClockOffsetFromSystemClock] = getSystemCurrentTimeMillisMapZeroOClockTime(systemTime(1,1));
rZOCSystemTime = systemTime - referenceZeroOClockOffsetFromSystemClock * S2MS;
rZOCLocationSystemTime = locationSystemTime - referenceZeroOClockOffsetFromSystemClock * S2MS;

bootTimeNanosSystemClock = rZOCSystemTime * MS2NS - systemClockTime;
minBootTimeNanosSystemClock = min(bootTimeNanosSystemClock);
pReferenceBootTimeNanosSystemClock = floor(minBootTimeNanosSystemClock * NS2MS) * MS2NS;
figure();
timeReferenceSubPlotRows = 3;
timeReferenceSubPlotColumns = 1;
pBootTimeNanosSystemClock = bootTimeNanosSystemClock;
pBootTimeNanosLocationGnssClock = rZOCLocationSystemTime * MS2NS - locationsystemClockTime;
plot(pBootTimeNanosSystemClock);
hold on;
plot(pBootTimeNanosLocationGnssClock);
hold off;
ax = gca;
ax.YAxis.Exponent = 6;
xlabel('Sample');
ylabel('Nanosecond');
title('System clock based boot time');
pBootTimeNanosSystemBaseMean = mean(pBootTimeNanosSystemClock);
pBootTimeNanosSystemBaseStd = std(pBootTimeNanosSystemClock);
logMsg = sprintf('System clock based boot time value offset: %d ms, mean %.3f ms, std %.3f ms',pReferenceBootTimeNanosSystemClock*NS2MS,pBootTimeNanosSystemBaseMean*NS2MS,pBootTimeNanosSystemBaseStd*NS2MS);
log2terminal('I',TAG,logMsg);

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


% figure('name', '6');
% plot(systemCurrentTimePlusLocationMinusSystemClockERMillis - seneorGNSSRawData(:,3));


% figure;
% plot(seneorGNSSRawData(:,1) - seneorGNSSRawData(:,3));


% locationTimePlusSystemClockMinusLocationERMillis = seneorGNSSRawData(:,3) - locationMinusSystemClockElapsedRealtimeMillis;
% rLocationTimePlusSystemClockMinusLocationERMillis = locationTimePlusSystemClockMinusLocationERMillis - zeroReferenceTimeTimeMillis;
% rLocationTimePlusSystemClockMinusLocationERSecond = rLocationTimePlusSystemClockMinusLocationERMillis * MS2S;
% 
% dLocationTimePlusSystemClockMinusLocationERSecond = rLocationTimePlusSystemClockMinusLocationERSecond(2:N,1) - rLocationTimePlusSystemClockMinusLocationERSecond(1:(N-1),1);
% figure('name', '4');
% plot(locationTimePlusSystemClockMinusLocationERMillis - seneorGNSSRawData(:,1));

