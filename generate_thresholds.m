function r = generate_thresholds(resultfileNames,objectList,modelNames,replaceList)

%This function of this script is searching the best threshold for each DPM
%model based on F1 measure for each of the models using gold standard 
%annotations(objectlist) and DPM generate results(*_result.mat files).
%The standard of hitting is the same with PASCAL VOC object detection 
%challenge.
%To make sure the object covered by a particular kind of model, a list of 
%words for each of the DPM model(modelname) must be provided.
%For an option, a noun replacement table can be provided, to replace some of
%the nouns in gold-standard annotations.
%input arguments:
%   resultfileNames: the path for each resultfile.
%   objectList: the gold standard annotation calculated by parse_all_XML.m
%   modelName: a n*1 cell array contains the cell array indicating the
%             names for each model.
%   replaceList: a n*2 cell array, the first column indicates the object name in
%                gold standard annotation that need to be replaced and the
%                second column indicates the corrisponding words used in
%                replacement.
%output:
%   there are four coloumns in r, they indicates the best F1, the best
%   threshold to get the F1, the precision and recall at the best F1 respectively.


if nargin < 4
    replaceList = [];
end

r = zeros(size(resultfileNames,1),4);

for i = 1 : size(resultfileNames,1)
   load(resultfileNames{i});
   
%    searchname = fileNames{i};
%    if (any(strcmp(maptable(:,1),searchname)))
%       names = maptable(strcmp(maptable(:,1),searchname),2);
%       names = [names;maptable(strcmp(maptable(:,2),maptable{strcmp(maptable(:,1),searchname),2}),1)];
%    else
%       names = {searchname};
%    end
   names = modelNames{i};
   disp(names);
   [r(i,1),r(i,2),r(i,3),r(i,4)] = getbestthreshold(objectList,names,result,replaceList);
   fprintf('%d/%d\n',i,size(resultfileNames,1));
end

%    save('finalmanualmappingvoc.mat','r');

end