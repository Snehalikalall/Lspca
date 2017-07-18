import numpy
import scipy
from sklearn.neighbors import LSHForest
numpy.set_printoptions(threshold=numpy.nan)
from numpy import genfromtxt
from scipy import io, sparse
import scipy.stats
from multiprocessing import Pool
from sklearn.decomposition import PCA
import random
import sys
# Take the user Input for number of iterations in LSH
itr = int(sys.argv[1])
# Take the processed data input from machine
X = genfromtxt('PreProcesseddata.csv',delimiter=",")   
print "Read Complete."

# Define Input for parallel jobs running in a batch
def chunk(a, n):
    k, m = divmod(len(a), n)
    return list(tuple(a[i * k + min(i, m):(i + 1) * k + min(i + 1, m)]) for i in xrange(n))



# Define the main LSH Sampling
def lsh_main(data,obs):
	global lshf 
	lshf = LSHForest(n_estimators=30, random_state=42)
	lshf.fit(sparse.coo_matrix(data)) 
	query_sets = chunk(range(obs),p)
	pool = Pool(processes=p)  
	NN_set = pool.map(knn, query_sets)
	pool.close()	
	indices = numpy.vstack(NN_set)
	arr1=numpy.ones(obs)
	Nb=numpy.zeros(4)
	m=numpy.zeros(4)
	for i in range(0,obs):
		if arr1[i]!=0:
			Nb = indices[i][1:5]
			arr1[Nb]=m
	return arr1

# Define the Nearesr Neighbor search with trained LSH data
def knn(q_idx):
	distances, indices = lshf.kneighbors(Xnew[q_idx,:], n_neighbors=5)
	return indices

#Number of processes
p=8 


Xnew=X
# Repeat the LSH Sampling i times
for i in range(0,itr):
	row=Xnew.shape[0]
	result=lsh_main(Xnew,row)
	c=numpy.nonzero(result)
	c1=c[0]
	Xnew=Xnew[c1,:]
# Print the Shape of new Sampled data
print("Size of Sampled Data",Xnew.shape)

# Print the shape of original data
print("Size of Original  Data",X.shape)

# Save the sampled data in your folder
numpy.savetxt("/home/snehalika/Desktop/datares.csv",Xnew, delimiter=",")



