function outputArg1 = uppercaseGreekLetterGammaSubscript2(phi)
%UPPERCASEGREEKLETTERGAMMASUBSCRIPT0 此处显示有关此函数的摘要
%   此处显示详细说明
angle = norm(phi);
anglePower2 = angle * angle;
anglePower3 = anglePower2 * angle;
anglePower4 = anglePower3 * angle;
phikew = skew(phiNorm);
phiSkewPower2 = phikew * phikew;

outputArg1 = 0.5 .* eye(3) + (angle - sin(angle)) / anglePower3 .* phikew + (anglePower2 + 2 * cos(angle) - 2) / (2 * anglePower4) .* phiSkewPower2;

end
