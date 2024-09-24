function C=GrainGenerator_Sim(N,mu,lambda,seedNumber,LX,LY)

rng(seedNumber);        % seed for random number generator

C=zeros(LY,LX);         % matrix where grain identity will be stored
xn=randi(LX,[N,1]);     % random "seeds" of Voronoi line centers
yn=randi(LY,[N,1]);     % random "seeds" of Voronoi line centers
ln=random('InverseGaussian',mu,lambda,N,1);

x1=round(xn-ln/2);
x1=x1.*(x1>0);          % sets negative values to zero
x1=x1+1*(x1<1);         % sets zeros to one
x2=round(xn+ln/2);
x2=x2.*(x2<=LX);        % sets values above NX to zero
x2=x2+LX*(x2<1);        % sets zeros to NX

for y=1:LY
     for x=1:LX
         dmin=9e9;
         for i=1:N
             if x>=x1(i) && x<=x2(i)    % over/under line segment
                 if y>=yn(i)
                    d=min([abs(y-yn(i)) abs(LY-y+yn(i))]);
                 else
                    d=min([abs(y-yn(i)) abs(LY+y-yn(i))]);
                 end
             end
             if x<x1(i)                 % left of line segment
                if y>=yn(i)
                   d=min([sqrt((x1(i)-x)^2+(y-yn(i))^2) sqrt((x1(i)-x)^2+(LY-y+yn(i))^2) sqrt((LX-x2(i)+x)^2+(y-yn(i))^2)]);
                else
                   d=min([sqrt((x1(i)-x)^2+(y-yn(i))^2) sqrt((x1(i)-x)^2+(LY+y-yn(i))^2) sqrt((LX-x2(i)+x)^2+(y-yn(i))^2)]);
                end
             end
             if x>x2(i)                 % right of line segment
                if y>=yn(i)
                   d=min([sqrt((x2(i)-x)^2+(y-yn(i))^2) sqrt((x2(i)-x)^2+(LY-y+yn(i))^2) sqrt((LX+x1(i)-x)^2+(y-yn(i))^2)]);
                else
                   d=min([sqrt((x2(i)-x)^2+(y-yn(i))^2) sqrt((x2(i)-x)^2+(LY+y-yn(i))^2) sqrt((LX+x1(i)-x)^2+(y-yn(i))^2)]);
                end
             end
             if dmin>d                  % smallest distance found
                dmin=d;
                C(y,x)=i;
             end
         end
     end
end
