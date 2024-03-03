function hdiag = diagnostics(prm,hdiag,jtime,jdiag,ifdiag,ff,fex,ajx,rho,xx,vx)
global field kspec eng flag_exit;

try
    % pause check
    flag = get(hdiag.fig,'UserData');
    if strcmp(flag,'pause')
        uiwait(hdiag.fig);
    end
    
    % exit check
    flag = get(hdiag.fig,'UserData');
    if strcmp(flag,'exit')
        flag_exit = 1;
        return;
    end
    
catch
    return
end

%
if hdiag.flag_eng
    eng(:,jdiag) = energy(ff,vx,fex,prm);
end
if hdiag.flag_field
    field(1,:,jdiag) =fex(3:prm.nx+3);
    field(2,:,jdiag) =rho(3:prm.nx+3);
    field(3,:,jdiag) =ajx(3:prm.nx+3);
end
if hdiag.flag_kspec
    tmp = fft(fex(4:prm.nx+3))/prm.nx;
    kspec(:,jdiag) = tmp(1:prm.nx/2);
end


%
% graphics
%
figure(hdiag.fig)

%
for l=1:length(prm.diagtype)
    %axes(hdiag.axes(l))
    set(gcf,'CurrentAxes',hdiag.axes(l));
    hdiag.nplt = l; % plate number
    
    type = prm.diagtype(l);
    switch type
        case 1
            hdiag = plotvdist(hdiag,jdiag,ff,vx,prm);
        case 2
            hdiag = plotfield(hdiag,jdiag,fex,xx,prm,1);
        case 3
            hdiag = plotfield(hdiag,jdiag,rho,xx,prm,2);
        case 4
            hdiag = plotfield(hdiag,jdiag,ajx,xx,prm,3);
        case 5
            hdiag = plotkspectrum(hdiag,jdiag,fex,prm);
        case 6
            % reserved for wk plot
        case 7
            hdiag = plotts(hdiag,jdiag,ifdiag,xx,prm); % time series plot
        case 8
            hdiag = plottsk(hdiag,jdiag,ifdiag,prm); % time series k plot
        case 9
            hdiag = plotenergy(hdiag,jdiag,ifdiag,prm);
        otherwise
            hdiag = plotphs(hdiag,jdiag,type-9,ff,xx,vx,prm);
    end
    
end

% Title
set(hdiag.htitle,'String',sprintf('Time: %5.3f/%5.3f',jtime*prm.dt,prm.ntime*prm.dt));

drawnow
return