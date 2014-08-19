%modelscan(imageFileNames,model,thresh) apply DPM model inputed on
%each image file in cell array imageFileNames, and returning every 
%ans that above thresh.

function final = modelscan(imageFileNames,model,thresh)    
    n = size(fileNames,1);
    final = {};
    for i = 1 : n
        bbox = test(fullfile('pictures',imageFileNames{i}), model,thresh);
        final = [final;{bbox}];
    end
end

function ret = test(imname, model, thresh)
 im = imread(imname);
 disp(['processing ',imname,' under model ',model.class]);
 bbox = process(im, model, thresh); 
%disp(bbox);
 ret = bbox;
%showboxes(im, bbox);      
%pause;
end