function [cIndMap, time, imgVis] = slic(img, K, compactness)

%% Implementation of Simple Linear Iterative Clustering (SLIC)
%
% Input:
%   - img: input color image
%   - K:   number of clusters
%   - compactness: the weighting for compactness
% Output: 
%   - cIndMap: a map of type uint16 storing the cluster memberships
%   - time:    the time required for the computation
%   - imgVis:  the input image overlaid with the segmentation
m = compactness;
ItrTimes = 40;
threshold = 10;
tic;
% Put your SLIC implementation here
im = rgb2lab(img);
[x,y,RGB] = size(im);
N = x*y;
S = (sqrt(N/K));
% 1. Initialize cluster centers on pixel grid in steps S, Set label l(i) = ?1 for each pixel i. Set distance d(i) = ? for each pixel i.
l = ones(x,y)*-1;
C = combvec([S:S:x],[S:S:y])';
C = round(C);
S = round(S);
% 2. Move centers to position in 3x3 window with smallest gradient
[X, Y] = meshgrid(-1:1,-1:1);
parfor k = 1:size(C,1)
    PX = X+C(k,1);
    PY = Y+C(k,2);
    g = mean( im(C(k,1)-1:C(k,1)+1,C(k,2)-1:C(k,2)+1,:),3 ) - mean( im(C(k,1),C(k,2),:) );
    assert(g(2,2) == 0)
    [M,I] = min(g(:));
    a(k) = PX(I);
    b(k) = PY(I);
end
% K x 2 cluster centers
C=[a' b'];
% 3. Compare each pixel to cluster center within 2S pixel distance and assign to nearest
for itr = 1:ItrTimes
    % Assignment
    dist = ones(x,y)*inf;
    for k = 1:size(C,1)
        % x,y windows around centers
        Rx = [C(k,1)-S:C(k,1)+S]; Rx(Rx<1) = []; Rx(Rx>x) = [];
        Ry = [C(k,2)-S:C(k,2)+S]; Ry(Ry<1) = []; Ry(Ry>y) = [];
        pixels = combvec(Rx,Ry)';
        for pts = 1:size(pixels,1)
            % calculate distance square
            vc = squeeze( im(pixels(pts,1),pixels(pts,2),:) )-squeeze(im(C(k,1),C(k,2),:));
            ds2 = (pixels(pts,1)-C(k,1))^2 + (pixels(pts,2)-C(k,2))^2;
            D = sum(vc.^2) + ds2/(S^2)*(m^2);
            if D < dist(pixels(pts,1),pixels(pts,2))
                dist(pixels(pts,1),pixels(pts,2)) = D;
                l(pixels(pts,1),pixels(pts,2)) = k;
            end
        end
    end
    % Update
    % Compute new cluster centers.
    Cnew = ones(size(C,1),size(C,2));
    parfor k = 1:size(C,1)
        [Rx Ry] = find(l == k);
        if size(Rx,1) < S^2*0.5
            C(k,:) = [-1 -1];
            Cnew(k,:) = [-1 -1];
            continue
        end
        subim = im(Rx,Ry,:);
        r = diag(subim(:,:,1));
        a = diag(subim(:,:,2));
        b = diag(subim(:,:,3));
        d = findDistSum(Rx,Ry,r,a,b,m,S)
        [M I] = min(d);
        Cnew(k,:) = [Rx(I) Ry(I)];
    end
    a = find(C(:,1) == -1);
    C(a,:) = [];
    Cnew(a,:) = [];
    % error time e
    error = inf;
    if size(a,1) == 0
        error = sum(sqrt(sum((Cnew - C).^2,2)));
    end
    C = Cnew;
    if error < threshold
        break
    end
end
%
image(l);
[gx gy] = gradient(l);
g = gx.^2+gy.^2;
l = uint16(l);
g = g~=0;
g = bwmorph(g, 'skel');
img([g g g]) = 255;
imgVis = img;
cIndMap = l;
time = toc;
figure
imshow(img);

end

