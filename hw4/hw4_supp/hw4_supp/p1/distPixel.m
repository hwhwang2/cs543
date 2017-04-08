function [D] = distPixel(rgb1,x1,y1,rgb2,x2,y2,m,S)
%     dc^2 + (ds/S)^2 * m^2
    vc = squeeze(rgb1)-squeeze(rgb2);
    ds2 = (x1-x2)^2 + (y1-y2)^2;
    D = sqrt( sum(vc.^2) + ds2/(S^2)*(m^2) );
end