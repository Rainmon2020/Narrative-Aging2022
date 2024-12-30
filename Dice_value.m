
clear dice
I = spm_vol('D:\ConnectomeCodeShen\cognition_glmet\TMTB_hubnode_mask.nii');%读取一张带有对象的RGB图像以进行分割
BW=spm_read_vols(I);
 
X = spm_vol('D:\ConnectomeCodeShen\cognition_glmet\macro_sliceage_pos_mask.nii');%读取一张真实分割了的手的二值图像
BW_groundTruth=spm_read_vols(X);
%计算活动轮廓分割后的图像BW与真实分割图像BW_groundTruth之间的dice相似系数
simi_pos_tmtb= dice(BW, BW_groundTruth);%调用dice函数
disp(simi_pos_tmtb);




I = spm_vol('D:\ConnectomeCodeShen\slice_age\NC_4node\pos_NC_cluster1_mask.nii');%读取一张带有对象的RGB图像以进行分割
BW=spm_read_vols(I);
 
X = spm_vol('D:\ConnectomeCodeShen\slice_age\NC_4node\pos_NC_cluster2_mask.nii');%读取一张真实分割了的手的二值图像
BW_groundTruth=spm_read_vols(X);
%计算活动轮廓分割后的图像BW与真实分割图像BW_groundTruth之间的dice相似系数
simi_pos_cluster12 = dice(BW, BW_groundTruth);%调用dice函数


I = spm_vol('D:\ConnectomeCodeShen\slice_age\NC_4node\neg_NC_cluster1_mask.nii');%读取一张带有对象的RGB图像以进行分割
BW=spm_read_vols(I);
 
X = spm_vol('D:\ConnectomeCodeShen\slice_age\NC_4node\neg_NC_cluster2_mask.nii');%读取一张真实分割了的手的二值图像
BW_groundTruth=spm_read_vols(X);
%计算活动轮廓分割后的图像BW与真实分割图像BW_groundTruth之间的dice相似系数
simi_neg_cluster12 = dice(BW, BW_groundTruth);%调用dice函数