% close all;
clear;
addpath(genpath(pwd));

S2MS = 1e3;
MS2S = 1/S2MS;
S2NS = 1e9;
NS2S = 1/S2NS;
MS2NS = 1e6;
NS2MS = 1/MS2NS;
US2NS = 1e3;
NS2US = 1/US2NS;

LEAPSECOND = 18;
LEAPNANOSECOND = LEAPSECOND * S2NS;

TAG = 'CustomViewerGnssViewer';

% https://waldyrious.net/viridis-palette-generator/
ViridisColerPalette05 = ["#fde725" "#5ec962" "#21918c" "#3b528b" "#440154"];
ViridisColerPalette11 = ["#fde725" "#bddf26" "#7ad151" "#44bf70" "#22a884" "#21918c" "#2a788e" "#355f8d" "#414487" "#482475" "#440154"];

% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_22\0010';
% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_22\Pixel\0002';

% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_23\MIAOMI\0002';
% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_23\HUAWEI\0001';

% cDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_24\0002';

cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_10\HUAWEI_Mate30\0018';
% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_10\GOOGLE_Pixel3\0018';

kRawFolderName = 'raw';

kSeneorGnssMeasurementFileName = 'GnssMeasurement.csv';

seneorGnssMeasurementFilePath = fullfile(cDatasetFolderPath,kRawFolderName,kSeneorGnssMeasurementFileName);
seneorGnssMeasurementRawData = loadGnssClockData(seneorGnssMeasurementFilePath,4);

systemCurrentTimeMillis = seneorGnssMeasurementRawData{:,1};
systemClockElapsedRealtimeNanos = seneorGnssMeasurementRawData{:,2};
localGnssClockOffsetNanos = seneorGnssMeasurementRawData{:,3};
gnssClockTimeNanos = seneorGnssMeasurementRawData{:,4};
gnssClockFullBiasNanos = seneorGnssMeasurementRawData{:,6};
gnssClockBiasNanos = seneorGnssMeasurementRawData{:,7};
gnssClockBiasUncertaintyNanos = seneorGnssMeasurementRawData{:,8};
gnssClockElapsedRealtimeNanos = seneorGnssMeasurementRawData{:,9};
gnssClockElapsedRealtimeUncertaintyNanos = seneorGnssMeasurementRawData{:,10};
gnssClockLeapSecond = seneorGnssMeasurementRawData{:,11};

[referenceZeroOClockDateTimeFromSystemClock, referenceZeroOClockFromSystemClockOffset] = getSystemCurrentTimeMillisMapZeroOClockTime(systemCurrentTimeMillis(1,1));
logMsg = sprintf('System clock based date: %s, time offset %f s', datestr(referenceZeroOClockDateTimeFromSystemClock,'yyyy-mm-dd HH:MM:ss.FFF'),referenceZeroOClockFromSystemClockOffset);
log2terminal('I',TAG,logMsg);
[referenceZeroOClockDateTimeFromGnssClock, referenceZeroOClockFromGnssClockOffset] = getGnssClockGpsTimeMapZeroOClockTime(localGnssClockOffsetNanos(1,1));
referenceZeroOClockLeapseconds = getZeroOClockTimeGpsTimeLeapseconds(referenceZeroOClockDateTimeFromGnssClock);
logMsg = sprintf('GNSS clock based date: %s, time offset %f s, leapseconds %d s', datestr(referenceZeroOClockDateTimeFromGnssClock,'yyyy-mm-dd HH:MM:ss.FFF'),referenceZeroOClockFromGnssClockOffset,referenceZeroOClockLeapseconds);
log2terminal('I',TAG,logMsg);

zSystemTime = systemCurrentTimeMillis - referenceZeroOClockFromSystemClockOffset * S2MS;
zBootTimeGpsClock = gnssClockTimeNanos - gnssClockFullBiasNanos - gnssClockElapsedRealtimeNanos - int64(referenceZeroOClockFromGnssClockOffset * S2NS) - int64(referenceZeroOClockLeapseconds * S2NS);


N = length(systemCurrentTimeMillis);

%%% Raw data analysis
minGnssClockFullBiasNanos = min(gnssClockFullBiasNanos);
maxGnssClockFullBiasNanos = max(gnssClockFullBiasNanos);
range = maxGnssClockFullBiasNanos - minGnssClockFullBiasNanos;
figure();
timeSeriesSubPlotRows = 2;
timeSeriesSubPlotColumns = 1;
subplot(timeSeriesSubPlotRows,timeSeriesSubPlotColumns,1);
pReferenceGnssClockFullBiasNanos = -floor(-minGnssClockFullBiasNanos * NS2US + 1) * US2NS;
pGnssClockFullBiasNanos = gnssClockFullBiasNanos - pReferenceGnssClockFullBiasNanos;
plot(pGnssClockFullBiasNanos);
xlabel('Sample');
ylabel('Nanosecond');
title('gnssClock.getFullBiasNanos() stability');
subplot(timeSeriesSubPlotRows,timeSeriesSubPlotColumns,2);
plot(gnssClockBiasUncertaintyNanos);
xlabel('Sample');
ylabel('Nanosecond');
title('gnssClock.getBiasUncertaintyNanos() stability');


figure();
timeSeriesSubPlotRows = 2;
timeSeriesSubPlotColumns = 1;
subplot(timeSeriesSubPlotRows,timeSeriesSubPlotColumns,1);
pGnssMinusSystemClockElapsedRealtimeNanos = gnssClockElapsedRealtimeNanos - systemClockElapsedRealtimeNanos;
plot(pGnssMinusSystemClockElapsedRealtimeNanos);
xlabel('Sample');
ylabel('Nanosecond');
title('GNSS clock minus System clock elapsed realtime nanos');
subplot(timeSeriesSubPlotRows,timeSeriesSubPlotColumns,2);
plot(gnssClockElapsedRealtimeUncertaintyNanos);
xlabel('Sample');
ylabel('Nanosecond');
title('gnssClock.getElapsedRealtimeUncertaintyNanos() stability');



%%% Time reference analysis
systemDuration = zSystemTime(N,1) - zSystemTime(1,1);
logMsg = sprintf('System.currentTimeMillis() delta time: %.9f s', double(systemDuration)*MS2S);
log2terminal('I',TAG,logMsg);
systemClockDuration = systemClockElapsedRealtimeNanos(N,1) - systemClockElapsedRealtimeNanos(1,1);
logMsg = sprintf('SystemClock.elapsedRealtimeNanos() delta time: %.9f s', double(systemClockDuration)*NS2S);
log2terminal('I',TAG,logMsg);

bootTimeNanosSystemClock = zSystemTime * MS2NS - systemClockElapsedRealtimeNanos;
minBootTimeNanosSystemClock = min(bootTimeNanosSystemClock);
pReferenceBootTimeNanosSystemClock = floor(minBootTimeNanosSystemClock * NS2MS) * MS2NS;
figure();
timeReferenceSubPlotRows = 3;
timeReferenceSubPlotColumns = 1;
subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
pBootTimeNanosSystemClock = bootTimeNanosSystemClock - pReferenceBootTimeNanosSystemClock;
plot(pBootTimeNanosSystemClock);
ax = gca;
ax.YAxis.Exponent = 6;
xlabel('Sample');
ylabel('Nanosecond');
title('System clock based boot time');
pBootTimeNanosSystemClockDouble = double(pBootTimeNanosSystemClock);
pBootTimeNanosSystemBaseMean = mean(pBootTimeNanosSystemClockDouble);
pBootTimeNanosSystemBaseStd = std(pBootTimeNanosSystemClockDouble);
logMsg = sprintf('System clock based boot time value offset: %d ms, mean %.3f ms, std %.3f ms',pReferenceBootTimeNanosSystemClock*NS2MS,pBootTimeNanosSystemBaseMean*NS2MS,pBootTimeNanosSystemBaseStd*NS2MS);
log2terminal('I',TAG,logMsg);

minBootTimeNanosGnssClock = min(zBootTimeGpsClock);
pMinBootTimeNanosGnssClock = floor(minBootTimeNanosGnssClock * NS2MS) * MS2NS;
subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
pBootTimeNanosGnssClock = zBootTimeGpsClock - pMinBootTimeNanosGnssClock;
plot(pBootTimeNanosGnssClock);
ax = gca;
ax.YAxis.Exponent = 6;
xlabel('Sample');
ylabel('Nanosecond');
title('GNSS clock based boot time');
pBootTimeNanosGnssClockDouble = double(pBootTimeNanosGnssClock);
pGpsSystemClockTimeOffsetMean = mean(pBootTimeNanosGnssClockDouble);
pGpsSystemClockTimeOffsetStd = std(pBootTimeNanosGnssClockDouble);
logMsg = sprintf('GNSS clock based boot time value offset: %d ms, mean %.3f ms, std %.3f ms',pMinBootTimeNanosGnssClock*NS2MS,pGpsSystemClockTimeOffsetMean*NS2MS,pGpsSystemClockTimeOffsetStd*NS2MS);
log2terminal('I',TAG,logMsg);

subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,3);
dSystemMinusGnssClockTimeOffset = bootTimeNanosSystemClock - zBootTimeGpsClock;
plot(dSystemMinusGnssClockTimeOffset);
ax = gca;
ax.YAxis.Exponent = 6;
xlabel('Sample') ;
ylabel('Nanosecond');
title('System minus GNSS clock offset');


%%% Time series analysis
figure;
timeSeriesSubPlotRows = 2;
timeSeriesSubPlotColumns = 2;
subplot(timeSeriesSubPlotRows,timeSeriesSubPlotColumns,1);
pGnssMeasurementEventNanosSystemClock = zSystemTime * MS2NS + pGnssMinusSystemClockElapsedRealtimeNanos;
plot(pGnssMeasurementEventNanosSystemClock);
xlabel('Sample');
ylabel('Nanosecond');
title('System clock based sample time');
subplot(timeSeriesSubPlotRows,timeSeriesSubPlotColumns,3);
dGnssMeasurementEventNanosSystemClock = pGnssMeasurementEventNanosSystemClock(2:N,1) - pGnssMeasurementEventNanosSystemClock(1:(N-1),1);
pGnssMeasurementEventNanosSystemClock = dGnssMeasurementEventNanosSystemClock - 1 * S2NS;
plot(pGnssMeasurementEventNanosSystemClock);
xlabel('Sample') ;
ylabel('Nanosecond');
title('System clock based sample interval');

subplot(timeSeriesSubPlotRows,timeSeriesSubPlotColumns,2);
zGnssMeasurementEventNanosGnssClock = gnssClockTimeNanos - gnssClockFullBiasNanos - int64(referenceZeroOClockFromGnssClockOffset * S2NS) - int64(referenceZeroOClockLeapseconds * S2NS);
plot(zGnssMeasurementEventNanosGnssClock);
xlabel('Sample');
ylabel('Nanosecond');
title('Gnss clock based sample time');
subplot(timeSeriesSubPlotRows,timeSeriesSubPlotColumns,4);
dGnssMeasurementEventNanosGnssClock = zGnssMeasurementEventNanosGnssClock(2:N,1) - zGnssMeasurementEventNanosGnssClock(1:(N-1),1);
pGnssMeasurementEventNanosGnssClock = dGnssMeasurementEventNanosGnssClock - 1 * S2NS;
plot(pGnssMeasurementEventNanosGnssClock);
xlabel('Sample') ;
ylabel('Nanosecond');
title('Gnss clock based sample interval');


figure('name', '1');
estimatedGpsTime = gnssClockTimeNanos - gnssClockFullBiasNanos;
systemBootTimeNanosGpsReferenceGnssMeasurementEventBase = estimatedGpsTime - gnssClockElapsedRealtimeNanos;
minSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase = min(systemBootTimeNanosGpsReferenceGnssMeasurementEventBase);
pReferenceSystemBootTimeNanosGpsRefGnssMeasurementEventBase = floor(minSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase * NS2US) * US2NS;
pSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase = systemBootTimeNanosGpsReferenceGnssMeasurementEventBase - pReferenceSystemBootTimeNanosGpsRefGnssMeasurementEventBase;
plot(pSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase,'Color',ViridisColerPalette05(3));
hold on;

pUpperSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase = pSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase + int64(gnssClockElapsedRealtimeUncertaintyNanos);
pLowerSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase = pSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase - int64(gnssClockElapsedRealtimeUncertaintyNanos);
plot(pUpperSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase,'LineStyle','--','Color',ViridisColerPalette05(2));
plot(pLowerSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase,'LineStyle','--','Color',ViridisColerPalette05(4));

pMinValueUpperSystemBootTimeNanosGpsRefGnssMeasurementEventBase = min(pUpperSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase);
pMaxValueLowerSystemBootTimeNanosGpsRefGnssMeasurementEventBase = max(pLowerSystemBootTimeNanosGpsReferenceGnssMeasurementEventBase);
pUpperSystemBootTimeNanosGpsRefGnssMeasurementEventBase = ones(N,1,'int64') * pMinValueUpperSystemBootTimeNanosGpsRefGnssMeasurementEventBase;
pLowerSystemBootTimeNanosGpsRefGnssMeasurementEventBase = ones(N,1,'int64') * pMaxValueLowerSystemBootTimeNanosGpsRefGnssMeasurementEventBase;
plot(pUpperSystemBootTimeNanosGpsRefGnssMeasurementEventBase,'LineStyle','--','Color',ViridisColerPalette05(1));
plot(pLowerSystemBootTimeNanosGpsRefGnssMeasurementEventBase,'LineStyle','--','Color',ViridisColerPalette05(5));

ax = gca;
ax.YAxis.Exponent = 6;
xlabel('Sample') ;
ylabel('Nanosecond');
title('Estimated system boot GPS time stability');
hold off;



