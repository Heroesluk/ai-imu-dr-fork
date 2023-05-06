function outputArg1 = uppercaseGreekLetterGammaSubscript3(phi)
%UPPERCASEGREEKLETTERGAMMASUBSCRIPT0 此处显示有关此函数的摘要
%   此处显示详细说明
phiLength = length(phi);
phi = reshape(phi,1,phiLength);

angle = norm(phi);
anglePower2 = angle * angle;
anglePower3 = anglePower2 * angle;
anglePower4 = anglePower3 * angle;
anglePower5 = anglePower4 * angle;
phikew = skew(phi);
phiSkewPower2 = phikew * phikew;

outputArg1 = 1 / 6 .* eye(3) + (anglePower2 + 2 * cos(angle) - 2) / (2 * anglePower4) .* phikew + (anglePower3 + 6 * sin(angle) - 6 * angle) / (6 * anglePower5) .* phiSkewPower2;

end
