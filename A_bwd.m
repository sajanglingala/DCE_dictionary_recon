function Atx=A_bwd(y,samp,sjp,opts)
%samp=repmat(samp,[1 1 1 n(3)]);
%y=y.*samp;
Atx = zeros(opts.nx,opts.ny,opts.nt, opts.nc); 
Atx(samp) = y; 
     Atx = (sqrt(opts.nx*opts.ny)*ifft2(Atx));%(:,:,:,ii)).*conj(squeeze(sjp(:,:,ii,:))));
     
    % Atx = sqrt(sum(abs(Atx).^2,4));
     Atx = sum((Atx).*conj(sjp),4);
     
     Atx = sig2conc2((Atx),opts.R1,opts.M0,opts.alpha,opts.TR);
     
Atx=reshape(Atx,opts.nx*opts.ny, opts.nt);
    
