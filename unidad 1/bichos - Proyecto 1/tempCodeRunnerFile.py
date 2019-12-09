
def obtenerEmpleo():
	empleos = ["Intel", "Oracle", "Microsoft", "AMD", "VolksWagen", "Ley", "Soriana", "Wal-Mart", "Sam's Club", "Universidad autónoma de Sinaloa"]
	x = random.randint(0, len(empleos))
	y = empleos[x]
	return y