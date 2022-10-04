global A B bar_tau K P top_eps bot_eps nw ns delta
delta = 0.05;
bar_tau = 1;
A = zeros(3);
A(1,2) = 1;
A(2,3) = 1;
B = [0 0 1]';
Q = diag([1 1e-2 1e-4]);
R = 1;
[K,P] = lqr(A,B,Q,R);
top_eps = 0.1;
bot_eps = top_eps*0.5;
zeta0 = [];
for J = 1:3
    x0 = [p0(J);v0(J);a0(J)];
    hx0 = x0;
    q0 = 1;
    tau0 = 0;

    [s0,eta1] = opt.initialize(hx0);
    ns = numel(s0);
    [w0,eta2] = LQR.initialize(hx0);
    nw = numel(w0);
    if q0 == 1
        eta0 = eta1;
    else
        eta0 = eta2;
    end
    t0 = 0;
    xi0 = [x0;hx0;q0;tau0;s0;w0;eta0;t0];
    zeta0 = [zeta0;xi0];
end
n = numel(xi0);
TSPAN = [0 10];
JSPAN = [0 40];
[t,j,zeta] = HyEQsolver(@(zeta)[f(zeta(1:n));f(zeta(n+1:2*n));f(zeta(2*n+1:3*n))],...
    @(zeta) [g(zeta(1:n));g(zeta(n+1:2*n));g(zeta(2*n+1:3*n))],...
    @(zeta) C(zeta(1:n)) && C(zeta(n+1:2*n)) && C(zeta(2*n+1:3*n)),...
    @(zeta) D(zeta(1:n)) || D(zeta(n+1:2*n)) || D(zeta(2*n+1:3*n)),...
    zeta0,TSPAN,JSPAN,1);

function [dxi,u] = f(xi)
    global ns nw A B rho
    x = xi(1:3);
    hx = xi(4:6);
    q = xi(7);
    tau = xi(8);
    s = xi(9:8+ns);
    w = xi(9+ns:8+ns+nw);
    t = xi(end);
    if q == 1
        [ds,u] = opt.f(s);
        dw = zeros(nw,1);
    else
        ds = zeros(ns,1);
        [dw,u] = LQR.f(w);
    end
    dx = A*x+B*(u+rho*sin(2*pi*0.1*t));
    dhx = zeros(3,1);
    dq = 0;
    dtau = 1;
    deta = 0;
    dxi = [dx;dhx;dq;dtau;ds;dw;deta;1];
end

function out = dist2star(xi)
    global ns nw
    x = xi(1:3);
    hx = xi(4:6);
    q = xi(7);
    tau = xi(8);
    s = xi(9:8+ns);
    w = xi(9+ns:8+ns+nw);
    if q == 1 
        x_star = s(1:3);
    else 
        x_star = w(1:3);
    end
    out = norm(x-x_star);
end

function next_xi = g(xi)
    global ns nw delta
    x = xi(1:3);
    hx = xi(4:6);
    q = xi(7);
    tau = xi(8);
    s = xi(9:8+ns);
    w = xi(9+ns:8+ns+nw);
    eta = xi(9+ns+nw);
    t = xi(end);
    next_x = x;
    if tau >= eta || dist2star(xi) >= delta
        next_hx = x;
        if inU(x,1)
            next_qs = 1;
        else
            next_qs = [];
        end
        if inU(x,2)
            next_qs = [next_qs 2];
        end
        next_q = next_qs(randsample(length(next_qs),1));
        next_tau = 0;
        if next_q == 1
            [next_s,next_eta] = opt.initialize(next_hx);
            next_w = w;
        else
            next_s = s;
            [next_w,next_eta] = LQR.initialize(next_hx);
        end
    elseif q == 1 && opt.D(s)
        next_hx = hx;
        next_q = q;
        next_tau = tau;
        next_s = opt.g(s);
        next_w = w;
        next_eta = eta;
    elseif q == 2 && LQR.D(w)
        next_hx = hx;
        next_q = q;
        next_tau = tau;
        next_s = s;
        next_w = LQR.g(w);
        next_eta = eta;
    else
        next_hx = hx;
        next_q = q;
        next_tau = tau;
        next_s = s;
        next_w = w;
        next_eta = eta;
    end
    next_xi = [next_x;next_hx;next_q;next_tau;next_s;next_w;next_eta;t];
end

function out = C(xi)
    global ns nw delta
    x = xi(1:3);
    hx = xi(4:6);
    q = xi(7);
    tau = xi(8);
    s = xi(9:8+ns);
    w = xi(9+ns:8+ns+nw);
    eta = xi(9+ns+nw);

    if tau > eta || dist2star(xi) > delta
        out = 0;
    else
        out = 1;
    end
    if q == 1 
        out = out & opt.C(s);
    else
        out = out & LQR.C(w);
    end
end

function out = D(xi)
    global ns nw delta
    x = xi(1:3);
    hx = xi(4:6);
    q = xi(7);
    tau = xi(8);
    s = xi(9:8+ns);
    w = xi(9+ns:8+ns+nw);
    eta = xi(9+ns+nw);

    if tau >= eta || dist2star(xi) >= delta 
        out = 1;
    else
        out = 0;
    end
    if q == 1 
        out = out | opt.D(s);
    else
        out = out | LQR.D(w);
    end
end

function out = inU(x,q)
    global P top_eps bot_eps
    if q == 1 && x'*P*x >= bot_eps
        out = 1;
    elseif q == 2 && x'*P*x <= top_eps
        out = 1;
    else
        out = 0;
    end
end