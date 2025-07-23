import tensorflow as tf
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import random
import os
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix

np.seterr(invalid='ignore')

data = pd.read_csv('./msql_tmp3.txt', delimiter='\t')

X = data.drop(['diag'], axis = 1)
y = data['diag']

label_encoder = LabelEncoder()
y = label_encoder.fit_transform(y)

y[:4]

scaler = StandardScaler()
X = scaler.fit_transform(X)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, stratify = y, random_state = 0)

X_train.shape, X_test.shape, y_train.shape, y_test.shape

# Set random seed
tf.random.set_seed(42)

# 1. Create a model
model_1 = tf.keras.Sequential([
           tf.keras.layers.Dense(3, activation='relu'),
           tf.keras.layers.Dense(5, activation='relu'),
           tf.keras.layers.Dense(3, activation='softmax')
])

# 2. Comile the model
model_1.compile(loss=tf.keras.losses.Poisson(),
                 optimizer=tf.keras.optimizers.Adam(learning_rate=0.01),
                 metrics=['accuracy'])

# 3. Fit the model
history = model_1.fit(X_train, 
                      tf.one_hot(y_train, depth=3), 
                      epochs=100,
                      verbose = 1)


#model_1.save("./models1/pairs_cnn1", include_optimizer=True)
