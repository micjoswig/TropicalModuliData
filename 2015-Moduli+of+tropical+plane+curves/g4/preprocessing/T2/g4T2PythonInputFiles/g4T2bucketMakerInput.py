import networkx as nx
import networkx.algorithms.isomorphism as iso

reps=[]

def isoCheck(z,N,E):
    # build G:
    G = nx.MultiGraph()
    G.add_nodes_from(N)
    G.add_edges_from(E)
    for h in reps:
        h_z,h_N,h_E = h # unpacks the (z,N,E) from reps
        H=nx.MultiGraph()
        H.add_nodes_from(h_N)
        H.add_edges_from(h_E)
        if nx.is_isomorphic(G,H):
            return (h)
    else: # didn't find an isomorphism
        return None

def bucketMaker(z,N,E):
	#Takes graphs and sorts them into isomorphism classes.
    h = isoCheck(z,N,E)
    filename = './g4T2Buckets/G_'+str(h[0][0] if h else z[0])+'.txt'
    num = './g4T2Buckets/numG_'+str(h[0][0] if h else z[0])+'.txt'
    tri = './g4T2Buckets/triG_'+str(h[0][0] if h else z[0])+'.txt'
    if not h:
        # we didn't find an isomorphism class, so we should remember this graph as a new one
        reps.append((z,N,E))
    with open(filename, 'ab') as f:
        f.write(str((z,N,E))+'\n')
    with open(num, 'ab') as g:
    	x=z[0]
        g.write(str(x)+'\n')
        
def zReps(L):
	#Makes a file of representatives used.
	zReps=[]
	for x in L:
		zReps.append(x[0][0])
	with open("zReps.txt",'ab') as f:
		f.write(str(zReps))

bucketMaker( [0] , [1, 3, 8, 9, 10, 11] , [(1, 8), (1, 1), (3, 9), (3, 3), (8, 10), (8, 9), (9, 11), (10, 11), (10, 11)] )
bucketMaker( [1] , [1, 3, 8, 9, 10, 11] , [(1, 8), (1, 1), (3, 9), (3, 3), (8, 11), (8, 9), (9, 11), (10, 10), (10, 11)] )
bucketMaker( [2] , [1, 7, 8, 9, 10, 11] , [(1, 1), (1, 7), (7, 10), (7, 9), (8, 11), (8, 9), (8, 9), (10, 11), (10, 11)] )
bucketMaker( [3] , [6, 7, 8, 9, 10, 11] , [(6, 9), (6, 7), (6, 7), (7, 10), (8, 9), (8, 9), (8, 11), (10, 11), (10, 11)] )
bucketMaker( [4] , [1, 7, 8, 9, 10, 11] , [(1, 1), (1, 7), (7, 8), (7, 9), (8, 10), (8, 11), (9, 10), (9, 11), (10, 11)] )
bucketMaker( [5] , [6, 7, 8, 9, 10, 11] , [(6, 8), (6, 7), (6, 7), (7, 9), (8, 11), (8, 10), (9, 10), (9, 11), (10, 11)] )
bucketMaker( [6] , [1, 6, 7, 8, 9, 10] , [(1, 1), (1, 6), (6, 8), (6, 7), (7, 9), (7, 10), (8, 9), (8, 10), (9, 10)] )
bucketMaker( [7] , [5, 6, 7, 8, 9, 10] , [(5, 6), (5, 6), (5, 7), (6, 8), (7, 9), (7, 10), (8, 9), (8, 10), (9, 10)] )
bucketMaker( [8] , [6, 7, 8, 9, 10, 11] , [(6, 10), (6, 11), (6, 7), (7, 8), (7, 9), (8, 9), (8, 10), (9, 11), (10, 11)] )
bucketMaker( [9] , [5, 6, 7, 8, 9, 11] , [(5, 8), (5, 9), (5, 6), (6, 11), (6, 7), (7, 9), (7, 11), (8, 11), (8, 9)] )
bucketMaker( [10] , [5, 6, 7, 8, 9, 10] , [(5, 8), (5, 9), (5, 6), (6, 10), (6, 7), (7, 9), (7, 10), (8, 10), (8, 9)] )
bucketMaker( [11] , [4, 7, 8, 9, 10, 11] , [(4, 7), (4, 9), (4, 11), (7, 8), (7, 9), (8, 10), (8, 11), (9, 10), (10, 11)] )
bucketMaker( [12] , [4, 5, 6, 7, 9, 10] , [(4, 5), (4, 7), (4, 10), (5, 9), (5, 6), (6, 9), (6, 7), (7, 10), (9, 10)] )
bucketMaker( [13] , [4, 5, 6, 7, 9, 10] , [(4, 10), (4, 5), (4, 7), (5, 9), (5, 6), (6, 9), (6, 7), (7, 10), (9, 10)] )
bucketMaker( [14] , [4, 6, 7, 8, 9, 11] , [(4, 9), (4, 11), (4, 7), (6, 8), (6, 9), (6, 11), (7, 8), (7, 11), (8, 9)] )
bucketMaker( [15] , [4, 5, 6, 7, 8, 10] , [(4, 5), (4, 7), (4, 10), (5, 6), (5, 8), (6, 8), (6, 7), (7, 10), (8, 10)] )
bucketMaker( [16] , [4, 6, 7, 8, 9, 11] , [(4, 9), (4, 11), (4, 7), (6, 8), (6, 9), (6, 11), (7, 8), (7, 11), (8, 9)] )
bucketMaker( [17] , [4, 5, 6, 7, 9, 10] , [(4, 9), (4, 6), (4, 7), (5, 9), (5, 10), (5, 6), (6, 7), (7, 10), (9, 10)] )
bucketMaker( [18] , [3, 5, 6, 7, 9, 10] , [(3, 9), (3, 10), (3, 7), (5, 9), (5, 6), (5, 7), (6, 10), (6, 7), (9, 10)] )
bucketMaker( [19] , [3, 5, 6, 7, 9, 10] , [(3, 9), (3, 10), (3, 7), (5, 9), (5, 6), (5, 7), (6, 10), (6, 7), (9, 10)] )
