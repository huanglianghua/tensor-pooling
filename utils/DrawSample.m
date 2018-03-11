function [ wimgs, affines ] = DrawSample( img, affine, params )
%%
% img
% affine: 6x1, 6维仿射参数，指示跟踪框位置： ( x, y, w/template_size, angle, h/w, skew )
% params.nsample: 粒子个数
% params.affsig: 6x1, 高斯扰动的标准差
% params.template_sz: template_size，归一化（缩放）后的模版大小，一般为 32x32

n = params.nsample;

affines = repmat(affine, [1,n]);
randmat = randn(6,n);
affines = affines + randmat .* repmat(params.affsig(:), [1,n]); %上一帧跟踪框的位置，加上高斯随机扰动，产生下一帧的粒子

wimgs = warpimg(img, affparam2mat(affines), params.template_sz); %通过仿射变换得到缩放后的粒子，32x32

end

