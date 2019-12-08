import random
listaDatos = [] 

def generarLista(x):
	listaRondas = []
	for i in range(125):
		for j in range(2):
			bicho1 = random.randint(1,50)
			bicho2 = random.randint(1,50)
			ataque1 = random.randint(1, 97)
			while bicho1 == bicho2:
				bicho1 = random.randint(1, 50)
				bicho2 = random.randint(1, 50)
			print("(",(i + 1),",",bicho1,",",ataque1,",",bicho2,"),")

def generarInserts():
	for i in range (len(listaDatos)):
		print("(",listaDatos[i][0], ",", listaDatos[i][1],",",listaDatos[i][2],",",listaDatos[i][3],"),")
generarLista(100)