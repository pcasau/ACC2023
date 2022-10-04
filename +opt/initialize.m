function [xi0,eta] = initialize(x)
    xi0 = [x;randi(2,1)*2-3;0];
    TSPAN = [0 10];
    JSPAN = [0 4];
    [t,j,xi] = HyEQsolver(@opt.f,@opt.g,@opt.C,@opt.D,xi0,TSPAN,JSPAN);
    eta = t(end)-1e-4;
end
    