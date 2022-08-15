# object_detection

SVHN Dataset object detection

The proposed challenge is a street view house numbers detection, which contains two parts:

1. Do bounding box regression to find top, left, width and height of bounding boxes which contain digits in a given image
classify the digits of bounding boxes into 10 classes (0-9)
2. The giving SVHN dataset contains 33402 images for training and 13068 images for testing. This project uses the YOLOv5 pre-trained model to fix this challenge.

YOLOv5
The project is implemented based on yolov5.
reference code from [yolov5 official github](https://github.com/ultralytics/yolov5)
