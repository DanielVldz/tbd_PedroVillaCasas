USE comedor
GO

-- 01. Cantidad total de dinero que los tutores le deben a la escuela
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
	FROM niño n
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
	GROUP BY t.nombre, t.apaterno, t.amaterno
	HAVING 3 < COUNT(DISTINCT n.id_niño)
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
	GROUP BY t.nombre, t.apaterno, t.amaterno
	HAVING SUM(a.monto) BETWEEN 200 and 500

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
	GROUP BY a.nombre
	HAVING 5 < COUNT(*)

-- 16. Nombres de niños que empiecen con J, K o L
SELECT Nombre = n.nombre+' '+n.apaterno+' '+n.amaterno
	FROM niño n
	WHERE n.nombre LIKE '[JKL]%'
	ORDER BY n.nombre

-- 17. Tutores que sus niños tengan alergias
SELECT t.id_tutor, nombre = t.nombre+' '+t.apaterno+' '+t.amaterno, t.lugar_de_trabajo, t.telefono_trabajo, t.telefono_celular
	FROM tutor t
	JOIN niño n on n.id_tutor = t.id_tutor
	JOIN niñoAlergias a on a.id_niño = n.id_niño
	GROUP BY t.id_tutor, t.nombre+' '+t.apaterno+' '+t.amaterno, t.lugar_de_trabajo, t.telefono_trabajo, t.telefono_celular

-- 18. Alimentos que usan más de 10 unidades de cantidad de ingredientes en total
SELECT a.nombre, [ Cantidad de ingredientes total ] = SUM(ai.cantidad)
	FROM alimento a
	JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	GROUP BY a.nombre
	HAVING SUM(ai.cantidad) > 10

-- 19. Bebidas que tengan literalmente un solo ingrediente
SELECT bebida = a.nombre
	FROM alimento a
	JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	WHERE a.tipo = 'bebida'
	GROUP BY a.nombre
	HAVING COUNT(*) = 1

-- 20. Padre o tutor con mayor adeudo
SELECT TOP 1 t.id_tutor, nombre = t.nombre+' '+t.apaterno+' '+t.amaterno, t.lugar_de_trabajo, t.telefono_trabajo, t.telefono_celular, total = SUM(a.monto)
	FROM tutor t
	JOIN adeudo a on a.id_tutor = t.id_tutor
	GROUP BY t.id_tutor, t.nombre+' '+t.apaterno+' '+t.amaterno, t.lugar_de_trabajo, t.telefono_trabajo, t.telefono_celular
	ORDER BY SUM(a.monto)

-- 21. Ninos cuyos tutores tienen adeudos y que tengan familia con tutores sin adeudos
SELECT nombre = n.nombre+' '+n.apaterno+' '+n.amaterno, [adeudo del tutor] = SUM(a.monto)
	FROM niño n
	JOIN adeudo a on a.id_tutor = n.id_tutor
	WHERE 0 IN (
		SELECT COUNT(*)
			FROM niño nn
			JOIN adeudo aa on aa.id_tutor = nn.id_tutor
			WHERE (n.apaterno = nn.apaterno OR n.apaterno = nn.amaterno OR n.amaterno = nn.apaterno OR n.amaterno = nn.amaterno)
				AND NOT (n.nombre = nn.nombre AND n.apaterno = nn.apaterno AND n.amaterno = nn.amaterno)
	)
	GROUP BY n.nombre, n.apaterno, n.amaterno

-- 22. Familiares que compartan la misma alergia
SELECT [id niño 1] = n1.id_niño, [niño 1] = n1.nombre+' '+n1.apaterno+' '+n1.amaterno, [alergia niño 1] = na1.nombre,
[id niño 2] = n2.id_niño, [niño 2] = n2.nombre+' '+n2.apaterno+' '+n2.amaterno, [alergia niño 2] = na2.nombre
	FROM niño n1
	JOIN niñoAlergias na1 on n1.id_niño = na1.id_niño
	JOIN niño n2 on (n1.amaterno = n2.amaterno OR n1.amaterno = n2.apaterno OR n1.apaterno = n2.amaterno OR n1.apaterno = n2.apaterno)
		AND NOT (n1.apaterno = n2.apaterno AND n1.amaterno = n2.amaterno)
	JOIN niñoAlergias na2 on n2.id_niño = na2.id_niño
	WHERE na1.nombre = na2.nombre
	GROUP BY n1.id_niño, n1.nombre+' '+n1.apaterno+' '+n1.amaterno, na1.nombre, n2.id_niño, n2.nombre+' '+n2.apaterno+' '+n2.amaterno, na2.nombre


-- 23. El menu que mas ninos con adeudo tienen
SELECT TOP 1 m.id_menu, m.nombre, [niños que tienen asignado este menu] = COUNT(DISTINCT n.id_niño)
	FROM menu m
	JOIN niñoMenu nm on nm.id_menu = m.id_menu
	JOIN niño n on n.id_niño = nm.id_niño
	JOIN tutor t on t.id_tutor = n.id_tutor
	JOIN adeudo a on a.id_tutor = t.id_tutor
	GROUP BY m.id_menu, m.nombre
	ORDER BY COUNT(DISTINCT n.id_niño) DESC

-- 24. Menu con mayor numero de ingredientes apunto de agotarse existencias (existencias menores a 20)
SELECT TOP 1 m.id_menu, m.nombre, [cantidad de ingredientes cuyas existencias sean menores a 20] = COUNT(*)
	FROM menu m
	JOIN menu_alimento ma on ma.id_menu = m.id_menu
	JOIN alimento a on a.id_alimento = ma.id_alimento
	JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	WHERE i.existencias < 20
	GROUP BY m.id_menu, m.nombre
	ORDER BY COUNT(*) DESC

-- 25. Menu que comen la mayor cantidad de ninos
SELECT TOP 1 m.id_menu, m.nombre, [niños que tienen asignado este menu] = COUNT(*)
	FROM menu m
	JOIN niñoMenu nm on nm.id_menu = m.id_menu
	GROUP BY m.id_menu, m.nombre
	ORDER BY COUNT(*) DESC


-- 26. Niños con alergias que su menu no contenga a lo que es alergico
SELECT n.id_niño, nombre = n.nombre+' '+n.apaterno+' '+n.amaterno, aula = CONVERT(CHAR(1), n.nivel)+n.grado
	FROM niño n
	JOIN niñoAlergias na on na.id_niño = n.id_niño
	JOIN niñoMenu nm on nm.id_niño = n.id_niño
	JOIN menu m on m.id_menu = nm.id_menu
	JOIN menu_alimento ma on ma.id_menu = m.id_menu
	JOIN alimento a on a.id_alimento = ma.id_alimento
	JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	WHERE na.nombre <> i.nombre
	GROUP BY n.id_niño, n.nombre+' '+n.apaterno+' '+n.amaterno, CONVERT(CHAR(1), n.nivel)+n.grado

-- 27. Ingrediente menos utilizado en los menus y la cantidad de veces que se usa
SELECT TOP 1 i.nombre, [veces usado] = COUNT(*)
	FROM menu m
	JOIN menu_alimento ma on ma.id_menu = m.id_menu
	JOIN alimento a on a.id_alimento = ma.id_alimento
	JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	GROUP BY i.nombre
	ORDER BY COUNT(*)

-- 28. Tutores de varios ninos(2 o mas) con adeudos
SELECT nombre = t.nombre+' '+t.apaterno+' '+t.amaterno, niños = COUNT(DISTINCT n.id_niño), adeudo = SUM(a.monto)
	FROM tutor t
	JOIN niño n on n.id_tutor = t.id_tutor
	JOIN adeudo a on a.id_tutor = t.id_tutor
	GROUP BY t.nombre+' '+t.apaterno+' '+t.amaterno
	HAVING 2 <= COUNT(DISTINCT n.id_niño)

-- 29. Ninos sin familiares(Hermanos, Primos), sin alergias y sin adeudos
SELECT nombre = n.nombre+' '+n.apaterno+' '+n.amaterno
	FROM niño n
	JOIN tutor t on t.id_tutor = n.id_tutor
	WHERE 0 IN (
		SELECT COUNT(*)
			FROM niño familiar
			WHERE (n.amaterno = familiar.amaterno OR n.amaterno = familiar.apaterno OR n.apaterno = familiar.amaterno OR n.apaterno = familiar.apaterno)
			AND NOT (n.apaterno = familiar.apaterno AND n.amaterno = familiar.amaterno)
	) AND 0 IN (
		SELECT COUNT(*)
			FROM niñoAlergias na
			WHERE na.id_niño = n.id_niño
	) AND 0 IN (
		SELECT COUNT(*)
			FROM adeudo a
			WHERE a.id_tutor = t.id_tutor
	)

-- 30. La lista de compras pero que me diga porque el ingrediente esta ahi, si porque esta acabando existencias (<20) o si esta a punto de caducar (10 o menos dias para la fecha)
SELECT ingrediente = i.nombre, [razon por la cual este ingrediente esta en la lista] =
CASE WHEN i.existencias < 20
THEN 'Las existencias están por agotarse.'
ELSE
	CASE WHEN i.caducidad <= GETDATE()
	THEN 'La fecha de caducidad ya ha expirado.'
	ELSE
		CASE WHEN DATEDIFF(DD, GETDATE(), i.caducidad) <= 10
		THEN 'La fecha de caducidad está por expirar.'
		ELSE
			'Por alguna razón está aquí.'
		END
	END
END
	FROM listaDeCompras l
	JOIN ingrediente_listaDeCompras il on il.id_lista = l.id_lista
	JOIN ingrediente i on i.id_ingrediente = il.id_ingrediente

/*
 * EXCEPT
 * LEFT y RIGHT JOIN
 * CHECK
 * UNION ALL
 * where [not] exists (<subquery>), o where <expresión><operador de comparación<(<subquery>)
 * MAX() MIN() AVG()
 * compute, compute by
*/
