close all;
clear;

eulDeg = [90 0 0];
eulRad = deg2rad(eulDeg);
rotationMatrixFromWorldToCar = eul2rotm(eulRad,"ZXY");

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
axisImuInCarCoordinate = (rotationMatrixFromWorldToCar * axisImuInImuCoordinate')';
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



% http://gs.xjtu.edu.cn/info/1209/7605.htm
% 参考《西安交通大学博士、硕士学位论文模板（2021版）》中对图的要求
% 图尺寸的一般宽高比应为6.67 cm×5.00 cm。特殊情况下， 也可为
% 9.00 cm×6.75 cm， 或13.5 cm×9.00 cm。总之， 一篇论文中， 同类图片的
% 大小应该一致，编排美观、整齐；
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 9, 6.75]);
set(gca, 'lineWidth', 1.1, 'FontSize', 9, 'FontName', 'Times');

xlabel('Sample','FontSize',12);
ylabel('Nanosecond','FontSize',12);


print(gcf,'f','-dpng','-r600');




