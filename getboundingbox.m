function bbox = getboundingbox(object)
%input:
%    struct of xml annotations
%output:
%bounding box of the annotations,representing left, right,up,down
    bbox = zeros(1,4);
    bbox(2) = min([object.polygon.y]);
    bbox(4) = max([object.polygon.y]);
    bbox(1) = min([object.polygon.x]);
    bbox(3) = max([object.polygon.x]);
end

