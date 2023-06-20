function [] = plotTransitionComparison(groundTruthSEBracket3,testSEBracket3,plotSampleRate)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
TAG = 'plotTransitionComparison';

poseDataSize = size(groundTruthSEBracket3,1);

figure;
hold on;
grid on;
axis equal;

groundTruthTransition = zeros(poseDataSize,3);
testTransition = zeros(poseDataSize,3);
for i=1:1:poseDataSize
    tGroundTruthSEBracket3 = groundTruthSEBracket3{i,1};
    groundTruthTransition(i,1:3) = (tGroundTruthSEBracket3(1:3,4))';

    tTestSEBracket3 = testSEBracket3{i,1};
    testTransition(i,1:3) = (tTestSEBracket3(1:3,4))';
end

line1 = plot3(groundTruthTransition(:,1),groundTruthTransition(:,2),groundTruthTransition(:,3));
line1.Color = 'r';


line11 = plot3(groundTruthTransition(1,1),groundTruthTransition(1,2),groundTruthTransition(1,3));
line12 = plot3(groundTruthTransition(poseDataSize,1),groundTruthTransition(poseDataSize,2),groundTruthTransition(poseDataSize,3));
line11.Color = 'r';
line11.Marker = 'o';
line11.MarkerSize = 3;
line12.Color = 'r';
line12.Marker = 'square';
line12.MarkerSize = 3;


cArrowPlotNumberDistance = 50;

groundTruthDistance = getTrackDistance(groundTruthTransition);
groundTruthArrowPlotNumber = floor(groundTruthDistance / cArrowPlotNumberDistance);
arrowPlot(groundTruthTransition(:,1),groundTruthTransition(:,2), 'number', groundTruthArrowPlotNumber, 'color', 'r', 'LineWidth', 0.1, 'scale', 1, 'ratio', 'equal')

logMsg = sprintf('Track distance %.3f m',groundTruthDistance);
log2terminal('W',TAG,logMsg);

hold on;

line2 = plot3(testTransition(:,1),testTransition(:,2),testTransition(:,3));
line2.LineStyle = '--';
line2.Color = 'g';

line21 = plot3(testTransition(1,1),testTransition(1,2),testTransition(1,3));
line22 = plot3(testTransition(poseDataSize,1),testTransition(poseDataSize,2),testTransition(poseDataSize,3));
line21.Color = 'g';
line21.Marker = 'o';
line21.MarkerSize = 3;
line22.Color = 'g';
line22.Marker = 'square';
line22.MarkerSize = 3;


testDistance = getTrackDistance(testTransition);
testArrowPlotNumber = floor(testDistance / cArrowPlotNumberDistance);
arrowPlot(testTransition(:,1),testTransition(:,2), 'number', testArrowPlotNumber, 'color', 'g', 'LineWidth', 0.1, 'scale', 1, 'ratio', 'equal')



% Add labels
hXLabel = xlabel('x (m)');
hYLabel = ylabel('y (m)');
hZLabel = zlabel('z (m)');

% Add legend
hLegend = legend([line1 line2],'benchmark','proposed');
hLegend.Location = 'north';
hLegend.Orientation = "horizontal";

% Adjust font
set(gca,'FontName','Times');
set([hLegend gca],'FontSize',8);
set([hXLabel hYLabel hZLabel],'FontSize',10);

% Adjust axes properties

% | 刻度 | 次刻度线
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
% | 刻度 | 刻度线方向
set(gca,'TickDir','out');
% | 刻度 | 刻度线长度
set(gca,'TickLength', [.02 .02]);
% | 标尺 | 最小和最大坐标轴范围
rXLimMin = min(min(groundTruthTransition(:,1)),min(testTransition(:,1)));
rXLimMax = max(max(groundTruthTransition(:,1)),max(testTransition(:,1)));
rYLimMin = min(min(groundTruthTransition(:,2)),min(testTransition(:,2)));
rYLimMax = max(max(groundTruthTransition(:,2)),max(testTransition(:,2)));

tXLimMin = floor(rXLimMin / 10) * 10;
tXLimMax = ceil(rXLimMax / 10) * 10;
tYLimMin = floor(rYLimMin / 10) * 10;
tYLimMax = ceil(rYLimMax / 10) * 10;

if rXLimMin - tXLimMin < 5
    pXLimMin = tXLimMin - 5;
else
    pXLimMin = tXLimMin;
end

if rYLimMin - tYLimMin < 5
    pYLimMin = tYLimMin - 5;
else
    pYLimMin = tYLimMin;
end

if tXLimMax - rXLimMax < 5
    pXLimMax = tXLimMax + 5;
else
    pXLimMax = tXLimMax;
end

if tYLimMax - rYLimMax < 5
    pYLimMax = tYLimMax + 5;
else
    pYLimMax = tYLimMax;
end

pYLimMax = pYLimMax + 10;


xlim([pXLimMin pXLimMax]);
ylim([pYLimMin pYLimMax]);





% | 标尺 | 轴线、刻度值和标签的颜色
set(gca,'XColor',[.3 .3 .3]);
set(gca,'YColor',[.3 .3 .3]);
% | 框样式 | 线条宽度
set(gca,'LineWidth',1);
% | 框样式 | 框轮廓
set(gca, 'Box', 'off');

% http://gs.xjtu.edu.cn/info/1209/7605.htm
% 参考《西安交通大学博士、硕士学位论文模板（2021版）》中对图的要求
% 图尺寸的一般宽高比应为6.67 cm×5.00 cm。特殊情况下， 也可为
% 9.00 cm×6.75 cm， 或13.5 cm×9.00 cm。总之， 一篇论文中， 同类图片的
% 大小应该一致，编排美观、整齐；
% https://ww2.mathworks.cn/help/matlab/ref/matlab.ui.figure-properties.html
% https://www.zhihu.com/tardis/zm/art/114980765?source_id=1005
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



print(gcf,'f','-dpng','-r600');

end