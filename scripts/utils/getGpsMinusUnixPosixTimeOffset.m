function [outputArg1] = getGpsMinusUnixPosixTimeOffset()
%UNTITLED3 此处提供此函数的摘要
%   此处提供详细说明
rUnixReferenceDateTime = datetime(1970,1,1);
rUnixReferencePosixTime = convertTo(rUnixReferenceDateTime,'posixtime');
rGpsReferenceDateTime = datetime(1980,1,6);
rGpsReferencePosixTime = convertTo(rGpsReferenceDateTime,'posixtime');
dGPSMinusUnixPosixTimeOffset = rGpsReferencePosixTime - rUnixReferencePosixTime;

outputArg1 = dGPSMinusUnixPosixTimeOffset;

end