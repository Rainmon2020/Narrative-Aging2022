%INPUT: node = the seed 
node=[]
thresh=0.05;

seed=ROISignals(:,node);
seed_total=sum(seed,2);
[R,P]=corr(ROISignals,ROISignals);
[PR,PP]=partialcorr(seed_total,ROISignals,all_age);

%permutation
no_iterations=10000
no_window=size(seed_total,1);
new_behav = seed_total(randperm(no_window));
[null_total,null_p]=corr(ROISignals,new_behav);


for it=2:no_iterations
    fprintf('\n Performing iteration %d out of %d', it, no_iterations);
    new_behav = seed_total(randperm(no_window));
    [null_r,null_r_p]=corr(ROISignals,new_behav);
    null_total=cat(2,null_total,null_r);
    %null_total_mean=cat(2,null_total_mean,null_r_mean);
    %[prediction_r(it,1), prediction_r(it,2)] = predict_behavior(all_mats, new_behav);    
end

null_mean=nanmean(null_total,2);
null_std=nanstd(null_total,0,2);

%计算需要的功能连接-行为相关在零分布中的z值
z=(R'-null_mean)./null_std;
pz=(PR'-null_mean)./null_std;

p_ori=(1-normcdf(abs(z)))*2;
pp_ori=(1-normcdf(abs(pz)))*2;
%P_ORI=reshape(p_ori,node,node);
p_ori_label=find(p_ori < thresh);
[p_ori_row,p_ori_col]=find(p_ori < thresh);
R_ori=R(p_ori_label);

pp_ori_label=find(pp_ori < thresh);
[pp_ori_row,pp_ori_col]=find(pp_ori < thresh);
PR_ori=PR(pp_ori_label);

FDR_p=mafdr(p_ori,'BHFDR',true);
FDR_pp=mafdr(pp_ori,'BHFDR',true);
%FDR_P=reshape(FDR_p,node,node);

FDR_label=find(FDR_p < thresh);
[FDR_row,FDR_col]=find(FDR_p < thresh);

FDR_plabel=find(FDR_pp < thresh);
[FDR_prow,FDR_pcol]=find(FDR_pp < thresh);

