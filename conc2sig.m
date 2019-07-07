function S = conc2sig(CONC,R10,M0,Sb,alpha,TR)

% restore signal from contrast concentration

% equation to calculate concentration
% R1(t)=CONC*r1+R1(0)
% set E1=exp(-R1(t)*TR), m=exp(-R10*TR), 
% B=(1-E1)/(1-E1*cos(alpha))=(S(t)-S(0))/(M0*sin(alpha))+(1-m)/(1-m*cos(alpha))

% Then, S(t)=(B-(1-m)/(1-m*cos(alpha)))*M0*sin(alpha)+S(0)

% This is the version 1 with the difference of R1t and St, and the knowledge
% of Sb and R10

% Yi Guo, 08/2014

nt=size(CONC,3);
S=zeros(size(CONC));
m=exp(-repmat(R10,[1 1 nt]).*TR);
par2=(1-m)./(1-m*cos(alpha));


Rt=CONC*4.39+repmat(R10,[1 1  nt]);
E1=exp(-Rt*TR);
B=(1-E1)./(1-E1*cos(alpha));

S=(B-par2)*sin(alpha).*repmat(M0,[1 1  nt])+repmat(Sb,[1 1 nt]);

end


