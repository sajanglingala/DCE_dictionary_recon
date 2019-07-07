clear all; 
close all; 
clc; 

%% load fully sampled DCE k-space data
fn=sprintf('case2_kspace.mat'); 


load (fn);
[nx,ny,nt,nc]=size(k);

%load /Users/sajan/Documents/DCE/freshcodes/kspacedatasets/T1maps/Case2_T1-15-04-21-09-44-50.mat;

%sl =5; 

%M0=M0(:,:,sl-1); 
%R1=R1(:,:,sl-1);
if ~exist('R1','var')  % use simulated uniform M0 and R1 if none exists
M0=5*ones(nx,ny); 
R1=1*ones(nx,ny);
end

%% Create a k-t under-sampling mask
% genRGA_2 function which generates a randomized golden angle radial sampling pattern
% on a Cartesian grid
R=20; % acceleration factor
[petable, U1] = genRGA_2(240, 240, nx, ny, round(nx*ny*50/R), bin2dec('0001'), 0.0, nt, 0.3, 0.0, 240/ny*sqrt(R*7), round(nx*ny/R*.7), 1);
U1=fftshift(fftshift(U1,1),2);
U1 = repmat(U1,[1 1 1 8]);
samp=U1;sampf=ones(size(U1));
S=find(samp);
Sf=find(sampf);

%% Coil sensitivity estimation from time collapsed data
[sjp] = est_coil(k,U1); 

%% Define key parameters 

% reference image time series - from fully sampled data
 ref_im_mc = (sqrt(nx*ny)*ifft2(k));
 ref = sum(ref_im_mc.*conj(sjp),4);

% Sequence parameters
opts.alpha=pi*15/180; % flip angle
opts.TR=0.006; % TR
ref = ref./max(ref(:)); 
Sb=ref(:,:,1); % base image (first time frame is fully sampled)
opts.M0=M0;
opts.R1=R1; 
opts.Sb=Sb; 
opts.nx=nx; opts.ny=ny; opts.nt=nt; opts.nc=nc;
sigmaf=3; %starting value of the smoothing low pass filter parameter (for iterative multi-scale optimization)
mask=create_lpf(nx,ny,nt,sigmaf); %low pass filter


ref_conc = sig2conc2((ref),opts.R1,opts.M0,opts.alpha,opts.TR);% signal to concentration





% Define the forward and backward encoding operators
A=@(x)A_fwd(x,S,sjp,opts);
Apre=@(x)A_fwd_pre(x,S,sjp,opts);

At=@(x)A_bwd(x,S,sjp,opts);
Atpost=@(x)A_bwd_post(x,S,sjp,opts);

% under-sampled k-sspace data
b = A(ref_conc); 

% load the pre-trained dictionary
load eTofts_dictionary.mat;

% Initial guess
x_init = At(b);
x_old = x_init;
opts.m=opts.nx*opts.ny;
opts.n=opts.nt;



cost=[];

%% Begin the iterative multi-scale optimization loop

for iter=1:50
    
    %% k-sparse projection
    k=3;
    [x] = ksparse_proj(x_old,V,opts,k);

    
    Recon_iter = reshape(x_old,opts.nx,opts.ny,opts.nt);
    x_proj = reshape(x,opts.nx,opts.ny,opts.nt); 
        
   %% cost calculations  
   Ax=Apre(x);
   temp = Ax(S)-b; 
   cost=[cost,sum(abs(temp(:)).^2)];

   %% data consistency
    Ax(S)=b;
    
    
%% spatial multi-scale smoothing for robustness to local minima
    if mod(iter,5) == 0
            sigmaf=sigmaf*2;
            mask=create_lpf(nx,ny,nt,sigmaf);
    elseif iter > 45
        mask = ones(size(mask)); 
    end
  
    Ax=Ax.*mask;
    x_old=Atpost(Ax);
 

    %% plot estimates during iteration loop
    figure(1),
    clf;
    subplot(2,2,1);imagesc(abs(ref_conc(:,:,15)),[0 0.1]); title('Reference concentration: one frame'); 
    subplot(2,2,2);imagesc(abs(Recon_iter(:,:,15)),[0 0.1]); title('Estimated concentration: one frame'); 
    subplot(2,2,3); plot(cost,'r'); title('cost');
    subplot(2,2,4); plot((squeeze(ref_conc(159,90,:))),'b'); hold on; 
    plot((squeeze(Recon_iter(159,90,:))),'r'); hold on; plot((squeeze(x_proj(159,90,:))),'g');hold off; legend('reference','estimated','k-sparse projection: estimated'); title('Example concentration time profile');  
    pause(0.1);
    
   
end
X_est=Recon_iter;
disp('Reconstruction ... DONE!'); 

%% Perform TK modeling using the rocketship tool 
disp('Call Rocketship for TK parameter estimation');
addpath(genpath('./rocketship_fitting/'))

delay=9; % delay frames for contrast injection
tpres=5/60; % temporal resolution, unit in minute!
time=[zeros(1,delay),[1:(opts.nt-delay)]*tpres];
AIF=SAIF_p(time); % Population-based AIF
hct = 0.4;  
AIF = AIF(:)./(1-hct); 
C_AIF=AIF;

yc=78:115; xc= 146:180;  % define a ROI
%%
tic
[ kt_r, ve_r, vp_r] = do_tk_fitting( (double(X_est)),xc,yc,double(C_AIF),time );
toc

tic
[ ktref, veref, vpref] = do_tk_fitting( (double(ref_conc)),xc,yc,double(C_AIF),time );
toc


%%
figure(2); 
 subplot(3,2,1); plot((squeeze(ref_conc(159,90,:))),'b'); hold on; 
 plot((squeeze(Recon_iter(159,90,:))),'r'); hold off; legend('reference','estimated'); title('Example concentration time profile');  
 subplot(3,2,3); imagesc(ktref,[0 0.3]);colorbar; title('K^{trans}: reference'); 
 subplot(3,2,4); imagesc(kt_r,[0 0.3]); colorbar;title('K^{trans}: estimated; R=20'); 
 subplot(3,2,5); imagesc(vpref,[0 0.15]);colorbar; title('v_p: reference'); 
 subplot(3,2,6); imagesc(vp_r,[0 0.15]); colorbar;title('v_p: estimated; R=20'); 