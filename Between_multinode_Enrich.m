%macro_node_degeree:gephi导出的node表格id和degree两列
%macro_edge:导出的edge表格,source和target
source=44;

Ltargetup=68;
Ltargetdown=119;
Rtargetup=198;
Rtargetdown=236;
Ei_net1=Rtargetdown-Rtargetup+Ltargetdown-Ltargetup;
between_net1=find(macro_edge(:,1)==source & macro_edge(:,2)>=Ltargetup & macro_edge(:,2)<=Ltargetdown);
between_net2=find(macro_edge(:,1)==source & macro_edge(:,2)>=Rtargetup & macro_edge(:,2)<=Rtargetdown);
between_net3=find(macro_edge(:,1)<=Ltargetdown & macro_edge(:,1)>=Ltargetup & macro_edge(:,2)==source);
between_net4=find(macro_edge(:,1)<=Rtargetdown & macro_edge(:,1)>=Rtargetup & macro_edge(:,2)==source);

between_net=cat(1,between_net1,between_net2,between_net3,between_net4);
between_net_edge=macro_edge(between_net,:);
between_net_node=between_net_edge(:);
nodeUnique=unique(between_net_node);
macro_node=macro_node_degree(:,1);
[node_net,ia,ib]=intersect(macro_node,nodeUnique,'stable');
macro_degree=macro_node_degree(ia,:);
Ai_total=size(between_net_node,1);
Ai_all=sum(macro_degree(:,2));
Ei_total=Ai_all*Ei_net1/235;

enrich_total = [];
for i = 1:length(net)
    Ltargetup=net(i,1);
    Ltargetdown=net(i,2);
    Rtargetup=net(i,3);
    Rtargetdown=net(i,4);
    Ai_total = [];
    Ei_total = [];
    for j = 1:length(hub)
        source = hub(j)
        Ei_net1=Rtargetdown-Rtargetup+Ltargetdown-Ltargetup;
        between_net1=find(macro_edge(:,1)==source & macro_edge(:,2)>=Ltargetup & macro_edge(:,2)<=Ltargetdown);
        between_net2=find(macro_edge(:,1)==source & macro_edge(:,2)>=Rtargetup & macro_edge(:,2)<=Rtargetdown);
    
        between_net3=find(macro_edge(:,1)<=Ltargetdown & macro_edge(:,1)>=Ltargetup & macro_edge(:,2)==source);
    
        between_net4=find(macro_edge(:,1)<=Rtargetdown & macro_edge(:,1)>=Rtargetup & macro_edge(:,2)==source);
    
        between_net=cat(1,between_net1,between_net2,between_net3,between_net4);
        between_net_edge=macro_edge(between_net,:);
        between_net_node=between_net_edge(:);
        nodeUnique=unique(between_net_node);
        macro_node=macro_node_degree(:,1);
        [node_net,ia,ib]=intersect(macro_node,nodeUnique,'stable');
        macro_degree=macro_node_degree(ia,:);
        Ai=size(between_net_node,1);
        Ai_total=cat(1,Ai_total,Ai);
        Ai_all=sum(macro_degree(:,2));
        Ei=Ai_all*Ei_net1/399;
        Ei_total=cat(1,Ei_total,Ei);
    end
    enrich=nansum(Ai_total)/nansum(Ei_total);
    enrich_total = cat(1,enrich_total,enrich);
end