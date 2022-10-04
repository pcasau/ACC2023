function xi_pl = g(xi)
    x = xi(1:3);
    q = xi(4);
    n = xi(5);
    x_pl = x;
    q_pl = -q;
    n_pl = n+1;
    xi_pl = [x_pl;q_pl;n_pl];
end