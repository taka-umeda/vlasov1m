function diagnostics_last(hdiag, jtime, prm)
figure(hdiag.fig)

%
for k=1:length(prm.diagtype)
    axes(hdiag.axes(k))
    
    n = prm.diagtype(k);
    switch n
        %case 10
        % axes(hdiag.hlegend)
        case 6
            plotspectr(prm);
            %h = get(gca,'xlabel');
            %set(h,'Units','Normalized')
            %set(h,'Position',[0.5,-0.13,10])
    end
end

return