%%%%%%%VaR computation WTI t-student distribution
wtiprices=zeros(1, length(Price));%Price is the series of prices of a given asset
m=length(wtiprices);% apl is the vector of prices captured from the corresponding column in the apple file
%%%%%%Reverting the order in the vector of prices
for j=1:m
    wtiprices(j)=Price(m-j+1);
end
logretwtiprices=log(wtiprices(2:m)./wtiprices(1:m-1));%log of returns, one observation is lost
V=10^6; %initial value of the portfolio
nu=4; %degrees of freedom
loss2=-V*logretwtiprices;%approximation based on Taylor expansion
mu=mean(logretwtiprices); %estimating mean of logreturns
sigmax=std(logretwtiprices); %estimating standard dev. of logreturns
varstud95=-V*mu+V*sigmax*sqrt((nu-2)/nu)*icdf('T',0.95,nu); %student var alpha=95%
varstud99=-V*mu+V*sigmax*sqrt((nu-2)/nu)*icdf('T',0.99,nu); % student var alpha=95%
%%%%%%%%%%%%%%%%%%%%%Monte Carlo VaR
ns=10^6;% number of simulatioms
mclossstud=-V*mu+V*sigmax*sqrt((nu-2)/nu)*random('T',4,1,ns);%generating ns losses
varmstud=quantile(mclossstud, [0.95 0.99]);
