
% Coil sensitivity estimation from time collapsed undersampled data

function [sjp_us] = est_coil(k,U1); 
ku = k.*U1;
[nx,ny,nt,nc] = size(ku);
kmean_us = squeeze(mean(ku,3)); 
Umean = squeeze(mean(U1,3)); 
xmean_us = sqrt(nx*ny)*ifft2(kmean_us.*(1./(eps+Umean))); 
img_us = sqrt(sum(abs(squeeze(xmean_us)).^2,3));
sj = zeros(nx,ny,nc);
for i=1:nc,
    sj(:,:,i) = squeeze(xmean_us(:,:,i))./(img_us(:,:));
end

for i =1:nt,
sjp_us(:,:,i,:) = sj(:,:,:); 
end
