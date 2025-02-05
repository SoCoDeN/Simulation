clc,clear,close all

ABCD = readtable('DAT_QC.csv');
age = table2array(ABCD(:,15))';
% sex = table2array(ABCD(:,9))'; % 1=Male 2=Female
% M_age = age(sex==1);
% F_age = age(sex==2);
% figure;histogram(M_age);
% figure;histogram(F_age);
% 108 ~ 132
age_pos = find(age<134&age>107); % Data from the most heavily sampled age range
%% Male to female ratio
ABCD_mfr = ABCD(age_pos,:);
% age = table2array(ABCD_mfr(:,15))';
sex = table2array(ABCD_mfr(:,9))'; % 1=Male 2=Female
% M_age = age(sex==1);
% F_age = age(sex==2);
% disp(mean(M_age));
% disp(mean(F_age));

M = table2array(ABCD_mfr(sex==1,3:8));
F = table2array(ABCD_mfr(sex==2,3:8));
mfr = mean(M)./mean(F);
%% Correlation matrix of brain phenotypes
MF = [M;F.*mfr];
m = quantile(MF,0.5);

corrMF = corr(MF);
[R,P,RL,RU] = corrcoef(MF,'Alpha',0.001);
sum(abs(R(:)))
sum(abs(RL(:)))
sum(abs(RU(:)))

RL(abs(RL)<=abs(RU))=0;
RU(abs(RL)> abs(RU))=0;
Rc = RU+RL;
sum(abs(Rc(:)))
disp(eig(Rc));
%% 
N = 10000;
M = size(Rc,1);
U = chol(Rc);
Z = randn(N,M)*U;
RZ = corr(Z);

save Rc Rc;