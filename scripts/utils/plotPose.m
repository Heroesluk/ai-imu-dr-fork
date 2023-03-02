function [] = plotPose(poseData)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
poseDataSize = size(poseData,1);

figure;
hold on;
grid on;
axis equal;
l = 0.5; % coordinate axis length
A = [0 0 0 1; l 0 0 1; 0 0 0 1; 0 l 0 1; 0 0 0 1; 0 0 l 1]';
for i=1:200:poseDataSize
  B = poseData{i,2}*A;
%   B = [[1 0 0; 0 1 0; 0 0 1] poseData{i,2}(1:3,4);0 0 0 1]*A;
  plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',2); % x: red
  plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',2); % y: green
  plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',2); % z: blue
end
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
% for i=1:2000:poseDataSize
%     pose = poseData{i,2};
%     poseR = pose(1:3,1:3);
%     poseT = pose(1:3,4);
%     poseplotQuat = quaternion(poseR,'rotmat','frame');
%     poseplot(poseplotQuat,poseT,'ENU');
% end
% hold off;


end