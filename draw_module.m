function draw_module(p,R,side,color)
    N = 6;
    tt = linspace(0,2*pi,N+1);
    x = side*cos(tt);
    y = side*sin(tt);
    height = 0.2*side;
    z = -height/2*ones(1,N+1);
    %z_high = height/2*ones(1,N+1);
    aux = repmat(p,[1 N+1])+R*[x;y;z];
    x = aux(1,1:end);
    y = aux(2,1:end);
    z = aux(3,1:end);
    patch(x(1:end-1),y(1:end-1),z(1:end-1),color)
    %for I = 1:N
    %    patch([x(I:I+1) x(I+1:-1:I)],[y(I:I+1) y(I+1:-1:I)],...
    %        [-height/2*ones(1,2) height/2*ones(1,2)],'red')
    %end
    %patch(x(1:end-1),y(1:end-1),z_high(1:end-1),'red')
        
        
    