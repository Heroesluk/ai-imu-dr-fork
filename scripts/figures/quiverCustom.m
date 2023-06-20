function [s1,s2,s3,s4] = quiverCustom(a,b,c,alpha,beta,gamma,varargin)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% https://blog.csdn.net/qq_41840083/article/details/122836611
% Cone

p = inputParser;
addParameter(p,'Color','r');
addParameter(p,'LineWidth',0.02);
addParameter(p,'ArrowHeadWidth',0.05);
addParameter(p,'ArrowHeadHeight',0.2);
parse(p,varargin{:});
color = p.Results.Color;
lineWidth = p.Results.LineWidth;
arrowHeadWidth = p.Results.ArrowHeadWidth;
arrowHeadHeight = p.Results.ArrowHeadHeight;

quiverHeight = sqrt((alpha-a).^2 + (beta-b).^2 + (gamma-c).^2);

quiverConeRadius = 0:0.01:arrowHeadWidth; % The cone radius
quiverConeHeight = arrowHeadHeight;         % The cone height
% The cone top position
a1 = a;
b1 = b;
c1 = quiverHeight;
% Generate cone data
[u,v,w] = cylinder(quiverConeRadius,100);
u = u+a1;
v = v+b1;
w = -w*quiverConeHeight+c1;
% Cone botton
t1 = (0:0.01:2)*pi;
quiverConeBottomRadius = arrowHeadWidth;
quiverCylinderBottomCenterX = a1;
quiverCylinderBottomCenterY = b1;
quiverCylinderBottomCenterZ = c1-quiverConeHeight;
% Generate cone botton data
x1 = quiverCylinderBottomCenterX + cos(t1)*quiverConeBottomRadius;
y1 = quiverCylinderBottomCenterY + sin(t1)*quiverConeBottomRadius;
[m,n] = size(x1);
z1 = repmat(quiverCylinderBottomCenterZ,m,n);



% Cylinder
quiverCylinderRadius = lineWidth; % The cylinder radius
quiverCylinderHeight = quiverHeight - quiverConeHeight; % The cylinder height
% The cylinder top position
a2 = a;
b2 = b;
c2 = c;
% Generate cylinder data
[quiverCylinderSideFaceX,quiverCylinderSideFaceY,quiverCylinderSideFaceZ] = cylinder(quiverCylinderRadius,50);
quiverCylinderSideFaceX = quiverCylinderSideFaceX+a2;
quiverCylinderSideFaceY = quiverCylinderSideFaceY+b2;
quiverCylinderSideFaceZ = quiverCylinderSideFaceZ*quiverCylinderHeight + c2;
% Cylinder botton
t2 = (0:0.01:2)*pi;
quiverCylinderBottomRadius = quiverCylinderRadius;
quiverCylinderBottomCenterX = a;
quiverCylinderBottomCenterY = b;
quiverCylinderBottomCenterZ = c;
% Generate cylinder botton data
quiverCylinderBottomFaceX = quiverCylinderBottomCenterX + cos(t2)*quiverCylinderBottomRadius;
quiverCylinderBottomFaceY = quiverCylinderBottomCenterY + sin(t2)*quiverCylinderBottomRadius;
[m,n] = size(quiverCylinderBottomFaceX);
quiverCylinderBottomFaceZ = repmat(quiverCylinderBottomCenterZ,m,n);



%plot
s1 = surf(u,v,w,'Facecolor',color,'Edgecolor','none');
s3 = fill3(x1,y1,z1,color,'Edgecolor','none');

s2 = surf(quiverCylinderSideFaceX,quiverCylinderSideFaceY,quiverCylinderSideFaceZ,'Facecolor',color,'Edgecolor','none');
s4 = fill3(quiverCylinderBottomFaceX,quiverCylinderBottomFaceY,quiverCylinderBottomFaceZ,color,'Edgecolor','none');



% Rotate arrow
% Rotate arrow
% zc = (c1+zc)/2;
hold on
% origin = [xc,yc,zc];
origin = [a,b,c];
theta2 = acos(gamma./quiverHeight);
if beta^2 + alpha^2 == 0
    direct = [0 1 0];
else
    direct = [-beta,alpha,0];
end


if theta2 ~= 0
    rotate(s1,direct,rad2deg(theta2),origin);
    rotate(s2,direct,rad2deg(theta2),origin);
    rotate(s3,direct,rad2deg(theta2),origin);
    rotate(s4,direct,rad2deg(theta2),origin);
end




end