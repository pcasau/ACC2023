function out = C(xi)
    x = xi(1:3);
    q = xi(4);
    out = opt.l_to(x)*q >= 0;
end