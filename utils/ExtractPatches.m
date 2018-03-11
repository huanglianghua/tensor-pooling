function patches = ExtractPatches( img, params )
%==========================================================================
% Divide gray level images into patches
% Input arguments
%   img.........h x w x n gray level images
%   params......an option structure whose fields are as follows:
%       patch_sz: a 1-by-2 integer vector that indicates the size of blocks. 
%               If block_sz is a scalar, size of all dimensions will be the
%               same. (required)
%       overlap_sz: a 1-by-2 integer vector that indicates the size of
%               overlaps. If overlap_sz is a scalar, overlap size of all
%               dimensions will be the same.(required)
%       decouple: a logical variable. If it is true, then each spatial
%               slice of blocks is vectorized.(default true)
% Output arguments:
% 	patches......the extracted patches.
%==========================================================================

if ~isfield(params, 'decouple')
    decouple = true;
else
    decouple = params.decouple;
end

sz = size(img);
patch_sz = params.patch_sz;
overlap_sz = params.overlap_sz;
patch_num = floor((sz(1:2) - overlap_sz)./(patch_sz - overlap_sz));

patches = zeros([patch_sz, sz(3), prod(patch_num)]);
% patches = zeros([patch_sz, prod(patch_num), sz(3)]);
for i = 1:patch_num(1)
    for j = 1:patch_num(2)
        ii = 1 + (i - 1)*(patch_sz(1) - overlap_sz(1));
        jj = 1 + (j - 1)*(patch_sz(2) - overlap_sz(2));
        idx = (j-1)*patch_num(1) + i;
        patches(:, :, :, idx) = ...
            img(ii:ii+patch_sz(1)-1, jj:jj+patch_sz(2)-1, :);
    end
end
patches = permute(patches,[1,2,4,3]);

if decouple
    patches = reshape( patches, [patch_sz(1)*patch_sz(2), prod(patch_num), sz(3)] );
end

patches = NormVector(patches);

end