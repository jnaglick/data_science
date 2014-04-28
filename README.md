#### digit-recognizer
solves "digit recognizer" problem on kaggle (kaggle.com/c/digit-recognizer)

##### example
    > load 'digit-recognizer.rb'
    => true

    > training = read_train_csv({max_read: 1000, file_path: '../train.csv'})
    => ...

    > # note this is really small. set max_read higher (like 20000) for real results
    > test = read_train_csv({max_read: 10, start_read: 1000, file_path: '../train.csv'})
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

