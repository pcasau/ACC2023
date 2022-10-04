function [dxi,u] = f(xi)
    global A B K
    x = xi(1:3);
    u  = -K*x;
    dxi = A*x+B*u;