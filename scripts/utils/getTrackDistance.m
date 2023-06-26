function distance = getTrackDistance(trackCoordinate)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

trackCoordinateSize = size(trackCoordinate,1);
dTrackCoordinate = trackCoordinate(2:trackCoordinateSize,:) -  trackCoordinate(1:trackCoordinateSize-1,:);
dTrackDistance = sqrt(sum(dTrackCoordinate .^ 2, 2));
distance = sum(dTrackDistance);

end