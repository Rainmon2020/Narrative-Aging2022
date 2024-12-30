%INPUT: 3 variables: all_age, PMAT_CR, rest_4_mats

all_mats=rest_4_mats;
PMAT_CR=micro
age_window=find(all_age<62 & all_age>=53);
age_window_value=all_age(age_window);
mean_agewindow_total=mean(age_window_value);
age_behav=PMAT_CR(age_window);
rest_macro_node=all_mats(1:236,[149,43,162,25],age_window);
no_node=size(rest_macro_node,2);

macro_node_vcts=reshape(rest_macro_node,[],size(age_window,1));
[r_mat_total, p_mat_total] = corr(macro_node_vcts', age_behav);

for i=54:75
        j=i+9;
        age_window=find(all_age<j & all_age>=i);
        age_window_value=all_age(age_window);
        mean_agewindow=mean(age_window_value);
        mean_agewindow_total=cat(1,mean_agewindow_total,mean_agewindow);
        age_behav=PMAT_CR(age_window);
        rest_macro_node=all_mats(1:236,[149,43,162,25],age_window);
        no_node=size(rest_macro_node,2);

        macro_node_vcts=reshape(rest_macro_node,[],size(age_window,1));
        [r_mat, p_mat] = corr(macro_node_vcts', age_behav);
         
         r_mat_total=cat(2,r_mat_total,r_mat);
end

[R_mat, P_mat] = corr(r_mat_total', mean_agewindow_total);
R_mat=reshape(R_mat,size(rest_macro_node,1),no_node);
R_mat_mean=nanmean(R_mat,2);

no_iterations=5000
no_window=size(mean_agewindow_total,1);
new_behav = mean_agewindow_total(randperm(no_window));
[null_total,null_p]=corr(r_mat_total',new_behav);
null_total=reshape(null_total,size(rest_macro_node,1),no_node);
null_total_mean=nanmean(null_total,2);
%接下来的permutation循环，输出零相关矩阵
for it=2:no_iterations
    fprintf('\n Performing iteration %d out of %d', it, no_iterations);
    new_behav = mean_agewindow_total(randperm(no_window));
    [null_r,null_r_p]=corr(r_mat_total',new_behav);
    null_r=reshape(null_r,size(rest_macro_node,1),no_node);
    null_r_mean=nanmean(null_r,2);
    null_total_mean=cat(2,null_total_mean,null_r_mean);
    %[prediction_r(it,1), prediction_r(it,2)] = predict_behavior(all_mats, new_behav);    
end
null_mean=nanmean(null_total_mean,2);
null_std=nanstd(null_total_mean,0,2);
z=(R_mat_mean-null_mean)./null_std;

z_p=(1-normcdf(abs(z)))*2;

z_FDR=mafdr(z_p,'BHFDR',true);

z_FDR_label=find(z_FDR < 0.05);
z_R_FDR=R_mat_mean(z_FDR_label,:);
scn_node=z_FDR_label;
scn_value=z_R_FDR;


