function out = D(xi)
    x = xi(1:3);
    q = xi(4);
    n = xi(5);
    out = (opt.l_to(x)*q <= 0) && (n < 3);
end
