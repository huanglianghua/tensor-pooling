function likelihoods = Evaluate(tensors, T, T_neg)
%%%%

%%
costs_pos = EvaluateCost(tensors, T);
costs_neg = EvaluateCost(tensors, T_neg);

likelihoods = zeros(size(tensors,4), 1);
for k = 1:size(tensors,4)
    likelihoods(k) = costs_neg(k) - costs_pos(k);
end


    function costs = EvaluateCost(tensors, T)
        n = size(tensors, 4);
        costs = zeros(n,1);
        tensors = tensor(tensors - repmat(double(T.means{4}), [1,1,1,n]));
        
        basis = T.basis;
        tensors_proj = ttm(tensors, basis, [1,2,3], 't');
        tensors_res1 = tensors - ttm(tensors_proj, basis, [1,2,3]);
        
        tensors = tenmat(tensors, 4, 't');
        tensors_proj = basis{4}' * tensors;
        tensors_res2 = tensors - basis{4} * tensors_proj;
        
        for i = 1:n
            d1 = norm(tensors_res1(:,:,:,i));
            d2 = norm(tensors_res2(:,i));
            costs(i) = 0.5 * d1 + d2;
        end
    end

end