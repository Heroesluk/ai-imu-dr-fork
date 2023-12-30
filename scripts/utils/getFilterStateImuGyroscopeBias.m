function [filterStateImuGyroscopeBias] = getFilterStateImuGyroscopeBias(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateImuGyroscopeBiasCell = filterState(:,5);
filterStateImuGyroscopeBias = cell2mat(filterStateImuGyroscopeBiasCell);

end