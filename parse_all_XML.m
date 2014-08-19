%This script parses all LableMe XML annotation and return them in a structure.
%The structure includes fileName, indicating fileName
%and a matrix of object structure, this structure indicates the name and
%position in images.
function objectlist = parse_all_XML(directory)
if nargin < 1
    directory = pwd;
end

fileFolder = fullfile(directory);
dirOutput = dir(fullfile(fileFolder,'*.xml'));
fileNames = {dirOutput.name}';
fileNames = char(fileNames);

objectlist = [];
for i = 1 : size(fileNames,1)
    disp(['processing ',fileNames(i,:)]);
    xDoc = parseXML(fileNames(i,:));
    object = [];
    for j = 1 : size(xDoc.Children,2)
        if (strcmp(xDoc.Children(j).Name,'object'))
            polygon = [];
            p = xDoc.Children(j).Children(6).Children;
            for k = 2 : size(p,2)
                polygon = [polygon;struct('x',str2double(p(k).Children(1).Children.Data(:)),...
                                          'y',str2double(p(k).Children(2).Children.Data(:)))];
            end
            object = [object;struct('name',xDoc.Children(j).Children(1).Children.Data,...
                                    'polygon',polygon)];
        end
    end
    objectlist = [objectlist;struct('filename',xDoc.Children(1).Children.Data,...
                              'objects',object)];
end
end
