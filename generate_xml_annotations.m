function generate_xml_annotations(fileNames,imagepath,objectlist,names,r)
%this program uses the results for different models to generate the LableMe
%XML representation of the results for different model thresholds.
%furthermore, you need to indicate the names used for each object.

threshold = 0.01;
nimage = size(objectlist,1);
temp = cell(nimage,1);
for i = 1 : nimage
    temp{i} = [];
end

n = size(fileNames,1);
for i = 1 : n %object
    if r(i,1)>threshold
        load(fileNames{i});
        for j = 1 : nimage %image
            alldetection = result{j};
            bboxes = alldetection(alldetection(:,end) > r(i,2),1:4);
            for k = 1 : size(bboxes,1) %instance
                tt = struct('name',names{i},'bbox',bboxes(k,:));
                temp{j} = [temp{j},tt];
            end
        end
    end
end
     
for i = 1 : nimage %object
    image = imread([imagepath,objectlist(i).filename]);
    s = size(image);
    generatexmlobjectlist(i).filename,s(1),s(2),temp{i});
end

