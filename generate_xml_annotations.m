function generate_xml_annotations(resultfileNames,imagepath,objectlist,names,r,threshold)
%this program combines results of multiple DPM models to generate the LableMe
%XML representation for each image that has a gold-standard annotation.
%input arguments:
%     resultfileNames: a n*1 cell array containing the path of the results 
%                      for each DPM models.
%     imagepath: the path to image directory
%     objectlist: the output of parse_all_XML.m, the file name of each
%                 picture is used here.
%     names: a n*1 cell array indicating name of detected objects in each 
%            DPM model.
%     r: the output of generate_thresholds.m
%     threshold: only the result of the DPM models which have a higer F1
%                measure than this number would appear in generated XML 
%                annotations.
%the result will be saved in xmlannotations/ directory.

nimage = size(objectlist,1);
temp = cell(nimage,1);
for i = 1 : nimage
    temp{i} = [];
end

n = size(resultfileNames,1);
for i = 1 : n %object
    if r(i,1)>threshold
        load(resultfileNames{i});
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
    generatexml(objectlist(i).filename,s(1),s(2),temp{i});
end

