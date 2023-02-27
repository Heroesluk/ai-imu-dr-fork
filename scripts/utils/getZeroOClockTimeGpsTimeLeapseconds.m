function [outputArg1] = getZeroOClockTimeGpsTimeLeapseconds(zeroOClockTime)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
rGpsReferenceDateTime = datetime(1980,1,6);
leapsecondsTable = leapseconds;
searchedTimeRange = timerange(rGpsReferenceDateTime,zeroOClockTime);
searchedLeapsecondsTable = leapsecondsTable(searchedTimeRange,:);
searchedLeapsecondsTableHeadType = searchedLeapsecondsTable.Type(1);
searchedLeapsecondsTableHeadCumulativeAdjustment = searchedLeapsecondsTable.CumulativeAdjustment(1);
searchedLeapsecondsTableHeadSeconds = seconds(searchedLeapsecondsTableHeadCumulativeAdjustment);
if searchedLeapsecondsTableHeadType == '-'
    searchedLeapsecondsTableHeadSeconds = -searchedLeapsecondsTableHeadSeconds;
end
searchedLeapsecondsTableTailType = searchedLeapsecondsTable.Type(end);
searchedLeapsecondsTableTailCumulativeAdjustment = searchedLeapsecondsTable.CumulativeAdjustment(end);
searchedLeapsecondsTableTailSeconds = seconds(searchedLeapsecondsTableTailCumulativeAdjustment);
if searchedLeapsecondsTableTailType == '-'
    searchedLeapsecondsTableTailSeconds = -searchedLeapsecondsTableTailSeconds;
end

outputArg1 = searchedLeapsecondsTableTailSeconds - searchedLeapsecondsTableHeadSeconds + 1;
end