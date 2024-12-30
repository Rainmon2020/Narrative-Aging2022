%INPUT: 3 variables: all_sex, all_age, ROISignals236, pos_area, neg_area
% node=[228,109,110,52,9,124]
%ROISignals236=FiNum_mean;
ROISignals236=FA_mean;
PMAT_CR=DTI_macro;
all_age=DTI_age;
all_sex=DTI_sex;
node=[198,122,215,88]
thresh=0.05;

[GMV_AGE_R, GVM_AGE_P]=corr(ROISignals,all_age)
GMV_AGE_seed=mean(GMV_AGE_R(node),1)
GMV_AGE_pos=mean(GMV_AGE_R(pos_area),1)
GMV_AGE_neg=mean(GMV_AGE_R(neg_area),1)
%ROISignals=ROISignals236(:,pos_area);
ROISignals=ROISignals236(:,neg_area);

seed=ROISignals236(:,node);
seed_total=sum(seed,2);  

macro_window=find(all_age<62 & all_age>=53);
macro_window_value=all_age(macro_window);
mean_macrowindow_total=mean(macro_window_value);
sub_ROISignals=ROISignals(macro_window,:);
sub_seed=seed_total(macro_window);
sex=all_sex(macro_window,:);

r_total=corr(sub_seed,sub_ROISignals);
pr_total=partialcorr(sub_seed,sub_ROISignals,sex);


for m=54:75
    j=m+1;
    macro_window=find(all_age<=j & all_age>=m);
    macro_window_value=all_age(macro_window);

    mean_macrowindow=mean(macro_window_value);
    mean_macrowindow_total=cat(1,mean_macrowindow_total,mean_macrowindow);
    sub_seed=seed_total(macro_window);
    sub_ROISignals=ROISignals(macro_window,:);
    sex=all_sex(macro_window,:);

    r_total2=corr(sub_seed,sub_ROISignals);
    pr_total2=partialcorr(sub_seed,sub_ROISignals,sex);

    r_total=cat(1,r_total,r_total2);
    pr_total=cat(1,pr_total,pr_total2);%生成n*236的相关矩阵
end


[R,P]=corr(r_total,mean_macrowindow_total);

%第一次permutation，打乱行为编号
no_iterations=5000
no_window=size(mean_macrowindow_total,1);
new_behav = mean_macrowindow_total(randperm(no_window));
[null_total,null_p]=corr(r_total,new_behav);

%接下来的permutation循环，输出零相关矩阵
for it=2:no_iterations
    fprintf('\n Performing iteration %d out of %d', it, no_iterations);
    new_behav = mean_macrowindow_total(randperm(no_window));
    [null_r,null_r_p]=corr(r_total,new_behav);
    null_total=cat(2,null_total,null_r);
end

null_mean=nanmean(null_total,2);
null_std=nanstd(null_total,0,2);

%计算需要的功能连接-行为相关在零分布中的z值
z=(R-null_mean)./null_std;

p_ori=(1-normcdf(abs(z)))*2;
%P_ORI=reshape(p_ori,node,node);
p_ori_label=find(p_ori < thresh);
R_ori=R(p_ori_label);
R_ori_label_pos=find(R_ori>0);
p_ori_label_pos=p_ori_label(R_ori_label_pos);
R_ori_pos=R(p_ori_label_pos);

R_ori_label_neg=find(R_ori<0);
p_ori_label_neg=p_ori_label(R_ori_label_neg);
R_ori_neg=R(p_ori_label_neg);


FDR_p=mafdr(p_ori,'BHFDR',true);
%FDR_P=reshape(FDR_p,node,node);

FDR_label=find(FDR_p < thresh);
FDR_node=neg_area(FDR_label);
% FDR_node=pos_area(R_ori_label_pos);
%FDR_node=pos_area(FDR_label);
FDR_R=R(FDR_label);

