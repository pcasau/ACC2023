function out = l_to(x)
    out = -x(1)+h_to(x);
end
function out = h_to(x)
    out = x(3)^3/6-sign(f_to(x))*g_to(x)...
        *(x(3)*sign(f_to(x))+sqrt(abs(g_to(x))));
end
function out = g_to(x)
    out = x(3)^2/2+sign(f_to(x))*x(2);
end
function out = f_to(x)
    out = x(2)+sign(x(3))*x(3)^2/2;
end