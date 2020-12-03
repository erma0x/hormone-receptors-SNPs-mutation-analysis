
 ### Objective
 
 try to identify features in the dataset for predict 
            one feature with binary classification 
            
#### Workflow

 I tried to classify 'cancer_type' over all the other features
 I do not use all the features for the prediction, but a subset.
         
         EXAMPLE
            input_features : ['ref', 'alt','functional_element','cell_line_cancer', 'scoreC']  
            
            output_feature : ['cancer_type'] (0,1) # binary classification



### Products

 ML_1, ML_2 and ML_3 are the same analysis, but ML_1 is for explanation
 instead ML_2 and ML_3 it's for usability and for upgrading, they have little differences.
 ML_2 and ML_3 use pipe to stream the functions process. It's easly upgradable.
 
 The analysis is for the application of a basic Machine Learning Framework, 
 called Keras using Sequential() model to build a Neural Network that can
 predict 1 features using some or all other features given to the model.
 
 Each features must be tranformed into integer or float values, that involve
 the majority of the process. And also not all the features must be use. 
 Less is better for prediction. tha same kind is for the amount of neurons
 in the layers.

 
    target to predict => cancer_type feature [0,1]  
    
    ( prostate = 0 ,  NaN = 1 ) 
    
    NaN is not for Not having a value, but is for 'normal' or non prostate 	

 
### Model 2

 Neural Network MODEL_2 charachteristics (technical issues):
    
    model = Sequential()
    
    activation hidden layer = 'relu'
    activation output layer = 'sigmoid'
    
    model compilation charachteristics
    model.compile(loss='binary_crossentropy',
              optimizer='RMSprop',
              metrics=['accuracy'])
       
 

 number of input features neurons for input layer (that correspond to the number of features used)
 _______________________
 8 neurons   hidden layer
 16 neurons  hidden layer
 32 neurons  hidden layer
 16 neurons  hidden layer
 _______________________
 1 neuron   output layer (for binary classification)

### Model 3
 
 Neural Network MODEL_3 charachteristics (technical issues):

    model = Sequential()
    
    activation hidden layer = 'relu'
    activation output layer = 'sigmoid'
    
    model compilation charachteristics
    model.compile(loss='binary_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])

    
 number of input features neurons for input layer (7)
 ___________________
 16 neurons  hidden layer
 32 neurons  hidden layer
 16 neurons  hidden layer
 ___________________
 1 neuron ouput layer  (for binary classification)
 
 
 
