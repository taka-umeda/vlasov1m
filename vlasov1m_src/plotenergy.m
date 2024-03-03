function hdiag = plotenergy(hdiag, jdiag, ifdiag, prm)
global eng

totaleng = sum(eng);
en = [totaleng;eng(1,:)];
for kk=1:prm.ns
    en=[en;eng(kk+1,:)];
end

if jdiag == 1
    t = (0:ifdiag:prm.ntime)*prm.dt;
    
    clr=jet(2+prm.ns);
    str = {'Total';'E';};
    for kk=1:prm.ns
        str=[str;sprintf('Sp%2d',kk)];
    end

    % lines & dots
    hold on
    for ii = 1:2+prm.ns
        helin(ii) = plot(t,en(ii,:),'Color',clr(ii,:));
        hedot(ii) = plot(t(jdiag),en(ii,jdiag),'.', ...
            'Color',clr(ii,:),'MarkerSize',15);
        
        % text label
        try
            set(helin(ii),'DisplayName',char(str(ii)));
            set(hedot(ii),'DisplayName',char(str(ii)));
        catch
        end
        hetxt(ii) = text(t(jdiag),en(ii,jdiag),str(ii));
        set(hetxt(ii),'VerticalAlignment','bottom', ...
            'HorizontalAlignment','right', ...
            'FontWeight','bold')
    end
    hold off
    set(hetxt(1),'HorizontalAlignment','left')
    
    % label
    ylabel('Energy');
    hxl = xlabel('Time');

    set(gca,'Yscale','log')
    set(gca,'YTick',[10^-16 10^-14 10^-12 10^-10 10^-8 10^-6 10^-4 10^-2 10^0 10^2 10^4]);
    
    set(hxl,'Units','Normalized')
    set(hxl,'Position',[0.5,-0.13,10])
    
    %
    hdiag.plt(hdiag.nplt).t = t;
    hdiag.plt(hdiag.nplt).helin = helin;
    hdiag.plt(hdiag.nplt).hedot = hedot;
    hdiag.plt(hdiag.nplt).hetxt = hetxt;
    
else
    
    %
    t = hdiag.plt(hdiag.nplt).t;
    helin = hdiag.plt(hdiag.nplt).helin;
    hedot = hdiag.plt(hdiag.nplt).hedot;
    hetxt = hdiag.plt(hdiag.nplt).hetxt;
    
    %
    for ii = 1:2+prm.ns
        set(helin(ii),'ydata',en(ii,:))
        set(hedot(ii),'xdata',t(jdiag),'ydata',en(ii,jdiag))
        set(hetxt(ii),'Position',[t(jdiag),en(ii,jdiag),0])
    end
    
end

%
mmax = max(max(en));
mmax = 10^ceil(log10(mmax));
idx = find(en>0);
mmin = min(min(en(idx)));
mmin = 10^(floor(log10(mmin)));
if isnan(mmax)
    mmax = eps*10;
    mmin = eps;
end

axis([0 prm.ntime*prm.dt mmin mmax]);

return
