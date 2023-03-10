function pose = convertSpanToPose(span)

% compute scale from first lat value
scale = latToScale(span(1,2));

% init pose
spanSize = size(span,1);
pose     = cell(spanSize,4);
referenceTransition = [];

for i=1:spanSize

    % translation vector
    [t(1,1),t(2,1)] = latlonToMercator(span(i,2),span(i,3),scale);
    t(3,1) = span(i,4);

    % rotation matrix (OXTS RT3000 user manual, page 71/92)
    rx = deg2rad(span(i,8)); % pitch
    ry = deg2rad(span(i,9)); % roll
    rz = deg2rad(-span(i,10)); % heading
    %   rz = deg2rad(span(i,10)); % heading
    Rx = [1        0       0;
        0  cos(rx) sin(rx);
        0 -sin(rx) cos(rx)];
    Ry = [cos(ry) 0 -sin(ry);
        0 1 0;
        sin(ry) 0 cos(ry)];
    Rz = [cos(rz) sin(rz) 0;
        -sin(rz) cos(rz) 0;
        0 0 1];
    R = Ry*Rx*Rz;

    % normalize translation and rotation (start at 0/0/0)
    if isempty(referenceTransition)
        referenceTransition = t;
    end

    % add pose
    pose{i,1} = span(i,1);
    pose{i,2} = t-referenceTransition;
    pose{i,3} = span(i,5:7);
    pose{i,4} = sqrt(sum(pose{i,3}.^2));
    pose{i,5} = span(i,8:10);
    pose{i,6} = [R pose{i,2};0 0 0 1];
    pose{i,7} = [R' pose{i,2};0 0 0 1];
    

end

