function generatexml(imageFileName,row,col,object)
docNode = com.mathworks.xml.XMLUtils.createDocument('annotation');
annotation = docNode.getDocumentElement;

temp_node = docNode.createElement('filename');
temp_node.appendChild(docNode.createTextNode(imageFileName));
annotation.appendChild(temp_node);

temp_node = docNode.createElement('folder');
temp_node.appendChild(docNode.createTextNode('amt'));
annotation.appendChild(temp_node);

source_node = docNode.createElement('source');
    temp_node = docNode.createElement('sourceImage');
    temp_node.appendChild(docNode.createTextNode('The MIT-CSAIL database of objects and scenes'));
    source_node.appendChild(temp_node);
    
    temp_node = docNode.createElement('sourceAnnotation');
    temp_node.appendChild(docNode.createTextNode('object Annotator voc-release5'));
    source_node.appendChild(temp_node);
annotation.appendChild(source_node);

for i = 1:size(object,2)
    object_node=docNode.createElement('object');
        temp_node = docNode.createElement('name');
        temp_node.appendChild(docNode.createTextNode(object(i).name));
        object_node.appendChild(temp_node);
        
        temp_node = docNode.createElement('deleted');
        temp_node.appendChild(docNode.createTextNode('0'));
        object_node.appendChild(temp_node);
        
        temp_node = docNode.createElement('verified');
        temp_node.appendChild(docNode.createTextNode('0'));
        object_node.appendChild(temp_node);
        
        temp_node = docNode.createElement('date');
        temp_node.appendChild(docNode.createTextNode(datestr(now)));
        object_node.appendChild(temp_node);
        
        temp_node = docNode.createElement('id');
        temp_node.appendChild(docNode.createTextNode(int2str(i-1)));
        object_node.appendChild(temp_node);
        
        polygon_node = docNode.createElement('polygon');
            temp_node = docNode.createElement('username');
            temp_node.appendChild(docNode.createTextNode('CONVERT'));
            polygon_node.appendChild(temp_node);
            
            %top_left
            pt_node = docNode.createElement('pt');
                temp_node = docNode.createElement('x');
                temp_node.appendChild(docNode.createTextNode(int2str(object(i).bbox(1))));
                pt_node.appendChild(temp_node);
                
                temp_node = docNode.createElement('y');
                temp_node.appendChild(docNode.createTextNode(int2str(object(i).bbox(2))));
                pt_node.appendChild(temp_node);
            polygon_node.appendChild(pt_node);
            
            %top_right
            pt_node = docNode.createElement('pt');
                temp_node = docNode.createElement('x');
                temp_node.appendChild(docNode.createTextNode(int2str(object(i).bbox(1))));
                pt_node.appendChild(temp_node);
                
                temp_node = docNode.createElement('y');
                temp_node.appendChild(docNode.createTextNode(int2str(object(i).bbox(4))));
                pt_node.appendChild(temp_node);
            polygon_node.appendChild(pt_node);
            
            %bottom_right
            pt_node = docNode.createElement('pt');
                temp_node = docNode.createElement('x');
                temp_node.appendChild(docNode.createTextNode(int2str(object(i).bbox(3))));
                pt_node.appendChild(temp_node);
                
                temp_node = docNode.createElement('y');
                temp_node.appendChild(docNode.createTextNode(int2str(object(i).bbox(4))));
                pt_node.appendChild(temp_node);
            polygon_node.appendChild(pt_node);
            
            %bottom_left
            pt_node = docNode.createElement('pt');
                temp_node = docNode.createElement('x');
                temp_node.appendChild(docNode.createTextNode(int2str(object(i).bbox(3))));
                pt_node.appendChild(temp_node);
                
                temp_node = docNode.createElement('y');
                temp_node.appendChild(docNode.createTextNode(int2str(object(i).bbox(2))));
                pt_node.appendChild(temp_node);
            polygon_node.appendChild(pt_node);
        object_node.appendChild(polygon_node);
    annotation.appendChild(object_node);
end

size_node = docNode.createElement('imagesize');
    temp_node = docNode.createElement('nrows');
    temp_node.appendChild(docNode.createTextNode(int2str(row)));
    size_node.appendChild(temp_node);
    
    temp_node = docNode.createElement('ncols');
    temp_node.appendChild(docNode.createTextNode(int2str(col)));
    size_node.appendChild(temp_node);
annotation.appendChild(size_node);

filepath = fullfile('xmlannotations',[imageFileName(1:end-4),'.xml'])
xmlwrite(filepath,docNode);
all = textread(filepath,'%c','headerlines',1);
fid = fopen(filepath,'w');
fprintf(fid,'%s',all);
fclose(fid);
%type(filepath);
end

