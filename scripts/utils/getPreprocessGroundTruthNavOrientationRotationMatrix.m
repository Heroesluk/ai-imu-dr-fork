function [getPreprocessGroundTruthNavOrientationRotationMatrix] = getPreprocessGroundTruthNavOrientationRotationMatrix(preprocessRawFlatData)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

preprocessGroundTruthNavOrientationFlat = preprocessRawFlatData(:,14:22);
preprocessGroundTruthNavOrientationReshape = reshape(preprocessGroundTruthNavOrientationFlat',3,3,[]);
getPreprocessGroundTruthNavOrientationRotationMatrix = permute(preprocessGroundTruthNavOrientationReshape,[2 1 3]);

end