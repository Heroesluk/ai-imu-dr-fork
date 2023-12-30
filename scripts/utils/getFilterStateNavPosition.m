function [filterStateNavPosition] = getFilterStateNavPosition(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateNavPositionCell = filterState(:,4);
filterStateNavPosition = cell2mat(filterStateNavPositionCell);

end