function hdiag = plotvdist(hdiag, jdiag, ff, vx, prm)

fmax=zeros(prm.ns,1);
ind =zeros(prm.ns,1);
for kk=1:prm.ns
    fv(:,kk)=mean(ff(:,4:prm.nx+3,kk),2);
    [fmax(kk),ind(kk)]=max(fv(:,kk));
end

if jdiag == 1
    clr=jet(prm.ns);
    hold on
    for kk=1:prm.ns
        str=sprintf('Sp%2d',kk);
        hplot(kk) = plot(vx(:,kk),fv(:,kk),'-','Color',clr(kk,:));
        htext(kk) = text(vx(ind(kk),kk),fmax(kk),str,'Color',clr(kk,:), ...
                        'VerticalAlignment','Bottom','FontWeight','bold');
    end
    hold off
    xlabel('Vx');
    ylabel('f(Vx)');
    
    %set(gca,'xlim',[-prm.vmax*ren.v prm.vmax*ren.v])
    
    hdiag.plt(hdiag.nplt).hplot = hplot;
    hdiag.plt(hdiag.nplt).htext = htext;
    %    hdiag.plt(hdiag.nplt).hcv = hcv;
    %    hdiag.plt(hdiag.nplt).vv = vv;
    
else
    hplot = hdiag.plt(hdiag.nplt).hplot;
    htext = hdiag.plt(hdiag.nplt).htext;
    %    hcv = hdiag.plt(hdiag.nplt).hcv;
    %    vv = hdiag.plt(hdiag.nplt).vv;
    
    for kk=1:prm.ns 
        set(hplot(kk),'ydata',fv(:,kk));
        set(htext(kk),'Position', [vx(ind(kk),kk) fmax(kk) 0]);
    end    

end

return