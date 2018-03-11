function tensors = TensorPooling( patches, D, params, l1_opt, sps )
%%====%%
%%====%%

if nargin < 5
    sps = 0;
end

I1 = params.ncluster;
I2 = params.patch_num(1);
I3 = params.patch_num(2);
I4 = size(patches, 3);

l1_opt.L = prod(params.patch_sz);

patches = reshape( patches, prod(params.patch_sz), I2*I3*I4 );
x = NormVector(patches);
coeffs = mexLasso(x, D, l1_opt);
tensors = reshape( full(coeffs), [I1 I2 I3 I4] );

if sps
    tensors = sptensor(tensors);
end

end