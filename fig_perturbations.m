global rho
layout = (1:5)'*ones(1,3);
h = create_axis(layout,15,'leftmargin',0.15);
%h(5) = create_axis([1 1],15);
h(6) = create_axis([1 1],15);
colors = get(gca,'colororder');
rhov = [0 0.01 0.1];
rng(1) %set constant seed
for J = 1:numel(rhov)
    rho = rhov(J);
    x0 = [-0.2949
        0.1868
        0.1704];
    multimode;
    for I = 1:3
        axes(h(I))
        aux = plot(t,xi(:,I),'color',colors(J,:));
        hold on
        plot(t(events),xi(events,I),'*','color', get(aux,'color'),'markersize',12)
    end
    switch_idx = find(diff(xi(:,7)));
    tswitch{J} = t(switch_idx);
    axes(h(4))
    aux = plot(t,d,'color',colors(J,:));
    hold on
    plot(t(events),d(events),'*','color', get(aux,'color'),'markersize',12)
    axes(h(5))
    leg_hdl(J) = plot(t,V,'color',colors(J,:));
    hold on
    plot(t(events),V(events),'*','color', get(leg_hdl(J),'color'),'markersize',12)
    axes(h(6))
    aux = plot(t,xi(:,17),'color',colors(J,:));
    hold on
    plot(t(events),xi(events,17),'*','color', get(aux,'color'),'markersize',12)
end
for I = 1:6
    axes(h(I))
    grid on
    if any(I == [1 2 3])
        set(gca,'xticklabel','')
        ylbl = ylabel(['$x_' num2str(I) '$']);
    elseif I == 4 
        set(gca,'xticklabel','')
        ylbl = ylabel(['$\norm{\xs-\xs^\star(\tau)}$']);
    elseif I == 5
        ylbl = ylabel('$\xs\tp\Ps \xs$');
    end
    set(ylbl,'position',get(ylbl,'position')-[0.4 0 0]);
    ylim = enlarge(get(gca,'ylim'),1.1);
    set(gca,'ylim',ylim)
    for J = 1:3
        line((tswitch{J}*ones(1,2))',repmat(ylim',[1,numel(tswitch{J})]),'color',colors(J,:),'linestyle','--')
    end
end
set(h(4),'ytick', [0 0.025 0.050],'yticklabel', {'0','0.025','\delta'},...
    'ylim',[-0.003 0.053]);
axes(h(1))
[~,~,~,aux] = legend(leg_hdl,{'$\rho=0$','$\rho=0.01$', '$\rho=0.1$'},...
    'position',[0.7091    0.1672    0.2728    0.0850]);
axes(h(5))
xlabel('$t$')
%xlim = get(gca,'xlim');
line(xlim,bot_eps*[1 1],'color','k','linestyle','--')
line(xlim,top_eps*[1 1],'color','k','linestyle','-.')
%text(-2,bot_eps*0.5,'$\lbar{\epsilon}$')
%text(-2,top_eps*1.5,'$\bar{\epsilon}$')
