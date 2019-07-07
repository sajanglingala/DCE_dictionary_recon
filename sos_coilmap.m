% Sensitivity map estimation using J-SENSE (we use this for all rec)
% Initialize using SOS
% Iterate: no change in solution ?
% Check !!

function sj = sos_coilmap(x)


[nx,ny,nt,nc] = size(x);
img = sqrt(sum(abs(x).^2,4));



sj = zeros(nx,ny,nt,nc);
for i=1:nc,
    for j = 1:nt
    sj(:,:,j,i) = squeeze(x(:,:,j,i))./(img(:,:,j));
    end
end
% 
%    %% jsense
% for i = 1:100
%     img = mask.*sum(x.*conj(sj), 3)./(sum(abs(sj).^2, 3)+nmask);
%     sj = (x)./repmat(img+nmask,[1 1 nc]);
%     sj = sj.*repmat(mask,[1 1 nc]);
% end
