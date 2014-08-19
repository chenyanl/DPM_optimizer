function [bestf1,bestthresh,bprecision,brecall] = getbestthreshold(annotations,name,results,maptable)
%get all results and where they come from
bprecision = 0;
brecall = 0;
BB = [];
ids = [];
for i = 1 : size(results)
    r = results{i};
    BB = [BB;r];
    ids = [ids;ones(size(r,1),1) .* i];
end
ci = size(BB,2);
nd = size(ids,1);
%sort detections by decreasing confidence
[~,si] = sort(-BB(:,ci));
ids = ids(si);
BB = BB(si,:);

%extract ground truth objects
npos = 0;
gt(size(annotations)) = struct('BB',[],'det',[]);
for i = 1 : size(annotations)
    for j = 1 : size(annotations(i).objects)
       obname = annotations(i).objects(j).name;
       
       if (any(strcmp(maptable(:,1),obname)))
            obname = maptable(strcmp(maptable(:,1),obname),2);
       end
       
       if any(strcmp(obname,name))
          gt(i).BB = [gt(i).BB;getboundingbox(annotations(i).objects(j))];
       end
    end 
    gt(i).det = false(size(gt(i).BB,1),1);
    npos = npos + size(gt(i).BB,1);
end
%assign detections to ground truth objects
%meanwhile get the best threshold
tp = zeros(nd,1);
fp = zeros(nd,1);
maxap = -inf;
maxthresh = 0;
for d = 1 : nd;
    i = ids(d);
    bb = BB(d,:);
    ovmax = -inf;
    for j = 1 : size(gt(i).BB,1)
        bbgt = gt(i).BB(j,:);
        bi = [max(bb(1),bbgt(1)); max(bb(2),bbgt(2)); min(bb(3),bbgt(3));min(bb(4),bbgt(4))];
        iw = bi(3) - bi(1) + 1;
        ih = bi(4) - bi(2) + 1;
        if iw>0 & ih>0
            ua = (bb(3)-bb(1)+1)*(bb(4) - bb(2) + 1)+ ...
                (bbgt(3)-bbgt(1)+1) * (bbgt(4) - bbgt(2)+1)-...
                iw*ih;
            ov = iw*ih / ua;
            if ov > ovmax
                ovmax = ov;
                jmax = j;
            end
        end
    end
    
    if ovmax >= 0.5
        if ~gt(i).det(jmax)
            tp(d) = 1;
            gt(i).det(jmax) = true;
        else
            fp(d) = 1;
        end
    else
        fp(d) = 1;
    end
    
    if (d ~= 1)
        fp(d) = fp(d-1) + fp(d);
        tp(d) = tp(d-1) + tp(d);
    end
    
    rec = tp(1:d) / npos;
    prec = tp(1:d)./(fp(1:d)+tp(1:d));
    
    %ap = VOCap(rec,prec);
    f1 = rec(d)*prec(d)*2/(rec(d)+prec(d));
    if f1 >= maxap
        maxap = f1;
        maxthresh = BB(d,ci);
        brecall = rec(d);
        bprecision = prec(d);
    end
end

bestf1 = maxap;
bestthresh = maxthresh;

end
