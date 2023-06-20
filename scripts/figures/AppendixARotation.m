close all;
clear;

eulDeg = [30 0 0];
eulRad = deg2rad(eulDeg);
rotationMatrixFromWorldToCar = eul2rotm(eulRad,"ZXY");

figure;
hold on;
% grid on;

% 
axis off;

% TODO: S1.2: 坐标区外观
% TODO: S1.2.4: 设置坐标轴范围和纵横比
cAxisLenghth = 10;
cAxisXMin = -cAxisLenghth;
cAxisXMax = cAxisLenghth;
cAxisYMin = -cAxisLenghth;
cAxisYMax = cAxisLenghth;
cAxisZMin = -cAxisLenghth;
cAxisZMax = cAxisLenghth;
axis([cAxisXMin cAxisXMax cAxisYMin cAxisYMax cAxisZMin cAxisZMax]);

% TODO: S1.2.5: 设置坐标区轮廓
box on;

daspect([1 1 1]);

xlabel('x');
ylabel('y');
zlabel('z');




cameratoolbar;

% https://ww2.mathworks.cn/matlabcentral/answers/423660-plot3-how-to-show-the-grid-on-only-the-xy-plane
cXOYPlainGridLength = 3;
cXOYPlainGridTickLength = 1;
cXTickMin = -cXOYPlainGridLength;
cXTickMax = cXOYPlainGridLength;
cYTickMin = -cXOYPlainGridLength;
cYTickMax = cXOYPlainGridLength;
cZTickMin = -cXOYPlainGridLength;
cZTickMax = cXOYPlainGridLength;
cXOYPlainGridXLim = [cXTickMin cXTickMax];
cYOYPlainGridYLim = [cYTickMin cYTickMax];
cZOYPlainGridYLim = [cZTickMin cZTickMax];
cXTick = cXTickMin:cXOYPlainGridTickLength:cXTickMax;
cYTick = cXTickMin:cXOYPlainGridTickLength:cXTickMax;
pXOYPlainGridXLim = cXOYPlainGridXLim;
pXOYPlainGridYLim = cYOYPlainGridYLim;
pXOYPlainGridZLim = zlim;
cXOYPlainGridColor= [0.15 0.15 0.15];

plotXOYPlainGridXLine = plot([cXTick; cXTick], pXOYPlainGridYLim(:)*ones(size(cXTick)),'Color',cXOYPlainGridColor,'LineWidth',0.1);
for i = 1:size(plotXOYPlainGridXLine,1)
    plotXOYPlainGridXLine(i).Color(4) = 0.15;
end

plotXOYPlainGridYLine = plot(pXOYPlainGridXLim(:)*ones(size(cYTick)), [cYTick; cYTick],'Color',cXOYPlainGridColor,'LineWidth',0.1);
for i = 1:size(plotXOYPlainGridYLine,1)
    plotXOYPlainGridYLine(i).Color(4) = 0.15;
end

plotXOYPlainAxisXLine = plot(pXOYPlainGridXLim(:)*ones(1),[0;0]);
plotXOYPlainAxisXLine.Color = 'r';
plotXOYPlainAxisXLine.LineWidth = 0.2;

plotXOYPlainAxisYLine = plot([0;0], pXOYPlainGridXLim(:)*ones(1));
plotXOYPlainAxisYLine.Color = 'g';
plotXOYPlainAxisYLine.LineWidth = 0.2;


plotCoordinateFrame(eye(3));
plotCoordinateFrame(rotationMatrixFromWorldToCar);

% coordinateImuAxisLength = 1;
% axisImuXInImuCoordinate = [coordinateImuAxisLength 0 0];
% axisImuYInImuCoordinate = [0 coordinateImuAxisLength 0];
% axisImuZInImuCoordinate = [0 0 coordinateImuAxisLength];
% axisImuInImuCoordinate = vertcat(axisImuXInImuCoordinate,axisImuYInImuCoordinate,axisImuZInImuCoordinate);
% axisImuInCarCoordinate = (rotationMatrixFromWorldToCar * axisImuInImuCoordinate')';
% coordinateImuOrigin = [0 0 0];
% axisImuXInCarCoordinate = coordinateImuOrigin + axisImuInCarCoordinate(1,1:3);
% axisImuYInCarCoordinate = coordinateImuOrigin + axisImuInCarCoordinate(2,1:3);
% axisImuZInCarCoordinate = coordinateImuOrigin + axisImuInCarCoordinate(3,1:3);
% arrow3(coordinateImuOrigin,axisImuXInCarCoordinate,'r-1',coordinateWorldAxisArrowWidth);
% arrow3(coordinateImuOrigin,axisImuYInCarCoordinate,'g-1',coordinateWorldAxisArrowWidth);
% arrow3(coordinateImuOrigin,axisImuZInCarCoordinate,'b-1',coordinateWorldAxisArrowWidth);

%





% http://gs.xjtu.edu.cn/info/1209/7605.htm
% 参考《西安交通大学博士、硕士学位论文模板（2021版）》中对图的要求
% 图尺寸的一般宽高比应为6.67 cm×5.00 cm。特殊情况下， 也可为
% 9.00 cm×6.75 cm， 或13.5 cm×9.00 cm。总之， 一篇论文中， 同类图片的
% 大小应该一致，编排美观、整齐；
cFigureWidth = 9;
cFigureHeight = 6.75;
set(gcf,'Units','centimeters');
set(gcf,'Position',[0, 0, cFigureWidth, cFigureHeight]);

% 打印和导出
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[cFigureWidth cFigureHeight]);
set(gcf,'PaperPosition',[0 0 cFigureWidth cFigureHeight]);

set(gca,'Units','centimeters');
set(gca,'OuterPosition',gcf().Position);

xlabel('X','FontSize',12);
ylabel('Y','FontSize',12);
zlabel('Z','FontSize',12);

% TODO: S1.4: 三维场景控制
% 放大和缩小场景
cCameraZoomFactor = 0.1;
camzoom(cCameraZoomFactor);
% 	设置或查询相机位置
camposScale = 2;
elevation = deg2rad(30);
azimuth = deg2rad(45);
cCameraPosition = [cos(elevation)*cos(azimuth) cos(elevation)*sin(azimuth) sin(elevation)] * camposScale;
campos(cCameraPosition);
% 设置或查询投影类型
camproj('perspective');
% 设置或查询相机目标点的位置
camtarget([0 0 0]);


set(gcf,'renderer','zbuffer')

print(gcf,'f','-dpng','-r600');




