function Cp=SAIF_p(tModel,time_scale,A,T,sigma,alpha,beta,s,tau)
% function to generate parker's AIF 
% input tModel format: zeros in front to decide the length of delay
%                      convert tModel unit to minutes inside this function

% Yi Guo, Yinghua Zhu, 10/25/2014

% Cb(t)=sum( A_n/sigma_n*sqrt(2*pi))*exp(-t-Tn)^2/2sigma_n^2)+alpha*exp(-beta*t)/(1+exp(-s(t-tau))) 

td=tModel>0;
if mean(diff(tModel))>0.5
tModel=tModel/60; % convert to minute unit if not
end


if nargin==1
time_scale=1;
A = [0.309 0.330]; %change A1 to 0.309 to decrease the peak, original [0.809 0.330]
% scaling of the peak
T = [0.17046 0.365]; % control slope and peak, exponential delay shape
sigma = [0.0563 0.132]; % control expoential slope shape
alpha = 1.050; % scaling of second peak
beta = 0.1685; % shape of second peak, decay rate
s = 38.078;  % shape of second peak,  how steep it is
tau = 0.483; % shape of second delay shape
end

tModel=tModel.*time_scale;

Cp = zeros(size(tModel));
for n = 1:2
    Cp = Cp + A(n)/sigma(n)/sqrt(2*pi)*exp(-(tModel-T(n)).^2/2/sigma(n)^2);
end
Cp = Cp + alpha*exp(-beta*tModel)./(1+exp(-s*(tModel-tau)));

Cp=Cp.*td;

Cp=Cp/3; % scale to mimic our data, moved inside this function

end
