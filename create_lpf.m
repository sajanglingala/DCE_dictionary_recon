function mask=create_lpf(nx,ny,nt,sigmaf)
M=nx;
N=ny;%, N] = [nx,ny];
mask = zeros(M, N);
[fy, fx] = ndgrid(0:M/2, 0:N/2);
% Gaussian mask centred on zero frequency
mask(1:M/2+1, 1:N/2+1) = exp(-(fx.^2+fy.^2)/(2*sigmaf)^2);
% Do symmetries
mask(1:M/2+1, N:-1:N/2+2) = mask(1:M/2+1, 2:N/2);
mask(M:-1:M/2+2, :) = mask(2:M/2, :);
mask = repmat(mask,[1 1 nt 8]);
end


