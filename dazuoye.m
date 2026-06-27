% 读取图像
img = imread('yingbi.png');
if size(img, 3) == 3,grayImg = rgb2gray(img);end % 灰度化处理
% 图像二值化
threshold = graythresh(grayImg); % Otsu自适应阈值
bwImg = ~imbinarize(grayImg, threshold);
% 形态学处理
se = strel('disk', 45); % 定义结构元素（圆盘形，半径45像素）
bwImg = imclose(bwImg, se); % 闭运算：填充孔洞
se = strel('disk', 20); % 定义结构元素（圆盘形，半径20像素）
bwImg = imopen(bwImg, se); %开运算：去除小噪声
bwImg = bwareaopen(bwImg, 30); % 去除面积过小的连通域（噪声）
% 连通域分析
[labelImg, numObjects] = bwlabel(bwImg, 8); % 连通域标记（8邻域）
stats = regionprops(labelImg, 'Area', 'Centroid', 'BoundingBox'); % 获取连通域属性
% 目标框选标注与坐标输出 
imshow(img);% 显示原图
hold on;
% 提取坐标
coordinates = zeros(numObjects, 2);% 初始化坐标存储
for i = 1:numObjects
    bbox = stats(i).BoundingBox;% 获取外接矩形
    rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2); % 绘制红色矩形框
    centroid = stats(i).Centroid; % 获取质心坐标
    coordinates(i, :) = centroid;
    text(centroid(1)-10, centroid(2)-10, num2str(i), ...
         'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold');% 在质心附近标注编号
end
hold off;
% 可视化标注
fprintf('检测到目标总数：%d\n', numObjects);
fprintf('各目标质心坐标：\n');
for i = 1:numObjects
    fprintf('目标 %d: (%.2f, %.2f)\n', i, coordinates(i,1), coordinates(i,2));
end