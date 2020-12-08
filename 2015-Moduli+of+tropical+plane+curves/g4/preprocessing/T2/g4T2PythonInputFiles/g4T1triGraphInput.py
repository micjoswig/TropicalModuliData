import networkx as nx

def triGraph(z,N,E):
# Let T[z] be a unimodular triangulation of the triangle with vertices (0,0), (0,n), and (n,0) from Rambau's TOMPCOM data. Let N be the set of vertices and E the set of edges of
# the dual graph of T[z]. Then triGraph takes an input z,N, and E and outputs the dual graph of T[z] with all of its degree 1 and degree 2 vertices contracted.
	G=nx.MultiGraph()
	G.add_nodes_from(N)
	G.add_edges_from(E)
	allnodes=G.nodes()
	for i in allnodes:
	#these for and while loops go through every vertex i of G, remove i if its degree is 1, check i's adjacent vertex a to see if it is also of degree 1, and repeat this process with
	#a. Once a vertex of degree greater than 1 is found, the while loop is existed and the next vertex of G is checked.
		k=i
		while k in G.nodes() and G.degree(k)==1:
			neighbors=G.neighbors(k)
			G.remove_node(k)
			k=neighbors[0]
	for i in G.nodes():
	#This for loop goes through every vertex of G. If a vertex i of degree 2 is found, then either it is the case that i is adjacent to two distinct vertices or that i is adjacent to one vertex (via two edges).
	# If it is the first case, then the second if removes i and joins its two distinct vertices with an edge. If it is the second case then the third if loop removes i and adds a loop to its adjacent vertex.
		if G.degree(i)==2:
			neighbors=G.neighbors(i)
			if len(neighbors)==2:
				G.remove_node(i)
				G.add_edge(neighbors[0],neighbors[1])
			if len(neighbors)==1:
				G.remove_node(i)
				G.add_edge(neighbors[0],neighbors[0])
	print 'bucketMaker(',z,',',G.nodes(),',',G.edges(),')'

triGraph([ 0 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [0, 2], [1, 2], [3, 4], [3, 5], [4, 5], [6, 7], [1, 8], [3, 9], [8, 9], [6, 10], [8, 10], [7, 11], [9, 11], [10, 11]] )
triGraph([ 1 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [0, 2], [1, 2], [3, 4], [3, 5], [4, 5], [6, 7], [1, 8], [3, 9], [8, 9], [6, 10], [7, 10], [8, 11], [9, 11], [10, 11]] )
triGraph([ 2 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [0, 2], [1, 2], [3, 4], [5, 6], [1, 7], [3, 8], [4, 9], [7, 9], [8, 9], [5, 10], [7, 10], [6, 11], [8, 11], [10, 11]] )
triGraph([ 3 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [4, 5], [1, 6], [0, 7], [6, 7], [2, 8], [3, 9], [6, 9], [8, 9], [4, 10], [7, 10], [5, 11], [8, 11], [10, 11]] )
triGraph([ 4 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [0, 2], [1, 2], [3, 4], [5, 6], [1, 7], [4, 8], [7, 8], [5, 9], [7, 9], [3, 10], [6, 10], [8, 11], [9, 11], [10, 11]] )
triGraph([ 5 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [4, 5], [1, 6], [0, 7], [6, 7], [3, 8], [6, 8], [4, 9], [7, 9], [2, 10], [5, 10], [8, 11], [9, 11], [10, 11]] )
triGraph([ 6 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [0, 2], [1, 2], [4, 5], [1, 6], [3, 7], [6, 7], [4, 8], [6, 8], [7, 9], [8, 9], [3, 10], [9, 10], [5, 11], [10, 11]] )
triGraph([ 7 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [3, 4], [1, 5], [0, 6], [5, 6], [2, 7], [5, 7], [3, 8], [6, 8], [7, 9], [8, 9], [2, 10], [9, 10], [4, 11], [10, 11]] )
triGraph([ 8 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [4, 5], [0, 6], [4, 7], [6, 7], [2, 8], [5, 8], [7, 9], [8, 9], [1, 10], [3, 10], [6, 11], [9, 11], [10, 11]] )
triGraph([ 9 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [0, 5], [4, 6], [5, 6], [6, 7], [1, 8], [3, 8], [5, 9], [7, 9], [8, 9], [2, 10], [4, 11], [7, 11], [10, 11]] )
triGraph([ 10 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [3, 4], [0, 5], [3, 6], [5, 6], [6, 7], [1, 8], [2, 8], [5, 9], [7, 9], [8, 9], [2, 10], [7, 10], [4, 11], [10, 11]] )
triGraph([ 11 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [0, 4], [4, 5], [5, 6], [2, 7], [6, 7], [7, 8], [1, 9], [3, 9], [8, 10], [9, 10], [4, 11], [8, 11], [10, 11]] )
triGraph([ 12 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [0, 4], [3, 5], [4, 5], [5, 6], [4, 7], [6, 7], [2, 8], [3, 9], [6, 9], [8, 9], [2, 10], [7, 10], [1, 11], [10, 11]] )
triGraph([ 13 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[1, 2], [0, 4], [3, 5], [4, 5], [5, 6], [4, 7], [6, 7], [1, 8], [3, 9], [6, 9], [8, 9], [0, 10], [7, 10], [2, 11], [10, 11]] )
triGraph([ 14 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [0, 4], [4, 5], [1, 7], [3, 7], [6, 8], [7, 8], [4, 9], [6, 9], [8, 9], [2, 10], [5, 11], [6, 11], [10, 11]] )
triGraph([ 15 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [0, 4], [2, 5], [4, 5], [5, 6], [4, 7], [6, 7], [6, 8], [3, 9], [8, 9], [7, 10], [8, 10], [1, 11], [10, 11]] )
triGraph([ 16 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[1, 2], [0, 4], [3, 4], [3, 5], [0, 7], [2, 7], [6, 8], [7, 8], [4, 9], [6, 9], [8, 9], [1, 10], [5, 11], [6, 11], [10, 11]] )
triGraph([ 17 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [1, 5], [3, 5], [4, 6], [5, 6], [4, 7], [6, 7], [2, 8], [4, 9], [8, 9], [7, 10], [9, 10], [0, 11], [10, 11]] )
triGraph([ 18 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[1, 2], [0, 3], [3, 4], [5, 6], [3, 7], [5, 7], [6, 7], [1, 8], [4, 9], [5, 9], [8, 9], [0, 10], [6, 10], [2, 11], [10, 11]] )
triGraph([ 19 ],[0,1,2,3,4,5,6,7,8,9,10,11], [[0, 1], [2, 3], [2, 4], [5, 6], [3, 7], [5, 7], [6, 7], [0, 8], [4, 9], [5, 9], [8, 9], [3, 10], [6, 10], [1, 11], [10, 11]] )
