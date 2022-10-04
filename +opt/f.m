function [dxi,u] = f(xi)
    global A B 
    x = xi(1:3);
    q = xi(4);
    n = xi(5);
    if n >= 4
        u = 0;
    else
        u = q;
    end
    dx = A*x+B*u;
    dq = 0;
    dxi = [dx;dq;0];
end