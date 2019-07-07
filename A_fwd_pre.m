function Ax=A_fwd_pre(x,samp,sjp,opts)
x=reshape(x,opts.nx,opts.ny,opts.nt);


img1 = conc2sig((x),opts.R1,opts.M0,opts.Sb,opts.alpha,opts.TR);

img1 = repmat(img1,[1 1 1 opts.nc]).*sjp; 
 
Ax=((1/sqrt(opts.nx*opts.ny))*fft2(img1)); 

    
