clc,clear,close all
rng('default');

for run = 1:3
%% Sampling settings
N  = 10000; % Number of subjects
Nt = 7; % Number of waves/time-points per subject

interval = 24; % Follow-up interval in months
interval_std = interval/6;
interval_min = interval/2;
int = interval + interval_std*randn(N,Nt);

small_int_pos = find(int<interval_min);
N_small = length(small_int_pos);
if N_small % Eliminate small intervals
    disp(['Number of small intervals: ',num2str(N_small)]);
    replace_int = interval + interval_std*randn(N_small,1);
    pos = find(replace_int<interval_min);
    while ~isempty(pos)
        replace_int(pos) = interval + interval_std*randn(length(pos),1);
        pos = find(replace_int<interval_min);
    end
    int(small_int_pos) = replace_int;
end

age = 66 + cumsum(int,2); % Age in months
age_min = 60; age_max = 276;
overflow_age_pos = union(find(age(:,1)<age_min),find(age(:,Nt)>age_max));
N_overflow = length(overflow_age_pos);
if N_overflow % Reset samples with out-of-range ages
    disp(['Samples with out-of-range ages: ',num2str(N_overflow)]);
    pos = randsample(setdiff(1:N,overflow_age_pos),N_overflow);
    age(overflow_age_pos,:) = age(pos,:);
end

%% True z-scores for brain phenotypes
z_max = 6;
Z = [1.5 2 2 1 1.5 1.5];
scale1 = z_max./Z;
scale2 = 4*scale1;

load Rc; % wmv,hip,amy,icv,gmv,fct
M = size(Rc,1);
U = chol(Rc);
Uab = chol(Rc+(1-Rc)/3);
a = randn(N,M)*Uab;
b = normcdf(randn(N,M)*Uab.*abs(a*0.7));
y = randn(N,M)*U;
z_big = z_max/2;
big_y_pos = find(abs(y)>z_big);
if ~isempty(big_y_pos)
    y_tmp = y(big_y_pos);
    y_tmp_sign = sign(y_tmp);
    y_tmp = (abs(y_tmp)-z_big)/2;
    pos = find(y_tmp>z_big/2);
    while ~isempty(pos)
        y_tmp(pos) = y_tmp(pos)/2;
        pos = find(y_tmp>z_big/2);
    end
    y(big_y_pos) = y_tmp_sign.*(y_tmp+z_big);
end
S = y./scale1;

age1 = age_min; age2 = age_max+(age_max-age_min)/6; T = age2-age1;
t = 0:T;

% Calculate a
c1 = sqrt((Z+S)./(2*Z));
c2 = sqrt((Z-S)./(2*Z));
x1 = c1*T./(1+c1);
x2 = c2*T./(1+c2);
a_max = (Z+S)./x1.^2;
a_min =-(Z-S)./x2.^2;
a_std = (a_max-a_min)./scale2;
a_m = (a_max+a_min)/2;
a = a.*a_std+a_m; a(a==0) = eps;

% Calculate b
b_max = a; b_min = a;
for m = 1:M
    z = Z(m);
    ap = find(a(:,m)>0); an = find(a(:,m)<0);
    for k = 1:length(ap)
        K = ap(k); s = S(K,m);
        b_max(K,m) = ( z-s-a(K,m)*T^2)/T;
        b_min(K,m) =-sqrt(4*a(K,m)*(s+z));
        if b_min(K,m)/a(K,m)<-2*T
            b_min(K,m) = (-z-s-a(K,m)*T^2)/T;
        end
    end
    for k = 1:length(an)
        K = an(k); s = S(K,m);
        b_min(K,m) = (-z-s-a(K,m)*T^2)/T;
        b_max(K,m) = sqrt(4*a(K,m)*(s-z));
        if b_max(K,m)/a(K,m)<-2*T
            b_max(K,m) = ( z-s-a(K,m)*T^2)/T;
        end
    end
end

tmp = find(b_min>b_max);
if ~isempty(tmp)
    disp([num2str(sum(sum((a<a_min)+(a>a_max)))) ...
        ' times a exceeds the range corresponds to:']);
    disp([num2str(length(tmp)) ...
        ' times b_min is exchanged with b_max.']);
    b_tmp = b_min(tmp);
    b_min(tmp) = b_max(tmp);
    b_max(tmp) = b_tmp;
end
b = b.*(b_max-b_min)+b_min;

% Determining true z-scores for brain phenotypes
brain_z = zeros(N,Nt,M);
sample_std = zeros(length(t),M);
for m = 1:M
    brain_z(:,:,m) = a(:,m).*(age-age1).^2+b(:,m).*(age-age1)+y(:,m);
    sample = a(:,m)*t.^2+b(:,m)*t+y(:,m);
    sample_std(:,m) = std(sample);
%     figure;subplot(1,3,1);
%     plot(t, Z(m)*ones(size(t))); hold on;
%     plot(t,-Z(m)*ones(size(t))); plot((age-age1)',brain_z(:,:,m)');
%     subplot(1,3,2);
%     plot(t, Z(m)*ones(size(t))); hold on;
%     plot(t,-Z(m)*ones(size(t))); plot(t,sample');
%     subplot(1,3,3);
%     plot(t,sample_std(:,m)); hold on;
%     plot(t,mean((sample-y(:,m)).^2));
end

polyn = 4;
p = zeros(polyn+1,M);
for m = 1:M
    p(:,m) = polyfit(t+age1,sample_std(:,m),polyn);
    brain_z(:,:,m) = brain_z(:,:,m)./polyval(p(:,m),age);
%     figure;subplot(1,2,1);
%     plot(t, Z(m)*ones(size(t))); hold on;
%     plot(t,-Z(m)*ones(size(t))); plot((age-age1)',brain_z(:,:,m)');
%     subplot(1,2,2);
%     plot(t,sample_std(:,m)); hold on;
%     plot(t,polyval(p(:,m),t+age1));
end

%% IQ, parental education, autism diagnosis, sex
brain_IQ_var = 0.08;
IQ_var = 0.18;
IQ_z = normalize(sum(brain_z(:,:,[1 4 5]),3))*sqrt(brain_IQ_var) + ...
       brain_z(randperm(N),:,1)*sqrt(IQ_var) + ...
       brain_z(randperm(N),1,6)*sqrt(1-brain_IQ_var-IQ_var);
brain_PE_var = 0.02;
IQ_PE_var = 0.14;
PE_var = 0.26;
PE_z = brain_z(:,:,4)*sqrt(brain_PE_var) + IQ_z*sqrt(IQ_PE_var) + ...
       brain_z(randperm(N),:,1)*sqrt(PE_var) + ...
       brain_z(randperm(N),1,6)*sqrt(1-brain_PE_var-IQ_PE_var-PE_var);
PE = normcdf(normalize(PE_z+mean(PE_z,2)));
par_edu = ones(N,Nt)*3;
par_edu(PE<0.660) = 2;
par_edu(PE<0.407) = 1;
par_edu(PE<0.053) = 0;
change = find(var(par_edu,0,2)>0);
for k = 1:length(change)
    par_edu_tmp = par_edu(change(k),:);
    if sum(abs(sort(par_edu_tmp)-par_edu_tmp))
        par_edu(change(k),:) = round(mean(par_edu_tmp));
    end
end
disp(['Changes in parental education: ',...
    num2str(sum(var(par_edu,0,2)>0))]);

%
d_brain = zeros(N,1); Rc0 = Rc/sum(Rc(:));
[V,D] = eig(Rc0);
[e,ev] = max(diag(D));
v = sqrt(e)*V(:,ev);
shift = sum(sum((v*v'-Rc0).^2));
for k = 1:N
    brain_tmp = brain_z(k,1,:); brain_tmp = brain_tmp(:);
    R_brain = brain_tmp*brain_tmp';
    d_brain(k) = log(sum(sum((R_brain/sum(R_brain(:))-Rc0).^2))-shift);
end
% figure;plot(d_brain);
% figure;histogram(d_brain);

autism_score = normalize(d_brain)*sqrt(2) + sum(brain_z(:,1,[4 5]),3)/4 + ...
    sum(-normalize(a(:,(1:4))),2)/sqrt(8) + abs(IQ_z(:,1)-1) + randn(N,1)*3;
autism_diagnosis = normcdf(normalize(autism_score));
autism_diagnosis(autism_diagnosis<0.97) = 0;
autism_diagnosis = round(autism_diagnosis);

sex = rand(N,1);
autism_pos = find(autism_diagnosis);
sex(autism_pos(sex(autism_pos)<0.8)) = 0;
sex = round(sex);

%% CBCL
% externalizing, internalizing, and attention problems
R_cbcl = [1 -0.3 0.4; -0.3 1 0.2; 0.4 0.2 1];
cbcl = randn(N,3)*chol(R_cbcl)*2;
rp = randperm(N);
cbcl_ext = cbcl(:,1) - 0.9*IQ_z - 0.9*mean(PE,2) + ...
    normalize(autism_score)*0.6 + brain_z(rp,:,5) - sex*2 - ...
    reshape(normalize(age(:)),[N,Nt]);
cbcl_int = cbcl(:,2) - 0.1*IQ_z - 0.4*mean(PE,2) + ...
    normalize(autism_score)*1.2 - brain_z(rp,:,6) + sex*2 - ...
    abs(reshape(normalize(age(:)),[N,Nt])) - sum(brain_z(:,:,[2 3]),3)/3;
cbcl_att = cbcl(:,3) - 0.6*IQ_z - 0.3*mean(PE,2) + ...
    normalize(autism_score)*1.2 + brain_z(rp,:,1) - sex*3;
ICC_cbcl = [0.9 0.88 0.82];
m_cbcl_ext = reshape(normalize(cbcl_ext(:)),[N,Nt])*sqrt(ICC_cbcl(1)) + ...
    randn(N,Nt)*sqrt(1-ICC_cbcl(1));
m_cbcl_int = reshape(normalize(cbcl_int(:)),[N,Nt])*sqrt(ICC_cbcl(2)) + ...
    randn(N,Nt)*sqrt(1-ICC_cbcl(2));
m_cbcl_att = reshape(normalize(cbcl_att(:)),[N,Nt])*sqrt(ICC_cbcl(3)) + ...
    randn(N,Nt)*sqrt(1-ICC_cbcl(3));

alpha = 2; beta = 5;
cbcl_ext_raw = round(betainv(normcdf(m_cbcl_ext),alpha,beta)*70);
cbcl_int_raw = round(betainv(normcdf(m_cbcl_int),alpha,beta)*64);
cbcl_att_raw = round(betainv(normcdf(m_cbcl_att),alpha,beta)*20);
% figure;histogram(cbcl_ext_raw)
% figure;histogram(cbcl_int_raw)
% figure;histogram(cbcl_att_raw)

%% Check
R1 = corr([reshape(brain_z(:,1,:),[N,M]),IQ_z(:,1),par_edu(:,1),...
    autism_score,autism_diagnosis,...
    m_cbcl_ext(:,1),m_cbcl_int(:,1),m_cbcl_att(:,1)]);
R_all = corr([reshape(brain_z,[N*Nt,M]),IQ_z(:),par_edu(:),...
    reshape(autism_score*ones(1,7),[N*Nt,1]),...
    reshape(autism_diagnosis*ones(1,7),[N*Nt,1]),...
    m_cbcl_ext(:),m_cbcl_int(:),m_cbcl_att(:)]);
R_chge = corr([reshape(brain_z-mean(brain_z,2),[N*Nt,M]),...
    reshape(IQ_z-mean(IQ_z,2),[N*Nt,1]),...
    reshape(par_edu-mean(par_edu,2),[N*Nt,1]),...
    reshape(autism_score*ones(1,7),[N*Nt,1]),...
    reshape(autism_diagnosis*ones(1,7),[N*Nt,1]),...
    reshape(m_cbcl_ext-mean(m_cbcl_ext,2),[N*Nt,1]),...
    reshape(m_cbcl_int-mean(m_cbcl_int,2),[N*Nt,1]),...
    reshape(m_cbcl_att-mean(m_cbcl_att,2),[N*Nt,1])]);

%% Raw brain phenotypes
m_brain_z = brain_z;
ICC_brain = [0.98 0.9 0.86 0.99 0.96 0.84]; % wmv,hip,amy,icv,gmv,fct
for m = 1:M
    tmp = (1-ICC_brain(m))*(1+2.^(-(age-20)/40));
    m_brain_z(:,:,m) = brain_z(:,:,m).*sqrt(1-tmp) + randn(N,Nt).*sqrt(tmp);
end

load brain_norm;
brain_raw = brain_z;
for m = 1:M
    tmp = polyval(p(:,m),age);
    brain_raw(:,:,m) = exp(sd(m)*m_brain_z(:,:,m)).*(tmp*(1+fix(m)))-tmp*fix(m);
%     figure; plot(age',reshape(brain_raw(:,:,m),[N,Nt])');
%     brain_z_tmp = brain_z(:,:,m).*sqrt(1-(1-ICC_brain(m))*(1+2.^(-(age-20)/40)));
%     brain_raw_tmp = exp(sd(m)*brain_z_tmp).*(tmp*(1+fix(m)))-tmp*fix(m);
%     figure; plot(age',brain_raw_tmp');
%     tmp = polyval(p(:,m),(age_min:age_max));
%     curves = exp(sd(m)*(-2:2)')*(tmp*(1+fix(m)))-tmp*fix(m);
%     figure; plot((age_min:age_max)',curves');
end

mfr = [1.12 1.07 1.09 1.09 1.09 1];
female_pos = find(sex==1);
for m = 1:M
    brain_raw(female_pos,:,m) = brain_raw(female_pos,:,m)/mfr(m);
end
brain_raw = reshape(brain_raw,[N*Nt,M]);

%% Raw IQ
tmp = (1-0.9)*(1+2.^(-(age-80)/40));
IQ_raw = 100 + round(15*(IQ_z.*sqrt(1-tmp) + randn(N,Nt).*sqrt(tmp)));

%% Site
site_id = round(0.5 + 30*normcdf(normalize(randn(N,1)*2 + sex/2 + ...
    IQ_z(:,1) + PE(:,1))));
% figure;histogram(site_id);

%% Date
START_DATE = '2000-01-01';
END_DATE   = '2001-04-01';
startDateNum = datenum(START_DATE,'yyyy-mm-dd');
endDateNum   = datenum(END_DATE  ,'yyyy-mm-dd');
birthDateNum = round(rand(N,1)*(endDateNum-startDateNum))+startDateNum;
scanDateNum  = birthDateNum + round(age*365.25/12);
BIRTH_DATE = datestr(birthDateNum,'yyyy-mm-dd');
SCAN_DATE  = datestr(scanDateNum ,'yyyy-mm-dd');

%% Write csv
subject_id = (1:N)'*ones(1,Nt);
wave_number = ones(N,1)*(1:Nt);

W = cell2table([num2cell(subject_id(:)) cellstr(repmat('dpn',N*Nt,1)) ...
    num2cell(round(age(:))) num2cell(repmat(sex,Nt,1)) ...
    cellstr(repmat(BIRTH_DATE,Nt,1)) cellstr(SCAN_DATE) ...
    num2cell(wave_number(:)) num2cell(par_edu(:)) ...
    num2cell(repmat(autism_diagnosis,Nt,1)) num2cell(IQ_raw(:)) ...
    num2cell(cbcl_ext_raw(:)) num2cell(cbcl_int_raw(:)) ...
    num2cell(cbcl_att_raw(:)) num2cell(brain_raw(:,5)) ...
    num2cell(brain_raw(:,1)) num2cell(brain_raw(:,2)) ...
    num2cell(brain_raw(:,3)) num2cell(brain_raw(:,6)) num2cell(brain_raw(:,4))]);
W.Properties.VariableNames(1:19) = {'subject_id','site_id','age','sex','dob',...
    'brain_behavior_measurement_date','wave_number','parental_education',...
    'autism_diagnosis','iq','cbcl_externalizing_raw_score',...
    'cbcl_internalizing_raw_score','cbcl_attentionproblem_raw_score',...
    'gm_volume','wm_volume','hippo_volume','amygdala_volume',...
    'frontal_lobe_gm_thickness','icv'};

writetable(W,['dpn_data',num2str(run),'.csv']);

end