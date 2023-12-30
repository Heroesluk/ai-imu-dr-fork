function [] = plotPiecewiseSESubscript4Bracket3(poseTime,poseSE,poseNVelocity,poseSGyroscope,poseSAcceleration)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
ViridisColerPalette06 = ["#fde725" "#7ad151" "#22a884" "#2a788e" "#414487" "#440154"];

GRAVITY = [0 0 -9.8]';

% ROTATION_FROM_IMU_TO_CAR = [ 0 1  0;
%     -1 0 0;
%     0  0 1];

ROTATION_FROM_IMU_TO_CAR = [ 1 0  0;
    0 1 0;
    0  0 1];

% ROTATION_FROM_IMU_TO_CAR = [-1 0  0;
%     0 -1 0;
%     0  0 1];

pTime = cell2mat(poseTime);
pTimeSize = size(pTime,1);

pNVelocity = cell2mat(poseNVelocity);
pVelocity = sqrt(sum(pNVelocity.^2,2));
pMaxVelocity = max(pVelocity);

poseSGyroscope = cell2mat(poseSGyroscope);

pSAcceleration = cell2mat(poseSAcceleration);

figure;
hold on;
plot(pSAcceleration(:,1),'DisplayName','Accelerometer X');
plot(pSAcceleration(:,2),'DisplayName','Accelerometer Y');
plot(pSAcceleration(:,3),'DisplayName','Accelerometer Z');
legend;
hold off;

figure;
hold on;
plot(poseSGyroscope);
hold off;

pSAcceleration = pSAcceleration + GRAVITY';
pAcceleration = sqrt(sum(pSAcceleration.^2,2));
pMaxAcceleration = max(pAcceleration);


figure;
hold on;
grid on;
axis equal;
vl = 0.1; % coordinate axis length
al = 20/pMaxAcceleration;
% A = [0 0 0 1; l 0 0 1; 0 0 0 1; 0 l 0 1; 0 0 0 1; 0 0 l 1]';
for i=1:50:pTimeSize
  rotationFromS2N = poseSE{i,1};

  rotationFromN2S = rotationFromS2N;
  rotationFromN2S(1:3,1:3) = (rotationFromS2N(1:3,1:3))';
  vn = pNVelocity(i,:);
  vc = rotationFromN2S(1:3,1:3) * vn';
  A = [0 0 0 1; vl*vc(1) 0 0 1; 0 0 0 1; 0 vl*vc(2) 0 1; 0 0 0 1; 0 0 vl*vc(3) 1]';
  B = rotationFromS2N * A;
  plot3(B(1,1:2),B(2,1:2),B(3,1:2),'Color',ViridisColerPalette06(1),'LineStyle','-','LineWidth',3); % x: red
  plot3(B(1,3:4),B(2,3:4),B(3,3:4),'Color',ViridisColerPalette06(3),'LineStyle','-','LineWidth',3); % y: green
  plot3(B(1,5:6),B(2,5:6),B(3,5:6),'Color',ViridisColerPalette06(5),'LineStyle','-','LineWidth',3); % z: blue

  as = pSAcceleration(i,:);
  ac = ROTATION_FROM_IMU_TO_CAR * as';
  A2 = [0 0 0 1; al*ac(1) 0 0 1; 0 0 0 1; 0 al*ac(2) 0 1; 0 0 0 1; 0 0 al*ac(3) 1]';
  B2 = rotationFromS2N * A2;
  plot3(B2(1,1:2),B2(2,1:2),B2(3,1:2),'Color',ViridisColerPalette06(2),'LineStyle','--','LineWidth',2); % x: red
  plot3(B2(1,3:4),B2(2,3:4),B2(3,3:4),'Color',ViridisColerPalette06(4),'LineStyle','--','LineWidth',2); % y: green
  plot3(B2(1,5:6),B2(2,5:6),B2(3,5:6),'Color',ViridisColerPalette06(6),'LineStyle','--','LineWidth',2); % z: blue
end

headTransition = poseSE{1,1};
tailTransition = poseSE{pTimeSize,1};
pHeadToTailLineX = [headTransition(1,4) tailTransition(1,4)];
pHeadToTailLineY = [headTransition(2,4) tailTransition(2,4)];
pHeadToTailLineZ = [headTransition(3,4) tailTransition(3,4)];
plot3(pHeadToTailLineX,pHeadToTailLineY,pHeadToTailLineZ,'--k','LineWidth',0.5);





end