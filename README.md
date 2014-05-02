#### digit-recognizer
solves "digit recognizer" problem on kaggle (kaggle.com/c/digit-recognizer)

(1) download train.csv from http://www.kaggle.com/c/digit-recognizer/download/train.csv

(2) use in irb as shown below 

*or* 

(2) run run_test(). this function creates two sets from train.csv, training and test, using the options to read_train_csv. it uses training for the classifier which then tries to classify from test. it compares to the known class to produce the test result.currently around 97%-98% benchmark. 

work in progress while I figure out how to make it faster for the real test (28k records will take a while)

##### example
    > load 'digit-recognizer.rb'
    => true

    > # this is really small for the example. set max_read higher (like 20000) for real results
    > training = read_training_vectors(max: 1000, file: '../train.csv')
    => ...

    > test = read_training_vectors(max: 10, start: 1000, file: '../train.csv')
    => ...

    > knnClassifier = KnnClassifier.new(training)
    => ...

    > test[0].classification
    => "1" 

    > knnClassifier.majority_classify(test[0].vector)
    => "1" 

    > test[0].draw
                                
                                
                                
                                
                .%.             
                +*.             
                .*+             
                 **.            
                 *%.            
                 *%+            
                 *%+            
                 *%+            
                 *%+            
                 *%+            
                 *%+            
                 *%+            
                 *%+            
                .*%.            
                .*%.            
                .%%.            
                .*%.            
                .*%+            
                .*%+            
                 +%.            
                                
                                
                                
                                
    => nil 

    > knnClassifier.majority_classify(test[8].vector)
    => "7" 

    > test[8].classification
    => "7" 
    
    > test[8].draw
                                
                                
                                
                                
                                
                                
                                
                 ...+++%.       
         ......++**%***%.       
         +*****%***%*++%.       
         **%***%*+...  %.       
         .+...        .%.       
                     .*%.       
                     +*%.       
                    .**+.       
                   .+%%         
                   .**+         
                   ***.         
                  .%*.          
                 .+%*.          
                 .*%.           
                 +**.           
                .**.            
                +%%             
               .***+.           
               .****.           
               .**+.            
                                
    => nil 

