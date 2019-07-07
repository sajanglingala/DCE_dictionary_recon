function [ ktrans_r1id,ve_r1id, vp_r1id] = do_tk_fitting( IDEAL_conc,xc,yc,C_AIF,tspan )
%DO_TK_FITTING Summary of this function goes here
%   Detailed explanation goes here
data = (IDEAL_conc(xc,yc,:));
% %for i = 1:256^2
c_tissue = reshape(data,length(xc)*length(yc),50);
%C_AIF=C_AIF/(1-0.4); 
roi_data{1}.Cp = C_AIF';
roi_data{1}.timer = tspan';
ktrans = zeros(1,length(xc)*length(yc)); 
ve = zeros(1,length(xc)*length(yc)); 
vp = zeros(1,length(xc)*length(yc)); 

for jj=1:length(xc)*length(yc)
roi_data{1}.Ct = c_tissue(jj,:)';

[roi_results, roi_residuals] = FXLfit_generic(roi_data, 1, 'ex_tofts', 0);
ktrans(jj) = roi_results(:,1);
ve(jj) = roi_results(:,2);
vp(jj) = roi_results(:,3);
end
% % 



ktrans_r1id = reshape(ktrans,length(xc),length(yc));
ve_r1id = reshape(ve,length(xc),length(yc));
vp_r1id = reshape(vp,length(xc),length(yc));

end

