%%%%%%%Expected Shortfall computation Apple, Gaussian distribution
apl=zeros(1, length(Price));
m=length(apl);% apl is the vector of prices captured from the corresponding column in the apple file
t = datetime(2012,12,15) + caldays(1 :m);%(not in use)
%%%%%%Reverting the order in the vector of prices
for j=1:m
    apl(j)=Price(m-j+1);
end
t1=datetime(2012,12,15) + caldays(1 :m-1);%(not in use)
logretwtiprices=log(apl(2:m)./apl(1:m-1));%log of returns, one observation is lost
V=10^6; %initial value of the portfolio
loss2=-V*logretwtiprices;%approximation based on Taylor expnasion
varhist2=quantile(loss2, [0.95 0.99]);%computing historic VaR
condloss95=(loss2>varhist2(1));% losses greater than the VaR_95
eshist95=sum(loss2.*condloss95)/sum(condloss95);% expected shortfall 95%
condloss99=(loss2>varhist2(2));% losses greater than the VaR_99
eshist99=sum(loss2.*condloss99)/sum(condloss99);% expected shortfall 99%
mu=mean(logretwtiprices); %estimating mean of logreturns
sigma=std(logretwtiprices); %estimating standard dev. of logreturns
varnorm95=-V*mu+V*sigma*icdf('Normal',0.95,0,1); %normal var alpha=95%
varnorm99=-V*mu+V*sigma*icdf('Normal',0.99,0,1); %normal var alpha=99%
esnorm95=-V*mu+V*sigma*pdf('Normal',icdf('Normal',0.95,0,1),0,1)/0.05 ; %normal var alpha=95%
esnorm99=-V*mu+V*sigma*pdf('Normal',icdf('Normal',0.99,0,1),0,1)/0.01; %normal var alpha=99%
%%%%%%%%%%%%%%%%%%%%%Monte Carlo VaR
ns=10^6;% number of simulatioms
mclossnorm=normrnd(-V*mu, V*sigma, 1,ns);%generating ns losses
varmcnorm=quantile(mclossnorm, [0.95 0.99]);
mccondloss95=(mclossnorm>varmcnorm(1));% losses greater than the VaR_95
mceshist95=sum(mclossnorm.*mccondloss95)/sum(mccondloss95);% expected shortfall 95%
mccondloss99=(mclossnorm>varmcnorm(2));% losses greater than the VaR_99
mceshist99=sum(mclossnorm.*mccondloss99)/sum(mccondloss99);% expected shortfall 95%
