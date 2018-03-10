import numpy as np
import tensorflow as tf
import glob
import sys

tf.logging.set_verbosity(tf.logging.INFO)

train_data_path = '../Database/train_db.tfrecords'
test_data_path = '../Database/test_db.tfrecords'
val_data_path = '../Database/val_db.tfrecords'

def loadDataSet(fname, stype):
    stype_img   = stype + '/image'
    stype_label = stype + '/label'

    feature = {stype_img: tf.FixedLenFeature([], tf.string),
               stype_label: tf.FixedLenFeature([], tf.int64)}

    # Create a list of filenames and pass it to a queue
    filename_queue = tf.train.string_input_producer([fname], num_epochs=1)

    # Define a reader and read the next record
    reader = tf.TFRecordReader()
    _, serialized_example = reader.read(filename_queue)

    # Decode the record read by the reader
    features = tf.parse_single_example(serialized_example, features=feature)

    # Convert the image data from string back to the numbers
    image = tf.decode_raw(features[stype_img], tf.float32)

    # Cast label data into int32
    label = tf.cast(features[stype_label], tf.int32)

    # Reshape image data into the original shape
    image = tf.reshape(image, [224, 224, 3])

    # Remove image compression

    # Creates batches by randomly shuffling tensors
    images, labels = tf.train.shuffle_batch([image, label], batch_size=10, capacity=300000, num_threads=1, min_after_dequeue=10)

    return {'images':images, 'labels':labels}

def main(unused_argv):
        # Load data
    trainData = loadDataSet(train_data_path, 'train')
    testData  = loadDataSet(test_data_path, 'test')

        # Load training set
    train_data = trainData['images']
    train_labels = trainData['labels']

    sys.stdout.write('Path: ' + str(trainData))
    sys.stdout.write('\n\r')

        # Load testing set
    test_data = testData['images']
    test_labels = testData['labels']

if __name__ == "__main__":
  tf.app.run()
