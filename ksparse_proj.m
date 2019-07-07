function [x_proj] = ksparse_proj(x,V,opts,k)
%KSPARSE_PROJ Summary of this function goes here
%   Detailed explanation goes here

U=zeros(opts.m,size(V,1));
x =reshape(x,opts.m,opts.n); 
x_proj = zeros(size(x)); 

 for kk=1:size(x,1);
        a=OMP(V',x(kk,:)',k);
        x_proj(kk,:)=V'*a;
        U(kk,:)=a;
 end%


end

