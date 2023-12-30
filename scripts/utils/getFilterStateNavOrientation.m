function [filterStateNavOrientation] = getFilterStateNavOrientation(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateNavOrientationCell = filterState(:,2);
filterStateNavOrientationFlat = cell2mat(filterStateNavOrientationCell);
filterStateNavOrientationReshape = reshape(filterStateNavOrientationFlat',3,3,[]);
filterStateNavOrientation = permute(filterStateNavOrientationReshape,[2 1 3]);

end