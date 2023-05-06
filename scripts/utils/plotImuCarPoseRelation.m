function [] = plotImuCarPoseRelation(rotationMatrixFromImuToCar)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明


figure;
hold on;
grid on;
axis equal;


coordinateWorldAxisLength = 3; % coordinate axis length
coordinateWorldAxisArrowWidth = 2;
coordinateWorldOrigin = [0 0 0];
coordinateWorldAxisX = [coordinateWorldAxisLength 0 0];
coordinateWorldAxisY = [0 coordinateWorldAxisLength 0];
coordinateWorldAxisZ = [0 0 coordinateWorldAxisLength];

arrow3(coordinateWorldOrigin,coordinateWorldAxisX,'r-1',coordinateWorldAxisArrowWidth);
arrow3(coordinateWorldOrigin,coordinateWorldAxisY,'g-1',coordinateWorldAxisArrowWidth);
arrow3(coordinateWorldOrigin,coordinateWorldAxisZ,'b-1',coordinateWorldAxisArrowWidth);

coordinateImuAxisLength = 1;
axisImuXInImuCoordinate = [coordinateImuAxisLength 0 0];
axisImuYInImuCoordinate = [0 coordinateImuAxisLength 0];
axisImuZInImuCoordinate = [0 0 coordinateImuAxisLength];
axisImuInImuCoordinate = vertcat(axisImuXInImuCoordinate,axisImuYInImuCoordinate,axisImuZInImuCoordinate);
axisImuInCarCoordinate = (rotationMatrixFromImuToCar * axisImuInImuCoordinate')';
coordinateImuOrigin = [1 1 0];
axisImuXInCarCoordinate = coordinateImuOrigin + axisImuInCarCoordinate(1,1:3);
axisImuYInCarCoordinate = coordinateImuOrigin + axisImuInCarCoordinate(2,1:3);
axisImuZInCarCoordinate = coordinateImuOrigin + axisImuInCarCoordinate(3,1:3);
arrow3(coordinateImuOrigin,axisImuXInCarCoordinate,'r-0.5',coordinateWorldAxisArrowWidth);
arrow3(coordinateImuOrigin,axisImuYInCarCoordinate,'g-0.5',coordinateWorldAxisArrowWidth);
arrow3(coordinateImuOrigin,axisImuZInCarCoordinate,'b-0.5',coordinateWorldAxisArrowWidth);


xlabel('x');
ylabel('y');
zlabel('z');



end