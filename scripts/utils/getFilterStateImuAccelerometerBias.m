function [filterStateImuAccelerometerBias] = getFilterStateImuAccelerometerBias(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateImuAccelerometerBiasCell = filterState(:,6);
filterStateImuAccelerometerBias = cell2mat(filterStateImuAccelerometerBiasCell);

end