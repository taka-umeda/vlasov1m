function hdiag = diagnostics_init(prm)
global field kspec eng flag_exit;

flag_exit = 0;

hdiag.flag_field = 0;     % 0: do nothing, 1: save field data
hdiag.flag_eng   = 0;     % 0: do nothing, 1: save energy data
hdiag.flag_kspec = 0;     % 0: do nothing, 1: save k-spectrum data

%
% initialize graphics
%
hdiag.fig = figure;

set(0,'lang','en'); % for English menu
set(0,'DefaultAxesFontSize',10);
set(0,'DefaultAxesFontName','Helvetica');

set(hdiag.fig,'Units','normalized','Position',[0.5,0,0.5,0.8]);

set(hdiag.fig,'DoubleBuffer','on');
set(hdiag.fig,'KeyPressFcn','pauseplot(gcbo)');
set(hdiag.fig,'DeleteFcn','exitplot(gcbo)');

%
hdiag.color = [[       0          0   0.800000]; ... %blue
               [       0   0.500000          0]; ... %green
               [1.000000          0          0]; ... %red
               [0.750000   0.750000          0]; ... %yellow
               [0.750000          0   0.750000]; ... %ma
               [       0   0.750000   0.750000]; ... %cyan
               [       0          0          0]];    %black

%
for l = 1:length(prm.diagtype)
    hdiag.axes(l) = subplot(ceil(length(prm.diagtype)/2),2,l);
    
%   set(gca,'Drawmode','fast')
    set(gca,'NextPlot','ReplaceChildren')
    
    box on
    set(gca,'TickDir','out')
    set(gca,'TickLength',[0.018 0.07]);
    set(gca,'Layer','top')
    
    set(gca,'ColorOrder',hdiag.color);
    
    hxlabel = get(gca,'xlabel');
    set(hxlabel,'Units','Normalized');
    set(hxlabel,'Position',[0.5,-0.13,10]);
    
    switch prm.diagtype(l)
        case 6
            hdiag.flag_field = 1;
        case 7
            hdiag.flag_field = 1;
        case 8
            hdiag.flag_kspec = 1;
        case 9
            hdiag.flag_eng = 1;
    end
end

axes(hdiag.axes(1))
hdiag.htitle = title(sprintf('Time: %5.3f/%5.3f',0,prm.ntime*prm.dt));

% diagnostics
if hdiag.flag_field
    field = ones(3, prm.nx+1, prm.nplot+1)*NaN;
end
if hdiag.flag_kspec
    kspec = ones(prm.nx/2, prm.nplot+1)*NaN;
end
if hdiag.flag_eng
    eng = ones(1+prm.ns,prm.nplot+1)*0;
end
%
return;
