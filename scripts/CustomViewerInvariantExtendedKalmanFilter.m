clearvars;
% close all;
dbstop error;
% clc;
addpath(genpath(pwd));

SCRIPT_MODE = 1;

TAG = 'CustomViewerSpan';

cSpanDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\20230301\车载数据';
cSpanDatasetResampledDataFileName = 'ResampledInsData.mat';
cSpanDatasetResampledDataFilePath = fullfile(cSpanDatasetFolderPath,'SPAN',cSpanDatasetResampledDataFileName);
load(cSpanDatasetResampledDataFilePath);

% plotSEPose(spanResampledData(1:3000,2));
% plotSEPose(spanResampledData(3000:6000,2));

GRAVITY = [0 0 -9.8]';

ROTATION_FROM_IMU_TO_CAR = [ 0 1  0;
    -1 0 0;
    0  0 1];

ViridisColerPalette06 = ["#fde725" "#7ad151" "#22a884" "#2a788e" "#414487" "#440154"];

% FILTER INTERMEDIATE STATE
FIS_TIME_SAVE_INDEX = 1;
FIS_SEBRACKET3_SAVE_INDEX = 2;
FIS_SOBRACKET3_FROM_IMU_TO_NAV_SAVE_INDEX = 3;
FIS_VELOCITY_IN_NAV_SAVE_INDEX = 4;
FIS_POSITION_INDEX = 5;
FIS_ANGULAR_SPEED_SAVE_INDEX = 6;
FIS_ANGULAR_SPEED_BIAS_SAVE_INDEX = 7;
FIS_ACCELERATION_SAVE_INDEX = 8;
FIS_ACCELERATION_BIAS_SAVE_INDEX = 9;
FIS_SOBRACKET3_FROM_IMU_TO_CAR_SAVE_INDEX = 10;
FIS_TRANSLATION_FROM_IMU_TO_CAR_SAVE_INDEX = 11;
FIS_P_SAVE_INDEX = 12;
FIS_Q_SAVE_INDEX = 13;
FIS_F_SAVE_INDEX = 14;
FIS_G_SAVE_INDEX = 15;

spanResampledDataSize = size(spanResampledData,1);
filterIntermediateState = cell(spanResampledDataSize,4);
filterIntermediateState{1,FIS_TIME_SAVE_INDEX} = spanResampledData{1,1};
filterIntermediateState{1,FIS_SEBRACKET3_SAVE_INDEX} = spanResampledData{1,2};
filterIntermediateState{1,FIS_SOBRACKET3_FROM_IMU_TO_NAV_SAVE_INDEX} = spanResampledData{1,2}(1:3,1:3) * ROTATION_FROM_IMU_TO_CAR;
filterIntermediateState{1,FIS_VELOCITY_IN_NAV_SAVE_INDEX} = spanResampledData{1,3};
filterIntermediateState{1,FIS_POSITION_INDEX} = (spanResampledData{1,2}(1:3,4))';
filterIntermediateState{1,FIS_ANGULAR_SPEED_SAVE_INDEX} = spanResampledData{1,4};
filterIntermediateState{1,FIS_ANGULAR_SPEED_BIAS_SAVE_INDEX} = zeros(1,3);
filterIntermediateState{1,FIS_ACCELERATION_SAVE_INDEX} = spanResampledData{1,5};
filterIntermediateState{1,FIS_ACCELERATION_BIAS_SAVE_INDEX} = zeros(1,3);
filterIntermediateState{1,FIS_SOBRACKET3_FROM_IMU_TO_CAR_SAVE_INDEX} = ROTATION_FROM_IMU_TO_CAR;
filterIntermediateState{1,FIS_TRANSLATION_FROM_IMU_TO_CAR_SAVE_INDEX} = spanResampledData{1,2}(1:3,4);

filterInitPSOBracket3XFromCarToNav = 1e-3;
filterInitPSOBracket3YFromCarToNav = 1e-3;
filterInitPSOBracket3ZFromCarToNav = 0;
filterInitPVelocityX = 0.3;
filterInitPVelocityY = 0.3;
filterInitPVelocityZ = 0;
filterInitPPosition = 0;
filterInitPAngularSpeedBias = 1e-4;
filterInitPAccelerationBias = 1e-3;
filterInitPSOBracket3FromImuToCar = 1e-4;
filterInitTranslationFromImuToCar = 1e-4;
filterInitP = zeros(21);
filterInitP(1:3,1:3) = diag([filterInitPSOBracket3XFromCarToNav filterInitPSOBracket3YFromCarToNav filterInitPSOBracket3ZFromCarToNav]);
filterInitP(4:6,4:6) = diag([filterInitPVelocityX filterInitPVelocityY filterInitPVelocityZ]);
filterInitP(7:9,7:9) = eye(3) * filterInitPPosition;
filterInitP(10:12,10:12) = eye(3) * filterInitPAngularSpeedBias;
filterInitP(13:15,13:15) = eye(3) * filterInitPAccelerationBias;
filterInitP(16:18,16:18) = eye(3) * filterInitPSOBracket3FromImuToCar;
filterInitP(19:21,19:21) = eye(3) * filterInitTranslationFromImuToCar;
filterIntermediateState{1,FIS_P_SAVE_INDEX} = filterInitP;
filterIntermediateState{1,FIS_Q_SAVE_INDEX} = filterInitP;


if SCRIPT_MODE == 0
    figure;
    hold on;
    grid on;
    axis equal;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    pStateLineWidth = 3;
    pAxisLineWidth = 1;
    pCarCoordinateAxisLineLength = 1;
    pImuCoordinateAxisLineLength = 0.9;
    vl = 1;
    al = 2;
end


for i =2:spanResampledDataSize
    
    filterIntermediateState{i,FIS_TIME_SAVE_INDEX} = spanResampledData{i,1};
    dt = filterIntermediateState{i,FIS_TIME_SAVE_INDEX} - filterIntermediateState{i-1,FIS_TIME_SAVE_INDEX};

%     cAcceleration = ROTATION_FROM_IMU_TO_CAR * (spanResampledData{i-1,5})';
%     cGyroscope = ROTATION_FROM_IMU_TO_CAR * (spanResampledData{i-1,4})';

    observationAngulerSpeed = (filterIntermediateState{i-1,FIS_ANGULAR_SPEED_SAVE_INDEX})';
    observationAcceleration = (filterIntermediateState{i-1,FIS_ACCELERATION_SAVE_INDEX})';
    filterState1Rotation = filterIntermediateState{i-1,FIS_SOBRACKET3_FROM_IMU_TO_NAV_SAVE_INDEX};
    filterState2Velocity = (filterIntermediateState{i-1,FIS_VELOCITY_IN_NAV_SAVE_INDEX})';
    filterState3Translation = (filterIntermediateState{i-1,FIS_POSITION_INDEX})';
    filterState4AngulerSpeedBias = (filterIntermediateState{i-1,FIS_ANGULAR_SPEED_BIAS_SAVE_INDEX})';
    filterState5AccelerationBias = (filterIntermediateState{i-1,FIS_ACCELERATION_BIAS_SAVE_INDEX})';
    filterState6Rotation = filterIntermediateState{i-1,FIS_SOBRACKET3_FROM_IMU_TO_CAR_SAVE_INDEX};
    filterState7Translation = filterIntermediateState{i-1,FIS_TRANSLATION_FROM_IMU_TO_CAR_SAVE_INDEX};

    %%% Propagate
    % State X1
    propagateState1AngulerSpeed = observationAngulerSpeed - filterState4AngulerSpeedBias;
    propagateState1Phi = propagateState1AngulerSpeed * dt;
    propagateState1Gamma0Phi = uppercaseGreekLetterGammaSubscript0(propagateState1Phi);
    propagateState1RotationEstimation1 = filterState1Rotation * propagateState1Gamma0Phi;
    propagateState1RotationEstimation2 = filterState1Rotation * SO3.exp(propagateState1Phi).double;
    [nPropagateRotationAng1, nPropagateRotationAng2, nPropagateRotationAng3] = dcm2angle(propagateState1RotationEstimation1,'ZXY');
    nPropagateRotationAng = rad2deg([nPropagateRotationAng1, nPropagateRotationAng2, nPropagateRotationAng3]);
    % State X2
    propagateState1Gamma1Phi = uppercaseGreekLetterGammaSubscript1(propagateState1Phi);
    propagateState2AccelerationEstimation = observationAcceleration - filterState5AccelerationBias;
    propagateState2VelocityEstimation1 = filterState2Velocity + filterState1Rotation * propagateState1Gamma1Phi * propagateState2AccelerationEstimation * dt + GRAVITY * dt;
    propagateState2VelocityEstimation2 = filterState2Velocity + (filterState1Rotation * propagateState2AccelerationEstimation + GRAVITY) * dt;
    % State X3
    propagateState1Gamma2Phi = uppercaseGreekLetterGammaSubscript1(propagateState1Phi);
    propagateState3TranslationEstimation1 = filterState3Translation + filterState2Velocity * dt + filterState1Rotation * propagateState1Gamma2Phi * propagateState2AccelerationEstimation * dt * dt + 0.5 * GRAVITY * dt * dt;
    propagateState3TranslationEstimation2 = filterState3Translation + (filterState2Velocity + propagateState2VelocityEstimation2) * dt * 0.5;
    % State X4
    propagateState4AngularSpeedBias = filterState4AngulerSpeedBias;
    % State X5
    propagateState5AccelerationBias = filterState5AccelerationBias;
    % State X6
    propagateState6Rotation = filterState6Rotation;
    % State X7
    propagateState7Translation = filterState7Translation;
    % State Covariance
%     propagateFStateCovarianceTransition = 
%     propagatePStateCovariance = 

    if SCRIPT_MODE == 0
        pSEBracket3FromS2N = SE3(propagateState1RotationEstimation1,propagateState3TranslationEstimation1).double;
        pSEBracket3FromC2N = pSEBracket3FromS2N;
        pSEBracket3FromC2N(1:3,1:3) = pSEBracket3FromS2N(1:3,1:3) * propagateState6Rotation';
        pState2Velocity = filterState2Velocity;
        vc = pSEBracket3FromC2N(1:3,1:3)' * pState2Velocity;
        % vc = vc ./ max(abs(vc));
        A = [0 0 0 1; vl*vc(1) 0 0 1; 0 0 0 1; 0 vl*vc(2) 0 1; 0 0 0 1; 0 0 vl*vc(3) 1]';
        B = pSEBracket3FromC2N * A;
        plot3(B(1,1:2),B(2,1:2),B(3,1:2),'Color',ViridisColerPalette06(1),'LineStyle','-','LineWidth',pStateLineWidth);
        plot3(B(1,3:4),B(2,3:4),B(3,3:4),'Color',ViridisColerPalette06(3),'LineStyle','-','LineWidth',pStateLineWidth);
        plot3(B(1,5:6),B(2,5:6),B(3,5:6),'Color',ViridisColerPalette06(5),'LineStyle','-','LineWidth',pStateLineWidth);

        pCarCoordinateAxisInCarCoordinateSystem = [0 0 0 1; pCarCoordinateAxisLineLength 0 0 1; 0 0 0 1; 0 pCarCoordinateAxisLineLength 0 1; 0 0 0 1; 0 0 pCarCoordinateAxisLineLength 1]';
        pCarCoordinateAxisInNavCoordinateSystem = pSEBracket3FromC2N * pCarCoordinateAxisInCarCoordinateSystem;
        plot3(pCarCoordinateAxisInNavCoordinateSystem(1,1:2),pCarCoordinateAxisInNavCoordinateSystem(2,1:2),pCarCoordinateAxisInNavCoordinateSystem(3,1:2),'Color',ViridisColerPalette06(1),'LineStyle','-','LineWidth',pAxisLineWidth,'Marker','o');
        plot3(pCarCoordinateAxisInNavCoordinateSystem(1,3:4),pCarCoordinateAxisInNavCoordinateSystem(2,3:4),pCarCoordinateAxisInNavCoordinateSystem(3,3:4),'Color',ViridisColerPalette06(3),'LineStyle','-','LineWidth',pAxisLineWidth,'Marker','^');
        plot3(pCarCoordinateAxisInNavCoordinateSystem(1,5:6),pCarCoordinateAxisInNavCoordinateSystem(2,5:6),pCarCoordinateAxisInNavCoordinateSystem(3,5:6),'Color',ViridisColerPalette06(5),'LineStyle','-','LineWidth',pAxisLineWidth,'Marker','square');

        as = observationAcceleration;
        pAccelerationInImuCoordinateSystem = as + GRAVITY;
        pAccelerationInImuCoordinateSystem = pAccelerationInImuCoordinateSystem ./ max(abs(pAccelerationInImuCoordinateSystem));
        A2 = [0 0 0 1; al*pAccelerationInImuCoordinateSystem(1) 0 0 1; 0 0 0 1; 0 al*pAccelerationInImuCoordinateSystem(2) 0 1; 0 0 0 1; 0 0 al*pAccelerationInImuCoordinateSystem(3) 1]';
        B2 = pSEBracket3FromS2N * A2;
        plot3(B2(1,1:2),B2(2,1:2),B2(3,1:2),'Color',ViridisColerPalette06(2),'LineStyle','--','LineWidth',pStateLineWidth); % x: red
        plot3(B2(1,3:4),B2(2,3:4),B2(3,3:4),'Color',ViridisColerPalette06(4),'LineStyle','--','LineWidth',pStateLineWidth); % y: green
        plot3(B2(1,5:6),B2(2,5:6),B2(3,5:6),'Color',ViridisColerPalette06(6),'LineStyle','--','LineWidth',pStateLineWidth); % z: blue

        pImuCoordinateAxisInImuCoordinateSystem = [0 0 0 1; pImuCoordinateAxisLineLength 0 0 1; 0 0 0 1; 0 pImuCoordinateAxisLineLength 0 1; 0 0 0 1; 0 0 pImuCoordinateAxisLineLength 1]';
        pImuCoordinateAxisInNavCoordinateSystem = pSEBracket3FromS2N * pImuCoordinateAxisInImuCoordinateSystem;        
        plot3(pImuCoordinateAxisInNavCoordinateSystem(1,1:2),pImuCoordinateAxisInNavCoordinateSystem(2,1:2),pImuCoordinateAxisInNavCoordinateSystem(3,1:2),'Color',ViridisColerPalette06(2),'LineStyle','--','LineWidth',pAxisLineWidth,'Marker','o');
        plot3(pImuCoordinateAxisInNavCoordinateSystem(1,3:4),pImuCoordinateAxisInNavCoordinateSystem(2,3:4),pImuCoordinateAxisInNavCoordinateSystem(3,3:4),'Color',ViridisColerPalette06(4),'LineStyle','--','LineWidth',pAxisLineWidth,'Marker','^');
        plot3(pImuCoordinateAxisInNavCoordinateSystem(1,5:6),pImuCoordinateAxisInNavCoordinateSystem(2,5:6),pImuCoordinateAxisInNavCoordinateSystem(3,5:6),'Color',ViridisColerPalette06(6),'LineStyle','--','LineWidth',pAxisLineWidth,'Marker','square');

        nGroundTruthVelocity = spanResampledData{i,3};
        nGroundTruthTranslation = spanResampledData{i,2}(1:3,4);
        nGroundTruthRotation = spanResampledData{i,2}(1:3,1:3);

        if i == 20
            fprintf('%d', i);
        end
    end


    
    [nGroundTruthRotationAng1, nGroundTruthRotationAng2, nGroundTruthRotationAng3] = dcm2angle(propagateState1RotationEstimation1,'ZXY');
    nGroundTruthRotationAng = rad2deg([nGroundTruthRotationAng1, nGroundTruthRotationAng2, nGroundTruthRotationAng3]);


    filterIntermediateState{i,FIS_SEBRACKET3_SAVE_INDEX} = SE3(propagateState1RotationEstimation1,propagateState3TranslationEstimation1).double;
    filterIntermediateState{i,FIS_SOBRACKET3_FROM_IMU_TO_NAV_SAVE_INDEX} = propagateState1RotationEstimation1;
    filterIntermediateState{i,FIS_VELOCITY_IN_NAV_SAVE_INDEX} = (propagateState2VelocityEstimation1)';
    filterIntermediateState{i,FIS_POSITION_INDEX} = (propagateState3TranslationEstimation1)';
    filterIntermediateState{i,FIS_ANGULAR_SPEED_BIAS_SAVE_INDEX} = (propagateState4AngularSpeedBias)';
    filterIntermediateState{i,FIS_ACCELERATION_BIAS_SAVE_INDEX} = (propagateState5AccelerationBias)';
    filterIntermediateState{i,FIS_SOBRACKET3_FROM_IMU_TO_CAR_SAVE_INDEX} = propagateState6Rotation;
    filterIntermediateState{i,FIS_TRANSLATION_FROM_IMU_TO_CAR_SAVE_INDEX} = (propagateState7Translation)';

    filterIntermediateState{i,FIS_ANGULAR_SPEED_SAVE_INDEX} = spanResampledData{i,4};
    filterIntermediateState{i,FIS_ACCELERATION_SAVE_INDEX} = spanResampledData{i,5};
end


if SCRIPT_MODE == 0
    hold off;
end

% plotTime = cell2mat(spanResampledData(:,1));
% plotIndex = find(plotTime > 11542 & plotTime <= 11606);
% plotIndex = 1:2000;
% plotSESubscript4Bracket3Pose(spanResampledData(plotIndex,1),spanResampledData(plotIndex,2),spanResampledData(plotIndex,3),spanResampledData(plotIndex,4),spanResampledData(plotIndex,5));
% plotSESubscript4Bracket3Pose(filterIntermediateState(plotIndex,1),filterIntermediateState(plotIndex,2),filterIntermediateState(plotIndex,4),spanResampledData(plotIndex,4),spanResampledData(plotIndex,5));

% plotSEBracket3Comparison(spanResampledData(plotIndex,2),filterIntermediateState(plotIndex,2),50);
% plotSEPose(spanResampledData(3000:6000,2));