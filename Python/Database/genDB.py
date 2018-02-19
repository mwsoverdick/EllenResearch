"""
genDB.py - Generate TFRecord database of images

Mitchell Overdick 02/08/2018
"""

import tensorflow as tf
import numpy as np
import glob
import cv2
from scipy.io import loadmat
from PIL import Image
from random import shuffle
import sys

def load_image(addr,res):
        # read an image and resize to (res, res)
        # cv2 load images as BGR, convert it to RGB
    img = cv2.imread(addr)
    # img = cv2.resize(img, (res, res), interpolation=cv2.INTER_CUBIC)
    # img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img = img.astype(np.float32)
        # Encode image as JPEG to save space
    result, img = cv2.imencode('.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), 100])
    return img

def _int64_feature(value):
    return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))

def _bytes_feature(value):
    return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))


# Directory with sherds to train with, * are wildcards
imageDir = '../../db/Synthesized Sherds/*/Marked/*.jpg'
metaDir = '../../db/Template Sherds/Processed/meta.shrdinf'

shuffle_data = True

# Scale images (percentage)
imscale = 10

# Filename to store tfrecord as
tfrecord_filename = 'db.tfrecords'

# Specimen start letter
spec_begin = 'A'
# Specimen end letter
spec_end ='Z'

# Generate specimen lookup table
label_lookup = map(chr, range(ord(spec_begin), ord(spec_end)+1))

# Load meta.mat to know resolution of images
meta = loadmat(metaDir)

# Load resolution and scale
res = int(float(meta['diag'][0][0])*(float(imscale)/100))

sys.stdout.write('Resolution: '+str(res)+'x'+str(res)+'\n\r')

# Load images addresses to put in db
addrs = glob.glob(imageDir)

# Associate labels
j = 0
labels = range(0,len(addrs))
for addr in addrs[:]:
    for i in range(0,len(label_lookup)):
        labels[j] = i if label_lookup[i] in addr else -1
    j = j+1

# Display how many images are going into DB
sys.stdout.write('Number of images in DB: '+str(len(addrs))+'\n\r');

sys.stdout.write('\n\r')

# Shuffle data
if shuffle_data:
    c = list(zip(addrs, labels))
    shuffle(c)
    addrs, labels = zip(*c)

# Divide the data into 60% train, 20% validation, and 20% test
train_addrs = addrs[0:int(0.6*len(addrs))]
train_labels = labels[0:int(0.6*len(labels))]

val_addrs = addrs[int(0.6*len(addrs)):int(0.8*len(addrs))]
val_labels = labels[int(0.6*len(addrs)):int(0.8*len(addrs))]

test_addrs = addrs[int(0.8*len(addrs)):]
test_labels = labels[int(0.8*len(labels)):]

# open the TFRecords file
writer = tf.python_io.TFRecordWriter(tfrecord_filename)
for i in range(len(train_addrs)):
    # print how many images are saved every 1000 images
    if not i % 1000:
        print 'Train data: {}/{}'.format(i, len(train_addrs))
        sys.stdout.flush()
    # Load the image
    img = load_image(train_addrs[i],res)
    label = train_labels[i]
    # Create a feature
    feature = {'train/label': _int64_feature(label),
               'train/image': _bytes_feature(tf.compat.as_bytes(img.tostring()))}
    # Create an example protocol buffer
    example = tf.train.Example(features=tf.train.Features(feature=feature))

    # Serialize to string and write on the file
    writer.write(example.SerializeToString())

writer.close()
sys.stdout.flush()
