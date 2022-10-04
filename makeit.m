clear all
close all
run('fig_perturbations.m')
%%
clear all;close all;
run('draw_trajectories.m')
figure(2)
[~,~,~,aux] = legend({'Vehicle 1','Vehicle 2'},...
    'position',[0.6950    0.6456    0.2877    0.3141]);
ylbl = get(gca,'YLabel');