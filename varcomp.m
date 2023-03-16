%%%%%%%VaR computation apple
Price=xlsread('D:\mth 800\Brent Oil Futures Historical Data.csv','B2:B1569');
m=length(Price);% apl is the vector of prices captured from the corresponding column in the apple file
aplrev=zeros(1, length(Price));
%t = datetime(2012,12,15) + caldays(1 :m);(not in use)
%%%%%%Reverting the order in the vector of prices
for j=1:m
    aplrev(j)=Price(m-j+1);
end
plot(aplrev)
logretapl=log(aplrev(2:m)./aplrev(1:m-1));%log of returns, one observation is lost
V=10^6; %initial value of the portfolio
%loss1=-V*(exp(logretapl)-1);%losses
loss2=-V*logretapl;%approximation based on Taylor expnasion
varhist2=quantile(loss2, [0.95 0.99]);%computing historic VaR
mu=mean(logretapl); %estimating mean of logreturns
sigma=std(logretapl); %estimating standard dev. of logreturns
varnorm95=-V*mu+V*sigma*icdf('Normal',0.95,0,1); %normal var alpha=95%
varnorm99=-V*mu+V*sigma*icdf('Normal',0.99,0,1); %normal var alpha=95%
%%%%%%%%%%%%%%%%%%%% Riskmetrics VaR
lambda=0.94;
indi=1:m-1;
coeffrm=(1-lambda).*lambda.^(m-1-indi);%riskmetric weights
murm=coeffrm*logretapl';%estimating mean by riskmetric 
sigmarm=sqrt(coeffrm*((logretapl-murm).^2)');%estimating standard deviation by riskmetric 
varnormrm95=-V*murm+V*sigmarm*icdf('normal',0.95,0,1);%VaR riskmetric 95%
varnormrm99=-V*murm+V*sigmarm*icdf('normal',0.99,0,1);%VaR riskmetric 99%
%%%%%%%%%%%%%%%%%%%%%Monte Carlo VaR
ns=10^6;% number of simulatioms
mclossnorm=normrnd(-V*mu, V*sigma, 1,ns);%generating ns losses
varmcnorm=quantile(mclossnorm, [0.95 0.99]);




