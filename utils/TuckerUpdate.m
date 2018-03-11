function T = TuckerUpdate(tensors, T, ff)
%%%%

%%

for i = 1:4
    if i == 4
        tmat = double(tenmat(tensors, i, 't'));
    else
        tmat = double(tenmat(tensors, i));
    end
    [T.basis{i}, T.D{i}, T.means{i}, T.nsample] = ICVD...
        (tmat, T.basis{i}, T.D{i}, T.means{i}, T.nsample, T.R(i), ff);
end


    function [u, d, mu, n] = ICVD(data, u0, d0, mu0, n0, r, ff)
        n = size(data, 2);
        mu = mean(data, 2);
        data = data - repmat(mu, [1,n]);
        data = [data, sqrt(n*n0/(n+n0))*(mu0(:)-mu)];
        n = n + ff * n0;
        
        sz = size(mu0);
        mu = (ff * n0 * mu0(:) + n * mu) / (n + ff*n0);
        mu = reshape(mu, sz);
        
        data_proj = u0' * data;
        data_res = data - u0 * data_proj;
        
        [q, ~] = qr(data_res, 0);
        data = [ff * d0 data_proj; zeros([size(q,2) length(d0)]) q' * data_res];
        r = min(r, n);
        [u, d, ~] = svds(data, r);
        
        u = [u0 q] * u;
    end

end
