USE bichos
GO

--1) bichos que cambian de tipo al evolucionar
SELECT e1.tipo1 AS 'Tipo anterior', e2.especie, e2.id, e2.tipo1 AS 'Tipo actual'
FROM especieEvolucion
	JOIN especie e1 ON e1.id = especieEvolucion.id_especie_actual
	JOIN especie e2 ON e2.id = especieEvolucion.id_especie_siguiente
WHERE e1.tipo1 <> e2.tipo1 OR e1.tipo2 <> e2.tipo2

--2) Seleccionar especies que puedan sobrevivir al ataque físico más poderoso (Explosión)
SELECT especie.especie, especie.defensa_normal_maxima
FROM especie
WHERE especie.defensa_normal_maxima > (SELECT max(ataque.potencia)
FROM ataque
WHERE ataque.categoria = 'f')

--3) Mostrar el ataque físico más poderoso posible considerando el ataque y quien realiza el ataque
SELECT especie.especie, ataque.nombre, (especie.ataque_normal_maximo + ataque.potencia) AS 'Potencia'
FROM especie, ataque
WHERE (especie.ataque_normal_maximo + ataque.potencia) = (SELECT max(especie.ataque_normal_maximo + ataque.potencia)
FROM especie, ataque
WHERE ataque.categoria = 'f')

--4) Cantidad máxima de daño especial posible.
--Considere que el ataque empleado debe ser del mismo tipo que el atacante (considerando que el atacante puede tener dos tipos)
--Y cuan eficiente es contra el tipo del especie atacado.
--Considerando, además, las estadísticas de los especies y el ataque.
--Considerando el especie atacante en su nivel máximo y el especie atacado con estadísticas base

--El cálculo de daño se realiza con la siguiente formula:
--(((((2 x nivel atacante) / 5) + 2) * potencia de ataque * (poder del atacante / defensa del atacado)) / 50) + 2
SELECT e1.especie AS 'Atacante', a1.nombre, e2.especie AS 'Atacado', (((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia) AS 'Daño inflingido'
FROM resitenciasTipo ea
	JOIN ataque a1 ON a1.id_tipo = ea.id_tipo_ataque
	JOIN especie e1 ON a1.id_tipo = e1.tipo1 OR a1.id_tipo = e1.tipo2
	JOIN especie e2 ON e2.tipo1 = ea.id_atacado OR e2.tipo2 = ea.id_atacado
WHERE a1.categoria = 'e' AND (((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia) = (
SELECT max(((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia)
	FROM resitenciasTipo ea
		JOIN ataque a1 ON a1.id_tipo = ea.id_tipo_ataque
		JOIN especie e1 ON a1.id_tipo = e1.tipo1 OR a1.id_tipo = e1.tipo2
		JOIN especie e2 ON e2.tipo1 = ea.id_atacado OR e2.tipo2 = ea.id_atacado
	WHERE
(e2.tipo1 = ea.id_atacado OR e2.tipo2 = ea.id_atacado) AND a1.id_tipo = ea.id_tipo_ataque AND
		(e1.tipo1 = a1.id_tipo OR e1.tipo2 = a1.id_tipo) AND ea.eficacia = 2 AND a1.categoria = 'e')

--5) especie más fuerte que ningún entrenador tiene
	SELECT especie.especie
	FROM especie
	WHERE especie.ataque_especial_maximo = (SELECT max(especie.ataque_especial_maximo)
	FROM especie)
EXCEPT
	SELECT especie.especie
	FROM especie INNER JOIN bicho ON bicho.id = especie.id
		INNER JOIN usuariobicho ON usuariobicho.id_bicho = bicho.id

--6) Ataque físico más fuerte que puede aprender el bicho con menor ataque físico
DECLARE @debil INT
SELECT @debil = especie.id
FROM especie
WHERE especie.ataque_normal_maximo = (SELECT MIN(especie.ataque_normal_maximo)
FROM especie);
SELECT especie.especie, ataque.nombre
FROM especie
	LEFT JOIN ataqueEspecie ae ON ae.id_especie = especie.id
	LEFT JOIN ataque ON ataque.id = ae.id_ataque
WHERE ataque.potencia = (SELECT max(ataque.potencia)
	FROM ataque
		LEFT JOIN ataqueEspecie ae ON ae.id_ataque = ataque.id
	WHERE ae.id_especie = @debil)
	AND especie.id = @debil

--7) Bicho más fuerte recibido por intercambio (a caray, olvidé la parte del intercambio jsjs)
SELECT bicho.id, especie.especie, especie.ataque_normal_maximo
FROM bicho
	LEFT JOIN especie ON especie.id = bicho.id_especie
WHERE especie.ataque_normal_maximo = (SELECT max(especie.ataque_normal_maximo)
FROM bicho
	LEFT JOIN especie ON especie.id = bicho.id_especie)

--8) Ataques que ningún entrenador le han enseñado a sus bichos
	SELECT ataque.nombre
	FROM ataque
EXCEPT
	SELECT ataque.nombre
	FROM bicho
		LEFT JOIN ataque ON ataque.id = bicho.id_ataque1 OR ataque.id = bicho.id_ataque2 OR ataque.id = bicho.id_ataque3 OR ataque.id = bicho.id_ataque4

--9) Especie de bicho que ningún entrenador tiene
	SELECT especie.especie
	FROM especie
EXCEPT
	SELECT especie.especie
	FROM bicho
		LEFT JOIN especie ON especie.id = bicho.id_especie

--10) Especie más común entre los entrenadores
SELECT ent.nombre, ub.nombre, esp.especie, count(esp.especie) total
FROM usuariobicho ub
	INNER JOIN usuario ent ON ent.id = ub.id_usuario
	INNER JOIN bicho bic ON ub.id_bicho = bic.id
	INNER JOIN especie esp ON bic.id_especie = esp.id
GROUP BY esp.especie,ent.nombre,ub.nombre

--11) Especie más intercambiada
--12) Entrenadores que más veces se han enfrentado
--13) Todos los entrenadores derrotados por Red
--14) Entrenador con mayor número de derrotas
--15) Entrenador con bichos de tipos opuestos (Que los ataques de uno son muy eficaces contra el otro)
--16) Especie con la que más se han ganado combates
--17) Especies que no han ganado combates
--18) 
--19) 
--21) 
--22) 
--23) 
--24) 
--25) 
--26) 
--27) 
--28) 
--29) 
--30) 
--TRIGGER: Calcular la salud resultante de un atacado
--Stored Procedure: Calcular el daño