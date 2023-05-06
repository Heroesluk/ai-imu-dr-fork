function outputArg1 = uppercaseGreekLetterGammaSubscript0(phi)
%UPPERCASEGREEKLETTERGAMMASUBSCRIPT0 此处显示有关此函数的摘要
%   此处显示详细说明
phiLength = length(phi);
phi = reshape(phi,1,phiLength);
angle = norm(phi);
anglePower2 = angle * angle;
phiSkew = skew(phi);
phiSkewPower2 = phiSkew * phiSkew;

outputArg1 = eye(3) + sin(angle) / angle .* phiSkew + (1 - cos(angle)) / anglePower2 .* phiSkewPower2;

end
