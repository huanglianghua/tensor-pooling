function Y = NormVector( X )
%%%%
%%%%

%%
sz = size(X);
n = prod(sz) / sz(1);
X = reshape(X, [sz(1), n]);
Y = zeros(size(X));

for i = 1:n
    k = norm(X(:,i));
    if k ~= 0
        Y(:,i) = X(:,i) / k;
    end
end
Y = reshape(Y, sz);

end