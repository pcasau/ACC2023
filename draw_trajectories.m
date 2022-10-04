global rho
rho=0;
rng(1); %set seed
colors = {'red','blue'};
linestyle = {'k','k--'};
ydiff = (0.1*sqrt(3)/2)*[1 -1];
figure('position',[778   901   403   420])
h(1) = axes;
h(2) = create_axis(ones(1,3),15,'bottommargin',0.2,'leftmargin',0.15);
for I = 1:2
    eval(['load ' colors{I} '_init'])
    quadrotor;
    hleg(I) = postprocessing(t,[zeta(:,1:3),zeta(:,n+1:n+3),zeta(:,2*n+1:2*n+3)],colors{I},ydiff(I),h,linestyle{I});
end
[~,~,~,aux] = legend(hleg,{'Vehicle 1','Vehicle 2'},'position',...
    [0.6203    0.7714    0.3175    0.1560]);