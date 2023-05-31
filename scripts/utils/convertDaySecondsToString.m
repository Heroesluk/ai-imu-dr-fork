function [outputArg1] = convertDaySecondsToString(daySeconds,timeZone)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

cConvertedTimeZone = 8;

cDatTimeDuration = hours(cConvertedTimeZone-timeZone) + seconds(daySeconds);

dayFormatTime = "hh:mm:ss.SSS";
convertedDayFormatTime = string(cDatTimeDuration, dayFormatTime);

outputArg1 = convertedDayFormatTime;

end