function[Error,U]= RMSE(U,I)
U = abs(U); I = abs(I);

E=sum(sum(abs((I(:)-U(:))).^2));         

E=E*1/(1e-23+sum(sum(abs((I(:))).^2)));



Error=mean((E));
