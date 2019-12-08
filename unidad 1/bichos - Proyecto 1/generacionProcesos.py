import random
listaDatos = [] 

def generarLista(x):
	entrenador1 = 0
	entrenador2 = 0
	for i in range (x):
		entrenador1 = random.randint(1, 25)
		entrenador2 = random.randint(1, 25)

		while (entrenador1 == entrenador2):
			entrenador1 = random.randint(1, 25)
			entrenador2 = random.randint(1, 25)
		
		listaDatos.append([entrenador1,entrenador2,random.randint(1, 50),random.randint(1, 50)])
		print(listaDatos[i])

def generarInserts():
	#print("INSERT INTO combate(id_entrenador1, id_entrenador2, id_bicho1, id_bicho2, id_ganador) VALUES")
	for i in range (len(listaDatos)):
		print("(",listaDatos[i][0], ",", listaDatos[i][1],",",listaDatos[i][2],",",listaDatos[i][3],"),")
print("Generación de consultas")
generarLista(100)
generarInserts()

#Tablas para llenar:
# * Combate(entrenador(1 a 25), entrenador2(1 a 25), bicho1(1 a 50), bicho2(1 a 50), ganador(0 a 1 de los dos entrenadores) generar 100
# * Intercambios(entrenador1(1 a 25), entrenador2(1 a 25), bicho1(1 a 50), bicho2(1 a 50))
#Tabla de rondas(Generar tres con los mismos id's)