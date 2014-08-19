function get_all_result(modelFileNames,imageFileNames)
%This function takes two 1*n cell arrays as input, indicating
%all the models' file name and all images.
%The function runs each DPM model on each of the images, to generate
%all possible detections. And save the result for each model, for 
%further processing.


% fileFolder = fullfile(pwd,'imagenet');
% dirOutput = dir(fullfile(fileFolder,'*.mat'));
% fileNames = {dirOutput.name}';
% fileNames = char(fileNames);
% fileNames = fileNames(:,1:9);
% fileNames = unique(fileNames,'rows');

models = {};
for i = 1 : size(modelFileNames)
%     if exist(fullfile('imagenet',[fileNames(i,:),'_final.mat']),'file') == 2
    load(modelFileNames{i});
    models = [models;model];
%     end
end

for i = 1 : size(models,1)
    result = modelscan(imageFileNames,models{i},-7);
    save([models{i}.class,'_result.mat'],'result');
end

end