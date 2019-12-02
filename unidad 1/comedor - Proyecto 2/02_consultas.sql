use comedor
go



-- 01. Cantidad de dinero que los tutores le deben a la escuela hijos de perra malapaga
SELECT SUM(monto) FROM adeudo -- en realidad está bien meco, dudo que este sea bueno :'c'

-- 02. Alimentos que contienen ingredientes a los que alguien sea alergico
SELECT Alimento = a.nombre
	FROM alimento a
	INNER JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	INNER JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	INNER JOIN niñoAlergias na on na.nombre = i.nombre
	GROUP BY a.nombre

-- 03. Niño con más alergias
SELECT TOP 1 nombre = n.nombre+' '+n.apaterno+' '+n.amaterno, count(*) as alergias
	from niño n
	INNER JOIN  niñoAlergias na ON na.id_niño = n.id_niño
	GROUP BY n.nombre, n.apaterno, n.amaterno
	ORDER BY alergias DESC

-- 04. Ingredientes que caducó en noviembre y no esten en la lista de compras
SELECT ID = i.id_ingrediente, Nombre = i.nombre, i.caducidad
	FROM ingrediente i
	WHERE MONTH(i.caducidad) = 11 and i.id_ingrediente not in (
		SELECT il.id_ingrediente
		FROM ingrediente_listaDeCompras il
		WHERE i.id_ingrediente = il.id_ingrediente
	)

-- 05. Tutores con 4 o más niños en la escuela
SELECT nombre = t.nombre+' '+t.apaterno+' '+t.amaterno, count(*) as niños
	FROM tutor t
	INNER JOIN  niño n ON n.id_tutor = t.id_tutor
	WHERE 3 < (
		SELECT COUNT(*)
			FROM niño nn
			WHERE nn.id_tutor = t.id_tutor
		)
	GROUP BY t.nombre, t.apaterno, t.amaterno
	ORDER BY niños DESC

-- 06. ninos con alergias que sus tutores tengan adeudos
SELECT [ID del niño] = n.id_niño, niño = n.nombre+' '+n.apaterno+' '+n.amaterno, [Adeudo de su tutor] = SUM(a.monto), Tutor = t.nombre+' '+t.apaterno+' '+t.amaterno
	FROM niño n
	INNER JOIN tutor t on t.id_tutor = n.id_tutor
	INNER JOIN adeudo a on a.id_tutor = t.id_tutor
	WHERE n.id_niño in (
		SELECT na.id_niño
			FROM niñoAlergias na
	) --         ID   -            nombre del niño            -           nombre del tutor
	group by n.id_niño, n.nombre+' '+n.apaterno+' '+n.amaterno, t.nombre+' '+t.apaterno+' '+t.amaterno


-- 07. Tutores con deudas entre $200 y $500
SELECT nombre = t.nombre+' '+t.apaterno+' '+t.amaterno, SUM(a.monto)
	FROM tutor t
	INNER JOIN adeudo a ON a.id_tutor = t.id_tutor
	WHERE (
		SELECT SUM(aa.monto)
			FROM adeudo aa
			WHERE aa.id_tutor = t.id_tutor
		) BETWEEN 200 and 500
	GROUP BY t.nombre, t.apaterno, t.amaterno

-- 08. Alimentos que tengan ingredientes con existencias menores a 20
SELECT Alimento = a.nombre
	FROM alimento a
	INNER JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	INNER JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	WHERE i.existencias < 20
	GROUP BY a.nombre

-- 09. Todos los primos de Leticia Gonzales Almendra
SELECT Primo = primo.nombre+' '+primo.apaterno+' '+primo.amaterno
	FROM niño primo
	WHERE (primo.amaterno = 'Gonzales' OR primo.amaterno = 'Almendra' OR primo.apaterno = 'Gonzales' OR primo.apaterno = 'Almendra')
		AND NOT (primo.apaterno='Gonzales' AND primo.amaterno='Almendra')

-- 10. Menu con el mayor numero de calorias
SELECT Top 1 Menu = m.nombre, Calorias = SUM(a.calorias)
	FROM menu m
	INNER JOIN menu_alimento ma on ma.id_menu = m.id_menu
	INNER JOIN alimento a on a.id_alimento = ma.id_alimento
	GROUP BY m.nombre
	ORDER BY SUM(a.calorias) DESC

-- 11. Muestra todos los hermanos menores de Gonzalo Angulo Salazar
SELECT Nombre = h.nombre+' '+h.apaterno+' '+h.amaterno
	FROM niño Gonzalo
	INNER JOIN niño h ON Gonzalo.apaterno = h.apaterno AND Gonzalo.amaterno = h.amaterno
	WHERE Gonzalo.nombre+' '+Gonzalo.apaterno+' '+Gonzalo.amaterno = 'Gonzalo Angulo Salazar'
		AND CONVERT(DATETIME, Gonzalo.fecha_de_nacimiento) > CONVERT(DATETIME, h.fecha_de_nacimiento)

-- 12. Menu con el mayor numero de alimentos que contengan ingredientes a los que un nino sea alergico
SELECT TOP 1 Menu = m.nombre, [Cantidad de alimentos a los que hay niños alergicos] = count(DISTINCT a.id_alimento)
	FROM menu m
	INNER JOIN menu_alimento ma on ma.id_menu = m.id_menu
	INNER JOIN alimento a on a.id_alimento = ma.id_alimento
	INNER JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	INNER JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	INNER JOIN niñoAlergias na on na.nombre = i.nombre
	GROUP BY m.nombre
	ORDER BY count(DISTINCT a.id_alimento) DESC

-- 13. Muestra el alumno más viejo
SELECT Nombre = n.nombre+' '+n.apaterno+' '+n.amaterno, Edad = DATEDIFF(yy, n.fecha_de_nacimiento, GETDATE())
	FROM niño n
	WHERE 0 in (
		SELECT COUNT(*)
			FROM niño aux
			WHERE DATEDIFF(dd, n.fecha_de_nacimiento, aux.fecha_de_nacimiento)<0
	)

-- 14. ¿Cuales son los hermanos mayores de Marco Gonzales Almendra?
SELECT ID = h.id_niño, nombre = h.nombre+' '+h.apaterno+' '+h.amaterno, Aula = CONVERT(CHAR(1), h.nivel)+h.grado, Edad = DATEDIFF(yy, h.fecha_de_nacimiento, GETDATE())
	FROM niño h
	WHERE h.apaterno+' '+h.amaterno = 'Gonzales Almendra'
		AND DATEDIFF(yy, h.fecha_de_nacimiento, GETDATE()) > (
			SELECT DATEDIFF(yy, Marco.fecha_de_nacimiento, GETDATE())
			FROM niño Marco
			WHERE Marco.nombre+' '+Marco.apaterno+' '+Marco.amaterno = 'Marco Gonzales Almendra'
			)

-- 15. Muestre los alimentos que tienen más de 5 ingredientes
SELECT a.nombre
	FROM alimento a
	INNER JOIN alimento_ingrediente ai ON a.id_alimento = ai.id_alimento
	WHERE 5 < (
		SELECT count(*)
			FROM alimento_ingrediente aiAux
			WHERE aiAux.id_alimento = ai.id_alimento
	)
	GROUP BY a.nombre

-- 16.

-- 17. Nose chale

-- 18.

-- 19. Nose chale

-- 20.

-- 21. Nose chale

-- 22.

-- 23. Nose chale

-- 24.

-- 25. Nose chale

-- 26.

-- 27. Nose chale

-- 28.

-- 29. Nose chale

-- 30.