import random
import names
listaDatos = [] 

def obtenerEmpleo():
	empleos = ["Intel", "Oracle", "Microsoft", "AMD", "VolksWagen", "Ley", "Soriana", "Wal-Mart", "Sam's Club", "Universidad autónoma de Sinaloa", "Instituto Tecnológico de Culiacán", "Farmacias Similares", "Taquería el güero", "Farmacias GI", "Delia Barraza", "Burger King", "McDonald\'s", "OXXO", "Gasolineras Pemex", "Sears", "Liverpool", "Cinépolis", "Cinemex", "Sushi Factory", "CBtis", "Conalep", "Cobaes", "Escuela Secundaria Técnica No. 50", "Escuela Secundaria Técnica No. 72", "Escuela Secundaria Técnica No. 1", "Televisa", "TV Azteca", "TV Pacífico", "Coca-Cola", "Pepsi", "Costco", "Coppel", "Electra", "Banamex", "BBVA", "Santander", "Unidad De Servicios Estatales", "Hospital General", "Hospital de la mujer", "Hospital pediátrico de Sinaloa", "Universidad Autónoma de Occidente", "Tecnológico de Monterrey"]
	telefonos = [4591301323, 6081412155, 1689752242, 1224375792, 3895669389, 5512187296, 5562160334, 3756929861, 2864794192, 3042543261, 6230567999, 4191183710, 4191111575, 8038240622, 5861787051, 3187392808, 4087365511, 1444213460, 9574972480, 3862661155, 9163193653, 8853595158, 7314945048, 7919060124, 4181657941, 7660788292, 4791657867, 2573515139, 7313346268, 9741497682, 3129122828, 3145415126, 2303365736, 1511466900, 8451343856, 1679185676, 8460198504, 2261481245, 5899083049, 4962857555, 1602912755, 8521314180, 1113011149, 1362015334, 8776770252, 7077775806, 1972610403,]
	x = random.randint(0, len(empleos) - 1)
	return (empleos[x], telefonos[x])

def generarTutor(x):
	for i in range(x):
		empleo = obtenerEmpleo()
		#print("('",names.get_first_name(),"',\t",names.get_last_name(),",\t",names.get_last_name(),",\t",empleo[0],",\t",empleo[1],",\t",numeroTelefonico(10),"),")
		print('(\'{}\', \'{}\', \'{}\', \'{}\', {}, {}),'.format(names.get_first_name(), names.get_last_name(), names.get_last_name(), empleo[0], empleo[1], numeroTelefonico(10)))

def generarNiño(x):
	for i in range(x):
		nivel = random.randint(1,6)
		grado = random.randint(1,2)
		tutor = random.randint(1, 103)
		nacimiento = generarFecha()
		if grado == 1:
			grado = 'A'
		else:
			grado = 'B'
		print("(\'{}\',\'{}\',\'{}\',{},\'{}\',{},\'{}\'),".format(names.get_first_name(), names.get_last_name(), names.get_last_name(), nivel, grado, tutor, nacimiento))
		
def generarFecha():
	año = 2019
	mes = random.randint(1,12)
	dia = 0
	if mes == 2:
		dia = random.randint(1,28)
	elif mes == 12:
		dia = random.randint(1, 6)
	elif mes == 1 or mes == 3 or mes == 5 or mes == 7 or mes == 8 or mes == 10:
		dia = random.randint(1, 31)
	else:
		dia = random.randint(1, 30)
	if dia < 10:
		dia = '0{}'.format(dia)
	if mes < 10:
		mes = '0{}'.format(mes)
	return '{}{}{}'.format(año, mes, dia)

def numeroTelefonico(n):
    rangoInicio = 10**(n-1)
    rangoFin = (10**n)-1
    return random.randint(rangoInicio, rangoFin)

def getAlergia():
	alergia = ["Lacteos", "Mariscos", "Huevo", "Trigo", "Maní", "Almendras", "Nueces", "Soya","Fresas","Cacahuates", "Apio", "Camarones"]
	x = random.randint(0, len(alergia) - 1)
	return alergia[x]

def niñoAlergias(x):
	for i in range(x):
		print('({},\'{}\'),'.format(random.randint(1, 118), getAlergia()))


def generarAdeudo(x):
	for i in range(x):
		tutor = random.randint(1, 103)
		monto = random.randint(200, 700)
		fecha = generarFecha()
		print('({},{},\'{}\'),'.format(tutor, monto, fecha))
# generarTutor(100)
# generarNiño(100)
# niñoAlergias(35)
# generarAdeudo(100)
