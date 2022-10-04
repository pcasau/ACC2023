function out = postprocessing(t,zeta,color,ydiff,h,linestyle)
    side = 2*ydiff/sqrt(3);
    p = [zeta(:,1)';ydiff+zeta(:,4)';zeta(:,7)'];
    axes(h(1))
    out = plot3(p(1,:),p(2,:),p(3,:), linestyle);
    set(gca,'cameraposition',[-17.6872 -4.8057 9.1767],...
        'cameratarget',[-1.4686 -0.1264 0.1256])
    xlabel('$x$');ylabel('$y$');zlabel('$z$');
    axis equal
    hold on
    grid on
    fps = 1; %frames per second
    t0 = 0;
    grv = [0;0;-9.81];
    rz = zeros(3,numel(t));
    a = zeros(3,numel(t));
    for I = 1:numel(zeta(:,1))
        a(:,I)  = zeta(I,[3 6 9])'-grv;
        rz(:,I) = a(:,I)./norm(a(:,I));
        rx = zeros(3,1);
        rx(1) = abs(rz(3,I))/sqrt(rz(1,I)^2+rz(3,I)^2);
        rx(3) = -rz(1,I)*rx(1)/rz(3,I);
        ry = -cross(rx,rz(:,I));
        R = [rx';ry';rz(:,I)'];
        if t(I)-t0 >= 1/fps
            axes(h(1))
            draw_module(p(:,I),R',side,color)
            %draw_arrow(zeta(I,1),zeta(I,4),zeta(I,7),zeta(I,2),zeta(I,5),zeta(I,8));
            %draw_arrow(repmat(zeta(I,1),[3,1]),repmat(zeta(I,4),[3,1]),repmat(zeta(I,7),[3,1]),R(:,1),R(:,2),R(:,3));
            t0 = t(I);
        end
    end
    axes(h(2))
    plot(t,sqrt(sum((a.^2)',2)),linestyle)
    hold on
    grid on
    ylabel('Specific Thrust [$m/s^2$]')
    xlabel('$t$ [s]')
end

function out = S(x) 
    out = [0 -x(3) x(2);x(3) 0 -x(1); -x(2) x(1) 0];
end
function out = PTS(x)
    out = eye(3)-x*x';
end
    
    