%%%%%%%%%%%%%%%%%%%%%Backtesting APL
clear
Price=xlsread('D:\mth 800\AAPL Historical Data.xlsx','B2:B1532');
apl=zeros(1, length(Price));% Price is a column vector with the historic prices of the asset
m=length(apl);% apl is the vector of prices captured from the corresponding column in the apple file
%%%%%%Reverting the order in the vector of prices
for j=1:m
    apl(j)=Price(m-j+1);
end
logretaplprices=log(apl(2:m)./apl(1:m-1));%log of returns, one observation is lost
V=10^6; %initial value of the portfolio
loss2=-V*logretaplprices;%approximation based on Taylor expnasion
varhist2=quantile(loss2, [0.95 0.99]);%computing historic VaR
condloss95=(loss2>varhist2(1));% losses greater than the VaR_95
BTH95=sum(condloss95); %no. of times the loss is greated than VaR95
BTHS95=(BTH95-(m-1)*0.05)/sqrt((m-1)*0.05*(0.95)); %standardized BT
condloss99=(loss2>varhist2(2));% losses greater than the VaR_99
BTH99=sum(condloss99); %no. of times the loss is greated than VaR99
BTHS99=(BTH99-(m-1)*0.01)/sqrt((m-1)*0.01*(0.99)); %standardized BT
%If abs(BTHS)> 1.96 reject the method
mu=mean(logretaplprices); %estimating mean of logreturns
sigma=std(logretaplprices); %estimating standard dev. of logreturns
varnorm95=-V*mu+V*sigma*icdf('Normal',0.95,0,1); %normal var alpha=95%
condloss95=(loss2>varnorm95);% losses greater than the VaR_95, parametric gaussian
BTHPAR95=sum(condloss95); %no. of times the loss is greated than VaR95
BTHSPAR95=(BTHPAR95-(m-1)*0.05)/sqrt((m-1)*0.05*0.95); %standardized BT
varnorm99=-V*mu+V*sigma*icdf('Normal',0.99,0,1); %normal var alpha=99%
condloss99=(loss2>varnorm99);% losses greater than the VaR_99, parametric gaussian
BTHPAR99=sum(condloss99); %no. of times the loss is greated than VaR99
BTHSPAR99=(BTHPAR99-(m-1)*0.01)/sqrt((m-1)*0.01*0.99); %standardized BT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Parametric t-student
nu=4;% degrees of freedom t-student
sigmax=std(logretaplprices); %estimating standard dev. of logreturns
varstud95=-V*mu+V*sigmax*sqrt((nu-2)/nu)*icdf('T',0.95,nu); %student var alpha=95%
varstud99=-V*mu+V*sigmax*sqrt((nu-2)/nu)*icdf('T',0.99,nu); % student var alpha=99%
condlossstd95=(loss2>varstud95);% losses greater than the VaR_95, parametric student
BTHSTD95=sum(condlossstd95); %no. of times the loss is greated than VaR95
BTHSSTD95=(BTHSTD95-(m-1)*0.05)/sqrt((m-1)*0.05*0.95); %standardized BT
condlossstd99=(loss2>varstud99);% losses greater than the VaR_99, parametric student
BTHSTD99=sum(condlossstd99); %no. of times the loss is greated than VaR99
BTHSSTD99=(BTHSTD99-(m-1)*0.01)/sqrt((m-1)*0.01*0.99); %standardized BT
%%%%%%%%%%%%%%%%%%%%%Monte Carlo VaR Gaussian
ns=10^6;% number of simulatioms
mclossnorm=normrnd(-V*mu, V*sigma, 1,ns);%generating ns losses
varmcnorm=quantile(mclossnorm, [0.95 0.99]);
mccondloss95=(loss2>varmcnorm(1));% losses greater than the VaR_95
BTHMC95=sum(mccondloss95); %no. of times the loss is greated than VaR95
BTHSMC95=(BTHMC95-(m-1)*0.05)/sqrt((m-1)*0.05*0.95); %standardized BT
mccondloss99=(loss2>varmcnorm(2));% losses greater than the VaR_99
BTHMC99=sum(mccondloss99); %no. of times the loss is greated than VaR99
BTHSMC99=(BTHMC99-(m-1)*0.01)/sqrt((m-1)*0.01*0.99); %standardized BT
%%%%%%%%%%%%%%%%%%%%%Monte Carlo VaR Student
mclossstd=-V*mu+V*sigmax*sqrt((nu-2)/nu)*random('T',4,1,ns);%generating ns losses
varmcstd=quantile(mclossstd, [0.95 0.99]);
mccondloss95=(loss2>varmcstd(1));% losses greater than the VaR_95
BTHMCSTD95=sum(mccondloss95); %no. of times the loss is greated than VaR95
BTHSMCSTD95=(BTHMCSTD95-(m-1)*0.05)/sqrt((m-1)*0.05*0.95); %standardized BT
mccondloss99=(loss2>varmcstd(2));% losses greater than the VaR_99
BTHMCSTD99=sum(mccondloss99); %no. of times the loss is greated than VaR99
BTHSMCSTD99=(BTHMCSTD99-(m-1)*0.01)/sqrt((m-1)*0.01*0.99); %standardized BT
[BTHS95 BTHSPAR95 BTHSSTD95 BTHSMC95 BTHSMCSTD95];
[BTHS99 BTHSPAR99 BTHSSTD99 BTHSMC99 BTHSMCSTD99];
[BTH95 BTHPAR95 BTHSTD95 BTHMC95 BTHMCSTD95];%no. of exceedences 95
[BTH99 BTHPAR99 BTHSTD99 BTHMC99 BTHMCSTD99];%no. of exceedences 99
t95=icdf('T',0.95,4);
t99=icdf('T',0.99,4);
n95=icdf('Normal',0.975,0,1);
n99=icdf('Normal',0.995,0,1);
[n95 n99 t95 t99];