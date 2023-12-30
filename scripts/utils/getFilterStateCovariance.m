function [filterStateCovariance] = getFilterStateCovariance(filterState)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

filterStateCovarianceCell = filterState(:,9);
filterStateCovarianceFlat = cell2mat(filterStateCovarianceCell);
filterStateCovarianceReshape = reshape(filterStateCovarianceFlat',21,21,[]);
filterStateCovariance = permute(filterStateCovarianceReshape,[2 1 3]);

end