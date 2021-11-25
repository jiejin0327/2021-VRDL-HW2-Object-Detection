"""
YOLO 格式的数据集转化为 COCO 格式的数据集
--root_dir 输入根路径
--save_path 保存文件的名字(没有random_split时使用)
--random_split 有则会随机划分数据集，然后再分别保存为3个文件。
--split_by_file 按照 ./train.txt ./val.txt ./test.txt 来对数据集进行划分。
"""

import os
import cv2
import json
from tqdm import tqdm
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--root_dir', default='yolo/yolov5-master/runs/detect/exp/labels',type=str, help="root path of images and labels, include ./images and ./labels and classes.txt")
parser.add_argument('--save_path', type=str,default='yolo/yolov5-master/runs/detect/exp', help="if not split the dataset, give a path to a json file")

arg = parser.parse_args()

def yolo2coco(arg):
    root_path = arg.root_dir
    save_path = arg.save_path
    print("Loading data from ",root_path)

    img_path = 'yolo/yolov5-master/data/test'
    assert os.path.exists(root_path)
    originLabelsDir = os.path.join(root_path)                                        
    originImagesDir = os.path.join(img_path)

    # label dir name
    indexes = os.listdir(originLabelsDir)
    indexes.sort(key = lambda x: int(x[:-4]))

    result_to_json = []
    
    # 标注的id
    ann_id_cnt = 0
    for k, index in enumerate(tqdm(indexes)):
        # 支持 png jpg 格式的图片。
        txtFile = index.replace('images','txt').replace('.jpg','.txt').replace('.png','.txt')
        index = index.split(".")[0]
        # 读取图像的宽和高
        im = cv2.imread(os.path.join(img_path, (index +'.png')))
        height, width, _ = im.shape

        if not os.path.exists(os.path.join(originLabelsDir, txtFile)):
            # 如没标签，跳过，只保留图片信息。
            continue

        with open(os.path.join(originLabelsDir, (index +'.txt')), 'r') as fr:
            labelList = fr.readlines()
            for label in labelList:
                dataset = {}
                label = label.strip().split()
                x = float(label[1])
                y = float(label[2])
                w = float(label[3])
                h = float(label[4])
                score = float(label[5])

                # convert x,y,w,h to x1,y1,x2,y2
                H, W, _ = im.shape
                x1 = (x - w / 2) * W
                y1 = (y - h / 2) * H
                x2 = (x + w / 2) * W
                y2 = (y + h / 2) * H

                # convert cls (10 represent 0)
                cls_id = int(label[0]) +1
                if cls_id == 10:
                    cls_id = 0


                width = max(0, x2 - x1)
                height = max(0, y2 - y1)

                dataset["image_id"] = int(index)
                dataset["score"] = score
                dataset["category_id"] = cls_id
                dataset["bbox"] = [x1, y1, width, height]
                
                result_to_json.append(dataset)

                ann_id_cnt += 1

    # 保存结果
    folder = os.path.join(save_path, 'annotations')
    if not os.path.exists(folder):
        os.makedirs(folder)

    json_name = os.path.join('{}/annotations/{}'.format(arg.save_path,'answer.json'))
    with open(json_name, 'w') as f:
        json.dump(result_to_json, f, indent=4)
        print('Save annotation to {}'.format(json_name))

if __name__ == "__main__":

    yolo2coco(arg)