function [outputArg1,outputArg2] = getGnssClockGpsTimeMapZeroOClockTime(gnssClockGpsTime)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
rGpsReferenceDateTime = datetime(1980,1,6);
rGpsReferencePosixTime = convertTo(rGpsReferenceDateTime,'posixtime');
gnssClockGpsTimeSecond = gnssClockGpsTime * 1e-9;
gnssClockPosixTimeSecond = rGpsReferencePosixTime + gnssClockGpsTimeSecond;
gnssClockDateTime = datetime(gnssClockPosixTimeSecond,'ConvertFrom','posixtime','TimeZone','Asia/Shanghai');
gnssClockZeroOClockTimeDateTime = datetime(gnssClockDateTime.Year,gnssClockDateTime.Month,gnssClockDateTime.Day);
gnssClockZeroOClockTimePosixTime = convertTo(gnssClockZeroOClockTimeDateTime,'posixtime');
dGnssClockZeroOClockTimeOffset = gnssClockZeroOClockTimePosixTime - rGpsReferencePosixTime;

outputArg1 = gnssClockZeroOClockTimeDateTime;
outputArg2 = dGnssClockZeroOClockTimeOffset;
end