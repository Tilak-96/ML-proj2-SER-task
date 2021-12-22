# ML-proj2-SER-task
## If you are happy and you know it, your speech will surely show it: A CNN based speech emotion detector 
Here we provide the best performing setup reported in our draft, the speaker dependent training setup.

(A) We have provided the training logs in the folder "trainingLogs" 

(B) All the trained models corrosponding to 5 folds are present in the folder named "exp"

================================================================================

The steps to generate the results for the CNN based systems are as following:

1. Download the IEMOCAP database.

2. Use "IEMOCAP_SpeakerDependent_Kfold_creation.ipynb", the code will create 5-folds where, each fold will contain a train.list, cv.list and test.list containing the path of the .wav files and their cossesponding emotion label. We have provided this folder named "list".

3. Now we need to run the raw-cnn pipeline all the codes are provided in the folder named "rawCNN_Pipeline" and to utilize the pipeline use the script "run_Cnn.sh". In run_Cnn.sh provide the following details:
      
      a) Path of the train.list, test.list, cv.list created in step 1
      
      b) Path where you need to dump the extracted features in a format which you be passed to the CNN framework
      
      c) the path where you need your model to be saved, we did it in the folder named "exp" which is provided here. In the same directory (exp) it will create            the score report "score.txt" for the test.list, with the format location_of_file<space>true_label<space>softmax_posterior_distribution

4. Use step 3 to generate models for all five folds.

5. After the training is complete to evaluate the results use "IEMOCAP-SD_ResultAnalysis.ipynb"

      
The steps to generate the results for the neural embedding based systems are as following:
  
1. Use the "Embedding_Generator.ipynb" code to generate the raw frame-level embeddings, it create the embedding pickle file for all the data samples. In the "Embedding_Generator.ipynb" set the path for the trained model present in folder /exp 

2. For generating frame-level delta embeddings run "Get_Delta_script.sh", this script uses the code "Delta_Feats_pickle.py"
  
3. Finally, use "Functionals_Delta-SVM.ipynb" to generate the classification results for static and delta embeddings. the code generate "score.txt" for these experiments.

  ================================================================================
  
 (A) All the model training were done at the idiap's grid systems. 
 
 (B) Idiap hold the licence to use IEMOCAP database for academic/research purposes.
  

 
