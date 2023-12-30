function [filterStateNavVelocity] = getFilterStateNavVelocity(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateNavVelocityCell = filterState(:,3);
filterStateNavVelocity = cell2mat(filterStateNavVelocityCell);

end