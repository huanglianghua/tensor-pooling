function wimgs = DrawNegative( frame, affine, params )
%%%%

%%
sz = params.template_sz;
n = params.nneg;

%% 得到neg_num个负模板
affines = repmat( affine(:), 1, n);%初始化所有负样本的仿射参数

affmat = affparam2mat( affine );
sigma = [ round( sz(2)*affmat(3) ) , round( sz(1)*affmat(3)*affine(5) ) , 0.0, 0.0, 0.0, 0.0];
affines = affines + randn(6,n).*repmat( sigma(:), 1, n);%对所有的仿射参数随机扰动

% 检查所有负样本到目标中心的距离是否大于一个定值
%--检查x坐标
dist = round( sigma(1)/4 );%到中心位置的横坐标距离，（负样本到中心位置的横坐标距离要大于该值）
center = affine(1);%中心位置的横坐标
left = center - dist;%左边界
right = center + dist;%右边界
id = affines(1,:)<=right & affines(1,:)>=center ;
affines(1,id) = right;
id = affines(1,:)>=left & affines(1,:)<center;
affines(1,id) = left;

%--检查y坐标
dist = round( sigma(2)/4 );
center = affine(2);
top = center - dist;%上边界
bottom = center + dist;%下边界
id = affines( 2,: )>=top & affines( 2,: )<center;
affines(2,id) = top;
id = affines(2,:)<=bottom & affines(2,:)>=center;
affines(2,id) = bottom;

affmats = affparam2mat( affines );%对所有的仿射参数进行转换，得到转换后的仿射参数
wimgs = warpimg( frame, affmats, sz );%由样本仿射参数得到样本的仿射图

end