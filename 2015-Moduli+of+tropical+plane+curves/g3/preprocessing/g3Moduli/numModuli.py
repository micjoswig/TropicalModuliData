moduli='./g3ModuliG_31.txt'
num='./g3numG_31.txt'
numModuli='./g3numModuliG_31.txt'
numModuliFile=open(numModuli, 'ab')
with open(moduli) as f:
	moduliFile = f.read().splitlines()
with open(num) as f:
	numFile = f.read().splitlines()
for x in numFile:
	list=[]
	xIndex=numFile.index(x)
	list.append(x)
	n=moduliFile[xIndex]
	list.append(n)
	numModuliFile.write(str(list)+'\n')