#General Notes
# mapped selection execution to ctrl+enter (file > settings > keymap > execution selection in console > ctrl+enter)

#importing neccessary libraries
import tensorflow as tf
import matplotlib.pyplot as plt

#loading in the mnist handwritten digit dataset
#28x28 images of handwritten digits from (0-9)
mnist = tf.keras.datasets.mnist

#splitting mnist dataset into train and test datasets
(x_train,y_train), (x_test, y_test) = mnist.load_data()

#prints binary output that stores image data, with numbers between 0 and 254 (most numbers are on edge of range)
print(x_train[0])

#prints out image of 1st object in x_train w/ weird color
plt.imshow(x_train[0])
plt.show()
#prints out image of 1st object in x_train w/ binary color scale
plt.imshow(x_train[0], cmap=plt.cm.binary)
plt.show()

#We want to normalize/scale the data
x_train = tf.keras.utils.normalize(x_train, axis=1)
x_test = tf.keras.utils.normalize(x_test, axis=1)

#showing how binary data is normalized after line above is run
print(x_train[0])

#shows how color scale changes after normalizing the binary data, makes image lighter
#look into why this helps-- looks like it is less recognizeable then before?
plt.imshow(x_train[0], cmap=plt.cm.binary)
plt.show()


#starting overall modeling process with a simple feed forward neural network
model = tf.keras.models.Sequential()

#for simpler models, we want to image to be flattened, not 28x28 (for CNNs this is not true)
#you can use numpy to do this, or just use built in functionality of keras
model.add(tf.keras.layers.Flatten())

#going with 2 hidden layers with 128 neurons each
# using "relu" activation function, which is typically the default for simpler models
model.add(tf.keras.layers.Dense(128, activation=tf.nn.relu))
model.add(tf.keras.layers.Dense(128, activation=tf.nn.relu))

# Add 1 output layer with 10 nuerons (for 10 possible digits), using a softmax activation function (b/c this is a probability distribution problem)
model.add(tf.keras.layers.Dense(10, activation=tf.nn.softmax))

#need to define parameters for training of the model
#NNets don't optimize for accuracy, they minimize for loss
#using "adam" optimizer, is the default optimizer
#using "sparse_categorical_crossentropy" for loss, could use binary if it cats vs dogs
model.compile(optimizer='adam', loss=tf.keras.losses.sparse_categorical_crossentropy, metrics=['accuracy'])

#training the model using 3 epochs
model.fit(x_train, y_train, epochs=3)


#calculating loss and accuracy rates and outputing them in print statement
val_loss, val_accuracy = model.evaluate(x_test, y_test)
print("The NNet has a loss rate of " + str(round(val_loss*100, 2)) + "%"
      + "\n" + " while having an accuracy of " + str(round(val_accuracy*100, 2)) + "%")

#saving model
model.save('epic_digit_reader')

#loading in saved model
new_model = tf.keras.models.load_model('epic_digit_reader')

#creating list of predictions on x_test
#predict function ALWAYS takes a list, i.e. pass in [x_test] not just x_test
predictions = new_model.predict([x_test])

#printing predictions looks like this because it stores the probability distribution of it being equal to each factor level present in the data
print(predictions)

#looking at granular prediction using numpy
import numpy as np
print(np.argmax(predictions[0])) #outputs a 7

#comparing prediction of 7 to image of x_test[0]
plt.imshow(x_test[0], cmap=plt.cm.binary)
plt.show()
