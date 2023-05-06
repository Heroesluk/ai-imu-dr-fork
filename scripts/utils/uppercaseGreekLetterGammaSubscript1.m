function outputArg1 = uppercaseGreekLetterGammaSubscript1(phi)
%UPPERCASEGREEKLETTERGAMMASUBSCRIPT0 此处显示有关此函数的摘要
%   此处显示详细说明
phiLength = length(phi);
phi = reshape(phi,1,phiLength);

angle = norm(phi);
anglePower2 = angle * angle;
anglePower3 = anglePower2 * angle;
phiSkew = skew(phi);
phiSkewPower2 = phiSkew * phiSkew;

outputArg1 = eye(3) + (1 - cos(angle)) / anglePower2 .* phiSkew + (angle - sin(angle)) / anglePower3 .* phiSkewPower2;

end
