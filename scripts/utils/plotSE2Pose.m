function [] = plotSE2Pose(poseData)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
poseDataSize = size(poseData,1);

maxSpeed = max(cell2mat(poseData(:,4)));

figure;
hold on;
grid on;
axis equal;
l = 3/maxSpeed; % coordinate axis length
% A = [0 0 0 1; l 0 0 1; 0 0 0 1; 0 l 0 1; 0 0 0 1; 0 0 l 1]';
for i=1:1:poseDataSize
  vn = poseData{i,3};
  vc = poseData{i,6}(1:3,1:3) * vn';
  A = [0 0 0 1; l*vc(1)*1000 0 0 1; 0 0 0 1; 0 l*vc(2) 0 1; 0 0 0 1; 0 0 l*vc(3)*100 1]';
  B = poseData{i,7} * A;
%   B = [[1 0 0; 0 1 0; 0 0 1] poseData{i,2}(1:3,4);0 0 0 1]*A;
  plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',2); % x: red
  plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',2); % y: green
  plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',2); % z: blue
%   A = [0 0 0 1; l*v(1) 0 0 1; 0 0 0 1; 0 l*v(2) 0 1; 0 0 0 1; 0 0 l*v(3) 1]';
end

headTransition = poseData{1,2};
tailTransition = poseData{poseDataSize,2};
pHeadToTailLineX = [headTransition(1) tailTransition(1)];
pHeadToTailLineY = [headTransition(2) tailTransition(2)];
pHeadToTailLineZ = [headTransition(3) tailTransition(3)];
plot3(pHeadToTailLineX,pHeadToTailLineY,pHeadToTailLineZ,'--k','LineWidth',0.5);

xlabel('x');
ylabel('y');
zlabel('z');

% figure;
% poseplot;
% hold on;
% xlabel("East-x (m)");
% ylabel("North-y (m)");
% zlabel("Up-z (m)");
% set(gca,'YDir','normal');
% set(gca,'ZDir','normal');
% for i=1:2:poseDataSize
%     pose = poseData{i,2};
%     poseR = pose(1:3,1:3);
%     poseT = pose(1:3,4);
%     poseplotQuat = quaternion(poseR,'rotmat','frame');
%     poseplot(poseplotQuat,poseT,'ENU');
% end
% hold off;


end
