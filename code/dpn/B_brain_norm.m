clc,clear,close all

names = readtable('names.csv');
name = table2cell(names(:,1))';
name{4} = 'hip';
name{6} = 'amy';
colnum = table2array(names(:,2))';
%% Normative brain growth
norms = readtable('norms.csv');
[N,~] = size(norms);
m_norms = table2array(norms(1:N/2,colnum  ))*10^4; % Male
u_norms = table2array(norms(1:N/2,colnum+1))*10^4;
d_norms = table2array(norms(1:N/2,colnum+2))*10^4;
m_norms = [m_norms,m_norms(:,4)];
u_norms = [u_norms,u_norms(:,4)];
d_norms = [d_norms,d_norms(:,4)];

ind = [3,4,6,2,5,1];
name = name(ind); % wmv,hip,amy,icv,gmv,fct
m_norms = m_norms(:,ind).*[0.939,0.133,0.0584,1.47,1,1]+[0,0,0,0,0,0.04];
u_norms = u_norms(:,ind).*[0.934,0.134,0.0595,1.46,1,1]+[0,0,0,0,0,0.04];
d_norms = d_norms(:,ind).*[0.945,0.132,0.0573,1.48,1,1]+[0,0,0,0,0,0.04];
X = ((1:N/2)'-500)*80;
m_norms(:,4) = m_norms(:,4)+X;
u_norms(:,4) = u_norms(:,4)+X;
d_norms(:,4) = d_norms(:,4)+X;

age_days = table2array(norms(1:N/2,1));
age = (age_days-280)/365.25*ones(1,length(ind));
age1 = age(1,1); T = age(end,1)-age(1,1); t = (age(:,1)-age1)/T;
age(:,2) = age1 + t.^(0.8)*T; % Adjust the peak of the curve
age(:,3) = age1 + t.^(0.9)*T;

for k = 1:length(ind)
    figure;
    plot(age(:,k),m_norms(:,k));hold on;title(name{k});
    plot(age(:,k),u_norms(:,k));plot(age(:,k),d_norms(:,k)); grid on;
end

%% Male to female ratio
m_mfr = table2array(norms(1:N/2,colnum))./table2array(norms(1+N/2:N,colnum));
u_mfr = table2array(norms(1:N/2,colnum+1))./table2array(norms(1+N/2:N,colnum+1));
d_mfr = table2array(norms(1:N/2,colnum+2))./table2array(norms(1+N/2:N,colnum+2));

mfr = colnum;
for k = 1:length(colnum)
    mfr(k) = mean([m_mfr(:,k);u_mfr(:,k);d_mfr(:,k)]);
    figure;
    plot(age(:,k),m_mfr(:,k));hold on;title(names{k,1});
    plot(age(:,k),u_mfr(:,k));plot(age(:,k),d_mfr(:,k));
end

%% Standard deviation (with noise!)
d_z = norminv(0.75)-norminv(0.25);

fix = (m_norms.^2-u_norms.*d_norms)./((u_norms+d_norms-2*m_norms).*m_norms);
fix_std = std(fix)./mean(fix);
fix = mean(fix);

sd_u = log((u_norms+m_norms.*fix)./(m_norms.*(1+fix)))/d_z*2;
sd_d =-log((d_norms+m_norms.*fix)./(m_norms.*(1+fix)))/d_z*2;

sd = mean([sd_u;sd_d]);
u_norms_fixsd = exp(sd*(d_z/2)).*(m_norms.*(1+fix))-m_norms.*fix;
d_norms_fixsd = (m_norms.*(1+fix))./exp(sd*(d_z/2))-m_norms.*fix;
u_norms1fixsd = exp(sd*1).*(m_norms.*(1+fix))-m_norms.*fix;
d_norms1fixsd = (m_norms.*(1+fix))./exp(sd*1)-m_norms.*fix;
u_norms2fixsd = exp(sd*2).*(m_norms.*(1+fix))-m_norms.*fix;
d_norms2fixsd = (m_norms.*(1+fix))./exp(sd*2)-m_norms.*fix;
age = age*12;
for k = 1:length(ind)
    figure;
    plot(age(:,k),m_norms(:,k));hold on;title(name{k});
    plot(age(:,k),u_norms_fixsd(:,k));plot(age(:,k),d_norms_fixsd(:,k)); grid on;
    plot(age(:,k),u_norms1fixsd(:,k));plot(age(:,k),d_norms1fixsd(:,k));
    plot(age(:,k),u_norms2fixsd(:,k));plot(age(:,k),d_norms2fixsd(:,k));
end

polyn = 4;
p = zeros(polyn+1,length(ind));
for k = 1:length(ind)
    p(:,k) = polyfit(age(:,k),m_norms(:,k),polyn);
    brain_m = polyval(p(:,k),age(:,1));
    brain_u = exp(sd(k)*2)*(brain_m*(1+fix(k)))-brain_m*fix(k);
    brain_d = (brain_m*(1+fix(k)))/exp(sd(k)*2)-brain_m*fix(k);
    figure;
    plot(age(:,1),brain_m);hold on;title(name{k});
    plot(age(:,1),brain_u);plot(age(:,1),brain_d); grid on;
end

save brain_norm p sd fix;