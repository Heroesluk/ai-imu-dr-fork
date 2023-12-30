function [filterStateTime] = getFilterStateTime(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateTimeCell = filterState(:,1);
filterStateTime = cell2mat(filterStateTimeCell);

end