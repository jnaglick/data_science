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

    > training = read_train_csv({max_read: 1000, file_path: 'train.csv'})
    => ...

    > # note this is really small. set max_read higher (like 20000) for real results
    > test = read_train_csv({max_read: 10, start_read: 1000, file_path: 'train.csv'})
    => ...

    > knnClassifier = KnnClassifier.new(training)
    => ...

    > test[0].classification
    => "1" 

    > knnClassifier.knn_classify(test[0].vector)
    => "1" 

    > print_vector(test[0].vector)
                                
                                
                                
                                
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

    > knnClassifier.knn_classify(test[8].vector)
    => "7" 

    > test[8].classification
    => "7" 
    
    > print_vector(test[8].vector)
                                
                                
                                
                                
                                
                                
                                
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

