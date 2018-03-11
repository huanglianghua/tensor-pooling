function rects = Affine2Rect(affines, sz)
%AFFINE2RECT Converts affine parameters into rects
% rects: n rows, each row corresponds to a 4 elements rect [x y w h]
%        [x y] is the coordinate of the left top corner

rects = zeros(4,size(affines,2));
rects(3,:) = affines(3,:) * sz(1);
rects(4,:) = affines(5,:) .* rects(3,:);
rects(1:2,:) = affines(1:2,:) - (rects(3:4,:)-1) ./ 2;
rects = rects';

end