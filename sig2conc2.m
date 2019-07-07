function [C,mask1] = sig2conc2(img,R10,M0,alpha,TR)

% equation to calculate concentration from image intensity

% R1(t)=-1/TR*ln(1-((S(t)-S(0))/S0*sin(alpha))+(1-m)/(1-m*cos(alpha)))
%over 1-cos(alpha)*((S(t)-S(0))/S0*sin(alpha))+(1-m)/(1-m*sin(alpha)))

% where m=exp(-R10*TR)
% then C(t)=(R1(t)-R1(0))/r1

% Yi Guo, 06/12/2014
% No mask comparing to Marc's version, otherwise allmost the same
% some simplification, pay attention to R1, and alpha unit!!!

Rcs=4.39;
nt=size(img,3);

tmp=mean(img,3);
th = max(tmp(:))/50;
mask1 = (tmp>th) & (M0>0) & (R10>0);

m=exp(-repmat(R10,[1  1 nt])*TR);
par2=(1-m)./(1-m*cos(alpha));

par1=(img-repmat(img(:,:,1),[1 1 nt]))./repmat(M0+eps,[1 1  nt])/sin(alpha);

B=(par1+par2);

Rt=-1/TR*real(log((1-B)./(1-cos(alpha)*B+eps)));

C=Rt-repmat(R10,[1 1  nt]);

C=C/Rcs;

C(C<0) = 0;
C(C>180)=0;

C=C.*repmat(mask1,[1 1  nt]);

end



