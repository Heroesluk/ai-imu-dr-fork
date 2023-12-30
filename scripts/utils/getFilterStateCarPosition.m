function [filterStateCarPosition] = getFilterStateCarPosition(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateCarPositionCell = filterState(:,8);
filterStateCarPosition = cell2mat(filterStateCarPositionCell);

end