function [filterStateCarOrientationFlat] = getFilterStateCarOrientation(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateCarOrientationCell = filterState(:,7);
filterStateCarOrientationFlat = cell2mat(filterStateCarOrientationCell);
filterStateCarOrientationReshape = reshape(filterStateCarOrientationFlat',3,3,[]);
filterStateCarOrientationFlat = permute(filterStateCarOrientationReshape,[2 1 3]);

end