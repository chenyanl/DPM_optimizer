function r = generate_thresholds(fileNames,objectlist,modelname,nounreplacetable)
%This function of this script is searching the best threshold based on F1 
%measure for each of the models using gold standard annotations(objectlist)
%and DPM generate results(*_result.mat files)
%The standard of hitting is the same with PASCAL VOC object detection 
%challenge.
%To make sure the object covered by a particular kind of model, a list of 
%words for each of the DPM model(modelname) must be provided.
%For an option, a noun replacement table can be provided, to replace some of
%the nouns in gold-standard annotations.
if nargin < 4
    nounreplacetable = [];
end

r = zeros(size(fileNames,1),4);

for i = 1 : size(fileNames,1)
   load(fileNames{i});
   
%    searchname = fileNames{i};
%    if (any(strcmp(maptable(:,1),searchname)))
%       names = maptable(strcmp(maptable(:,1),searchname),2);
%       names = [names;maptable(strcmp(maptable(:,2),maptable{strcmp(maptable(:,1),searchname),2}),1)];
%    else
%       names = {searchname};
%    end
   names = modelname{i};
   disp(names);
   [r(i,1),r(i,2),r(i,3),r(i,4)] = getbestthreshold(objectlist,names,result,nounreplacetable);
   fprintf('%d/%d\n',i,size(fileNames,1));
end

%    save('finalmanualmappingvoc.mat','r');

end