function show_opt = ShowResult( frame, affine, sz, show_opt )
%%%%

%%
p = affparam2mat(affine);
M = [p(1) p(3) p(4); p(2) p(5) p(6)];
h = sz(1); w = sz(2);
corners = [ 1,-w/2,-h/2; 1,w/2,-h/2; 1,w/2,h/2; 1,-w/2,h/2; 1,-w/2,-h/2 ]';
corners = M * corners;

f = show_opt.f;

if f == 1  %first frame, create GUI
%     figure('Number','off', 'Name', show_opt.title);
    figure('Name', show_opt.title);
    show_opt.im_handle = imshow(uint8(frame), 'Border','tight', 'InitialMag', sqrt(2e9/numel(frame)) );
    show_opt.line_handle = line(corners(1,:), corners(2,:));
    show_opt.text_handle = text(10, 10, int2str(f));
    set(show_opt.text_handle, 'color', [0 1 1]);
    set(show_opt.line_handle, 'LineWidth', 2);
else
    set(show_opt.im_handle, 'CData', uint8(frame));
    set(show_opt.line_handle, 'XData', corners(1,:), 'YData', corners(2,:));
    set(show_opt.text_handle, 'string', int2str(f));
end

if ~show_opt.doshow
    set(gcf, 'visible', 'off');
end
drawnow


end
