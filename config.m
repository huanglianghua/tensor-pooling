%%****** Configurations of tracking parameters and sequence *******%%


%%*************************** Path settings ***********************%%

% title = 'woman';

base_path = './data/';
seq_path = [base_path title '/img/'];
gt_path = [base_path title '/groundtruth_rect.txt'];
imfiles = dir( [seq_path '*.jpg'] );

frame_num = length(imfiles);

save_path = './results/';
save_path_frames = [save_path 'frames/' title '/'];
save_path_affines = [save_path 'affines/'];
save_path_rects = [save_path 'rects/'];

addpath(genpath('dependency'));
addpath(genpath('utils'));


%%******************* Tracking parameters settings ****************%%

params.template_sz = [32 32];
params.nsample = 600;
params.affsig = [ 10 10 .015 .00 .00 .00 ];
params.nneg = 200;

% params for patch extraction
params.patch_sz = [6 6];
params.overlap_sz = [4 4];
params.patch_num = floor((params.template_sz(1:2) - params.overlap_sz) ./...
                   (params.patch_sz - params.overlap_sz));

% options for fkmeans
fkmeans_opt.careful = 1;
params.ncluster = 50;

% params for tensor subspace analysis
params.R_pos = [40 5 5 40];
params.R_neg = [40 5 5 40];

% params for l1 solution
l1_opt.lambda = 0.01;
l1_opt.lambda2 = 0;
l1_opt.mode = 2;
l1_opt.pos = true;

% params for updating condition
params.ff = 0.9;
params.update_rate = 5;

% indicators for showing and saving results
doshow = 1;
dosave = 1;
if dosave
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    if ~exist(save_path_frames, 'dir')
        mkdir(save_path_frames);
    end
    if ~exist(save_path_affines, 'dir')
        mkdir(save_path_affines);
    end
    if ~exist(save_path_rects, 'dir')
        mkdir(save_path_rects);
    end
end

% displaying options
show_opt.doshow = doshow;
show_opt.title = 'TPT Tracking Results';

%%************************ Initialization *************************%%

gt = load(gt_path);
affine = [ gt(1,1)+(gt(1,3)-1)/2, gt(1,2)+(gt(1,4)-1)/2,...
           gt(1,3)/params.template_sz(1), 0.0, gt(1,4)/gt(1,3), 0.0]';
