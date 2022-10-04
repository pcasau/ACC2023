function hdl = create_axis(layout,width,varargin)
%
% CREATE_AXIS(layout,width,'option',value,...)
% OPTIONS
%  TopMargin - 0
%  BottomMargin - 0.1
%  LeftMargin - 0.1
%  RightMargin - 0
%  InnerXMargin - 0.025
%  InnerYMargin - 0.025
%
    top = 0;
    bot = 0.1;
    lft = 0.1;
    rgt = 0;
    inx = 0.025;
    iny = 0.025;
    for I = 1:2:numel(varargin)
        if strcmpi(varargin{I},'TopMargin')
            top = varargin{I+1};
        end
        if strcmpi(varargin{I},'BottomMargin')
            bot = varargin{I+1};
        end
        if strcmpi(varargin{I},'LeftMargin')
            lft = varargin{I+1};
        end
        if strcmpi(varargin{I},'RightMargin')
            rgt = varargin{I+1};
        end
        if strcmpi(varargin{I},'InnerXMargin')
            inx = varargin{I+1};
        end
        if strcmpi(varargin{I},'InnerYMargin')
            iny = varargin{I+1};
        end
    end
    [m,n] = size(layout);
    M = max(max(layout));
    figure('units','centimeters','position',[0 0 width m*width/n])
    w0 = 1-lft-rgt;
    w  = (w0-(n-1)*inx)/n;
    h0 = 1-top-bot;
    h  = (h0-(m-1)*iny)/m;
    for I = 1:M
        [i,j] = find(layout == I);
        i0 = min(i);
        j0 = min(j);
        i1 = max(i);
        j1 = max(j);
        xI = lft+(j0-1)*(w+inx);
        wI = (1+j1-j0)*w+(j1-j0)*inx;
        yI = bot+(h+iny)*(m-i1);
        hI = (1+i1-i0)*h+(i1-i0)*iny;
        hdl(I) = axes('position',[xI yI wI hI]);
    end