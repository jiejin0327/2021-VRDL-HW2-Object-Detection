data = load( 'digitStruct.mat').digitStruct
for i = 1:length(data)
    car = data(i)
    carName = car.name;
    im = imread(carName);
    [height, width] = size(im);
    carHeight = height;
    carWidth = width;

    %新建xml文件
    annotation = com.mathworks.xml.XMLUtils.createDocument('annotation');
    annotationRoot = annotation.getDocumentElement;  
    %定義子節点,xml的儲存路径
    folder=annotation.createElement('folder');
    folder.appendChild(annotation.createTextNode(sprintf('%s','.\annotation\BITVehicle_xml')));%这里为xml存放的目录
    annotationRoot.appendChild(folder);
    %图片的名称
    jpgName=annotation.createElement('filename');
    jpgName.appendChild(annotation.createTextNode(sprintf('%s',carName)));
    annotationRoot.appendChild(jpgName);
    %添加图片的size
    jpgSize=annotation.createElement('size');
    annotationRoot.appendChild(jpgSize);
    %定义size的子节点
        %图片宽度
        width=annotation.createElement('width');
        width.appendChild(annotation.createTextNode(sprintf('%i',carWidth)));
        jpgSize.appendChild(width);

        %图片高度
        height=annotation.createElement('height');
        height.appendChild(annotation.createTextNode(sprintf('%i',carHeight)));
        jpgSize.appendChild(height);

        segmented=annotation.createElement('segmented');
        annotationRoot.appendChild(segmented);

        %接下来是每一辆车的标注信息
    for j = 1:length(car.bbox)
        carName = car.name;
        im = imread(carName);
        [height, width] = size(im);

        %標註框的座標  
        aa = max(car.bbox(j).top+1,1);
        bb = min(car.bbox(j).top+car.bbox(j).height, height);
        cc = max(car.bbox(j).left+1,1);
        dd = min(car.bbox(j).left+car.bbox(j).width, width);
        %標註框的類別
        vCategory = car.bbox(j).label

        %将这一辆车的信息注入xml中
        object=annotation.createElement('object');
        annotationRoot.appendChild(object);
        %标注框类别名称
        categoryName=annotation.createElement('name');
        categoryName.appendChild(annotation.createTextNode(sprintf('%d',vCategory)));
        object.appendChild(categoryName);

        pose=annotation.createElement('pose');
        object.appendChild(pose);

        truncated=annotation.createElement('truncated');
        object.appendChild(truncated);

        Difficult=annotation.createElement('difficult');
        object.appendChild(Difficult);

        bndbox=annotation.createElement('bndbox');
        object.appendChild(bndbox);

        xmin=annotation.createElement('xmin');
        xmin.appendChild(annotation.createTextNode(sprintf('%i',cc)));
        bndbox.appendChild(xmin);

        ymin=annotation.createElement('ymin');
        ymin.appendChild(annotation.createTextNode(sprintf('%i',aa)));
        bndbox.appendChild(ymin);

        xmax=annotation.createElement('xmax');
        xmax.appendChild(annotation.createTextNode(sprintf('%i',dd)));
        bndbox.appendChild(xmax);

        ymax=annotation.createElement('ymax');
        ymax.appendChild(annotation.createTextNode(sprintf('%i',bb)));
        bndbox.appendChild(ymax);
    end

savePath=['.\annotation\BITVehicle_xml\',carName(1:end-3),'xml'];
xmlwrite(savePath,annotation); 
end
  
