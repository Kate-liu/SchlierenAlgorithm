clear
echo on

d1=43;
d2=7;
dx=0.15;
dy=0.1;
xy=dx/dy;
yx=dy/dx;

t=zeros(d1,d2);
t1=ones(d1,d2);
t0=zeros(d1,d2);
x=zeros(d1);
y=zeros(d2);
x(1)=0;
x(2)=dx/2;

for i=3:d1-1
    x(i)=x(i-1)+dx;
end

x(d1)=(d1-2)*dx;

y(1)=0;y(2)=dy/2;

for i=3:d2-1
    y(i)=y(i-1)+dy;
end

y(d2)=(d2-2)*dy;
t1=20*ones(d1,d2);
t=zeros(d1);
dt=0.1;ttt=30;
%nnn=tt/dt;
echo off


%for iii=1:nnn
%    ttt=iii*dt;
    tf=30;af=6.6;af=1/af;bta=-6.6;v=0.0625;
    tin=100;tout=100;d=0.05;l=6;
    for i=1:42
        if x(i)<v*ttt
            t1(i,1)=tin+(300-tout)*x(i)/(v*ttt);
        elseif x(i)>v*ttt+28*d
            t1(i,1)=300-(300-tout)*(x(i)-v*ttt-28*d)/(l-28*d-v*ttt);
        else 
            zz=-0.123*(x(i)-v*ttt)/d-3.52*exp(-0.123*(x(i)-v*ttt)/d);
            t1(i,1)=10060*exp(zz);
        end
    end
    
    for i=1:41
        for j=2:6
            t1(i,j)=t1(i,1)-10*(j-1);
        end
    end
    
    
for iii=1:500
    t0=t1;
    cd=1300;a=0.0003;
    an=[1.69,-0.594,0.401,-0.168,0.027,-0.037,0.046,-0.05, 0.039,-0.012];
    bn=[0,   0.333, 0.017,-0.131,0.054,0.0003,0.007,-0.012,0.026,0];
    fncp=zeros(d1,d2);
    for i=1:10
        fncp=an(i)*cos(i*pi/9*t1)+bn(i)*sin(i*pi/9*t1)+fncp;
    end
    fncp=fncp/4.1868;
    b=1.3e-6;c=1.5e-9;
    fnk=(a+b*t1+c*t1.^2)*360;
    
    for i=2:42
        for j=2:6
            fnae(i,j)=2*yx*fnk(i,j)*fnk(i+1,j)/(fnk(i,j)+fnk(i+1,j));
            fnaw(i,j)=2*yx*fnk(i,j)*fnk(i-1,j)/(fnk(i,j)+fnk(i-1,j));
            fnan(i,j)=2*xy*fnk(i,j)*fnk(i,j+1)/(fnk(i,j)+fnk(i,j+1));
            fnas(i,j)=2*xy*fnk(i,j)*fnk(i,j-1)/(fnk(i,j)+fnk(i,j-1));
        end
    end
    
    fnap0=cd*fncp*dx*dy/dt;
    fnbb=fnap0.*t1;
    %for i=2:41
    %    for j=1:5
    %        t1(i,j)=t(i,1)-10*(j-1);
    %    end
    % end
   % t0=t1;
   
    kk=af+0.5*dx/fnk(1,2);
    bb=fnbb(2,2)+tf*dy/kk;
    ap=fnae(2,2)+fnan(2,2)+fnap0(2,2)+dy/kk+2*xy*fnk(2,1)-bta*dx*dy;
    fff=fnae(2,2)*t1(3,2)+fnan(2,2)*t1(2,3)+2*xy*fnk(2,1)*t1(2,1)+bb;
    t1(2,2)=fff/ap;
    
    for j=3;5
        kk=af+0.5*dx/fnk(1,j);
        bb=fnbb(2,j)+tf*dy/kk;
        ap=fnae(2,j)+fnas(2,j)+fnan(2,j)+fnap0(2,j)+dy/kk-bta*dx*dy;
        fff=fnae(2,j)*t1(3,j)+fnan(2,j)*t1(2,j+1)+fnas(2,j)*t1(2,j-1)+bb;
        t1(2,j)=fff/ap;
    end
    
    kk1=af+0.5*dx/fnk(1,6);
    kk2=af+0.5*dy/fnk(1,6);
    bb=fnbb(2,6)+tf*dy/kk1+tf*dx/kk2;
    ap=fnae(2,6)+fnas(2,6)+fnap0(2,6)+dy/kk1+dx/kk2-bta*dx*dy;
    fff=fnae(2,6)*t1(3,6)+fnas(2,6)*t1(2,5)+bb;
    t1(2,6)=fff/ap;
    
    for i=3:40
        for j=2:6
            if j==2
                as=2*xy*fnk(i,1);
                fff=fnae(i,2)*t1(i+1,2)+fnaw(i,2)*t1(i-1,2)+fnan(i,2)*t1(i,3)+as*t1(i,1)+fnbb(i,2);
                ap=fnae(i,2)+fnaw(i,2)+fnan(i,2)+as+fnap0(i,2)+dy/kk-bta*dx*dy;
                t1(i,2)=fff/ap;
            elseif j==6
                kk=af+0.5*dy/fnk(i,6);
                bb=fnbb(i,6)+tf*dx/kk;
                fff=fnae(i,6)*t1(i+1,6)+fnaw(i,6)*t1(i-1,6)+fnas(i,6)*t1(i,4)+bb;
                ap=fnae(i,6)+fnaw(i,6)+fnas(i,6)+fnap0(i,6)+dx/kk-bta*dx*dy;
                t1(i,5)=fff/ap;
            else
                fff=fnae(i,j)*t1(i+1,j)+fnaw(i,j)*t1(i-1,j)+fnan(i,j)*t1(i,j+1)+fnas(i,j)*t1(i,j-1)+fnbb(i,j);
                ap=fnae(i,j)+fnaw(i,j)+fnan(i,j)+fnas(i,j)+fnap0(i,j)-bta*dx*dy;
                t1(i,j)=fff/ap;
            end
        end
    end
    
    for j=3:5
        kk=af+0.5*dx/fnk(42,j);
        bb=fnbb(41,j)+tf*dy/kk;
        ap=dy/kk+fnaw(41,j)+fnan(41,j)+fnas(41,j)+fnap0(41,j)-bta*dx*dy;
        fff=fnaw(41,j)*t1(40,j)+fnan(41,j)*t1(41,j+1)+fnas(41,j)*t1(41,j-1)+bb;
        t1(41,j)=fff/ap;
    end
    
    kk1=af+0.5*dx/fnk(42,6);
    kk2=af+0.5*dy/fnk(41,7);
    bb=fnbb(41,6)+tf*dy/kk1+tf*dx/kk2;
    ap=fnaw(41,6)+fnas(41,6)+fnap0(41,6)+dy/kk1+dx/kk2-bta*dx*dy;
    fff=fnaw(41,6)*t1(40,6)+fnas(41,6)*t1(41,5)+bb;
    t1(41,6)=fff/ap;
    kk=af+0.5*dx/fnk(42,2);
    bb=fnbb(41,2)+tf*dy/kk;
    ap=fnaw(41,2)+fnan(41,2)+fnap0(41,2)+dy/kk+2*xy*fnk(41,1)-bta*dx*dy;
    fff=fnaw(41,2)*t1(40,2)+fnan(41,2)*t1(41,3)+2*xy*fnk(41,1)*t1(41,1)+bb;
    t1(41,2)=fff/ap;
    
    if abs(abs(t1)-abs(t0))<20
       break;
       %else
       %t1=t0+0.5*(t1-t0);
    end
end


%if rem(iii,10)==0
        figure
        subplot(2,1,1)
        t111=t1';
        %mesh(t111);
        %view(2);
        pcolor(t111);
        subplot(2,1,2)
        ccc=contour(t111,[200,400,600,800,1000]);
        %ccc=contour(t111,5);
        clabel(ccc);
        %end
    