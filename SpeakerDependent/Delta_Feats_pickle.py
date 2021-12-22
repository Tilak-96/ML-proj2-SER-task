#!/usr/bin/env python
# coding: utf-8

# In[1]:


import glob
import sys
#!pip install numpy==1.21.1
import numpy as np
import _pickle as cPickle


# In[2]:


def get_delta(feat, deltawin=2):
    """ Computes delta using the HTK method.
        Args:
            feat (numpy.ndarray): Numpy matrix of shape WxF, where W is number of frames
                and F is number of features.
            deltawin (int): The DELTAWINDOW parameter of the delta computation.
                Check HTK Book Chapter 5.6 for details.
        Returns:
            numpy.ndarray: A matrix of the same size as argument feat containing the deltas
                of the provided features.
    """

    deltas = []

    norm = 2.0 * (sum(np.arange(1, deltawin + 1) ** 2));
    win_num = feat.shape[0]
    win_len = feat.shape[1]

    for win in range(win_num):
        delta = np.zeros(win_len)
        for t in range(1, deltawin + 1):
            tm = win - t
            tp = win + t
            if tm < 0:
                tm = 0
            if tp >= win_num:
                tp = win_num - 1
                

            delta += (t * (feat[tp] - feat[tm])) / norm

        deltas.append(delta)

    return np.array(deltas)


# In[26]:


def get_list(sav_path, uttr_path, embd_data): 
    with open(sav_path, 'a') as f:
        for i in range (0, embd_data.shape[0]):
            f.write("%s %s %s "%(uttr_path,str(embd_data[i][0]),str(embd_data[i][1])))
            for j in range (2,embd_data.shape[1]):
                f.write("%s " %(embd_data[i][j]))
            f.write("\n")

    f.close()
    return


# In[3]:


path = sys.argv[1]
file_name = path.split('/')[-1]
sav_path = sys.argv[2]+'S_D_DD_'+file_name
f = open(path,"r")
embeddings= f.read()
embed_list = embeddings.split("\n")
del embed_list[-1]
print("Total frames detected: ",len(embed_list))


# In[4]:


data_dict={} 
for i in range (0, len(embed_list)):
    spl= embed_list[i].split(' ')
    file_path = spl[0]
    file_nom= file_path.split('/')[-1]
    file_detail= np.float_(spl[1:])
    try:
        data_dict[file_path].append(file_detail)
    except:
        data_dict[file_path] = [file_detail]
session_file_list = list(data_dict.keys())
print("Total unique frames (i.e total utterances) detected: ",len(session_file_list))


# In[27]:




############ For pickle dump #############
session_embeddings = []
for k in range (0,len(session_file_list)):
    item= session_file_list[k]
    static_data = np.array(data_dict[item])
    static_embd= static_data[:,2:]
    delta_embd = get_delta(static_embd, deltawin=2)
    delta_delta_embd = get_delta(delta_embd, deltawin=2)


    new_embd_matrix = np.zeros((static_data.shape[0],30)) #2(frame No. + label) + 30(features static + delta + delta_delta)
    
    label_mat = static_data[:,1]
    new_embd_matrix[:,0:10]= static_embd
    new_embd_matrix[:,10:20]= delta_embd
    new_embd_matrix[:,20:30]= delta_delta_embd
    ############ For pickle dump #############
    session_embeddings.append((item,label_mat,new_embd_matrix))
 
print("All embeddings created...")
print ("Total utterance embeddings = {} \n".format(len(session_embeddings)))
    
with open(sav_path+".pickle", "wb") as output_file:
            cPickle.dump(session_embeddings, output_file)






