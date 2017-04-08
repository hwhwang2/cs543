function [d] = findDistSum(Rx,Ry,r,g,b,m,S)
    d = ones(1,size(Rx,1));
    parfor pts = 1:size(Rx,1)
        distsqarray = (Rx - Rx(pts)).^2 + (Ry - Ry(pts)).^2;
        distcolorarray = (r - r(pts)).^2 + (g - g(pts)).^2 + (b - b(pts)).^2;
        d(pts) = sum(sqrt( distcolorarray + distsqarray/(S^2)*(m^2) ));              
    end 
end