%%************************ Experimental Settings ************************%%

% clc;
% clear;
% close all;

config;

sz = params.template_sz;
psz = params.patch_sz;
nsample = params.nsample;

tensors_pos = sptensor( [params.ncluster, params.patch_num, params.update_rate] );
results = zeros(6, frame_num);

update_index = 1;

%%************************** Start Tracking *****************************%%

for f = 1:frame_num
    tic
    disp( ['frame index: ' num2str(f)] );
    
    frame_color = imread( [seq_path imfiles(f).name] );
    if size(frame_color,3) == 3
        frame = double(rgb2gray(frame_color));
    else
        frame = double(frame_color);
        frame_color = cat(3,frame,frame,frame);
    end
    show_opt.f = f;
    
    
    if f == 1
        %% Initialize models (D, sparse tensor template) in the first frame
        % extract 9 samples with 1 pixel offset
        offset = [ 0 0 0 -1 -1 -1 1 1 1; 0 -1 1 0 -1 1 0 -1 1; zeros(4,9) ];
        affines = repmat(affine,[1,9]) + offset;
        wimgs = warpimg(frame, affparam2mat(affines), sz);
        % obtain dictionary
        patches = ExtractPatches(wimgs, params);
        x = reshape(patches, prod(psz), numel(patches) / prod(psz))';
        [~, D] = fkmeans( x, params.ncluster, fkmeans_opt );
        D = NormVector(D');
        % obtain template (sparse pooling tensor in the 1st frame)
        tensor0 = TensorPooling(patches(:,:,1), D, params, l1_opt);
        tensors_pos(:,:,:,1) = sptensor(tensor0);
        results(:, f) = affine;
    else
        %% Perform tracking
        likelihoods = zeros(params.nsample, 1);
    
        [wimgs, affines] = DrawSample(frame, affine, params);
        patches = ExtractPatches(wimgs, params);
        tensors = TensorPooling(patches, D, params, l1_opt);
        
        if f >= 2 && f <= params.update_rate
            for i = 1:nsample
                tmp = min(tensors(:,:,:,i), tensor0);
                likelihoods(i) = sum(tmp(:));
            end
        else
            likelihoods = Evaluate(tensors, T, T_neg);
        end
        
        [likelihood, max_id] = max(likelihoods);
        affine = affines(:, max_id);
        results(:,f) = affine;
        
        disp( ['likelihood: ' num2str(likelihood)] );
        
        %% Update model
        if likelihood > 0
            update_index = update_index + 1;
            tensors_pos(:,:,:,update_index) = sptensor(tensors(:,:,:,max_id));
        end
        if update_index == params.update_rate
            if ~exist('T', 'var')
                T = TuckerALS(tensors_pos, min(params.R_pos, size(tensors_pos)));
            else
                T = TuckerUpdate(tensors_pos, T, params.ff);
            end
            update_index = 0;
        end
        
        %% Collect negative samples
        if f >= params.update_rate && likelihood > 0
            wimgs = DrawNegative(frame, affine, params);
            patches = ExtractPatches(wimgs, params);
            tensors = TensorPooling(patches, D, params, l1_opt);
            T_neg = TuckerALS(sptensor(tensors), params.R_neg);
        end
    end
    
    %% Display result
    show_opt = ShowResult(frame_color, affine, sz, show_opt);
    if dosave
        path = [save_path_frames imfiles(f).name];
        saveas(gcf, path, 'jpg');
    end
    
    toc
end


%%******************** End Tracking and Save Results ***********************%%

if dosave
    save( [save_path_affines title '.mat'], 'results' );
    dlmwrite( [save_path_rects title '.txt'], Affine2Rect(results, sz));
end
