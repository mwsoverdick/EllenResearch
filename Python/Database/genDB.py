"""
genDB.py - Generate TFRecord database of images

Based on Naveen Honest Raj - www.skcript.com
Mitchell Overdick 02/08/2018
"""

import tensorflow as tf

import numpy as np

import glob

from scipy.io import loadmat

from PIL import Image

import sys

# Converting the values into features
# _int64 is used for numeric values

def _int64_feature(value):
    return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))

# _bytes is used for string/char values

def _bytes_feature(value):
    return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))

# Directory with sherds to train with, * are wildcards
imageDir = '../../db/Synthesized Sherds/*/Marked/*.jpg'
metaDir = '../../db/Template Sherds/Processed/meta.shrdinf'

tfrecord_filename = 'db.tfrecords'

# Specimen start letter
spec_begin = 'A'
# Specimen end letter
spec_end ='Z'

# Generate specimen lookup table
specs = map(chr, range(ord(spec_begin), ord(spec_end)+1))

# Load meta.mat to know resolution of images
meta = loadmat(metaDir)

res = meta['diag']

sys.stdout.write(str(res)

# Initiating the writer and creating the tfrecords file.

writer = tf.python_io.TFRecordWriter(tfrecord_filename)

# Loading the location of all files - image dataset
# Considering our image dataset has apple or orange
# The images are named as apple01.jpg, apple02.jpg .. , orange01.jpg .. etc.
images = glob.glob(imageDir)

for image in images[:]:
    img = Image.open(image)
    # sys.stdout.write("image:" + str(image) + "\n\r")
    img = np.array(img.resize((res,res)))

    for i in range(0, len(specs)):
        label = i if specs[i] in image else -1


    feature = { 'label': _int64_feature(label), 'image': _bytes_feature(img.tostring()) }

        # Create an example protocol buffer
    example = tf.train.Example(features=tf.train.Features(feature=feature))

        # Writing the serialized example.
    writer.write(example.SerializeToString())

writer.close()
