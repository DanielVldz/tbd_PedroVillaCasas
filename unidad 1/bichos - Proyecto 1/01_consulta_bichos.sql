USE bichos
GO
-- use master
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

--7) Bicho más fuerte recibido por intercambio
SELECT TOP 1
	bicho.id, especie.especie, MAX(especie.ataque_normal_maximo) AS ataque
FROM intercambio
	LEFT JOIN bicho ON bicho.id = intercambio.id_bicho1 OR bicho.id = intercambio.id_bicho2
	LEFT JOIN especie ON especie.id = bicho.id_especie
GROUP BY bicho.id, especie.especie
ORDER BY ataque DESC

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
SELECT TOP 1
	especie.especie, COUNT(especie.especie) AS intercambiado
FROM intercambio
	LEFT JOIN bicho ON bicho.id = intercambio.id_bicho1 OR bicho.id = intercambio.id_bicho2
	LEFT JOIN especie ON especie.id = bicho.id_especie
GROUP BY especie.especie
ORDER BY intercambiado DESC

--12) Entrenadores que más veces se han enfrentado
SELECT TOP 1
	SUM(repeticiones.cnt) AS Enfrentamientos, repeticiones.entrenador1, repeticiones.entrenador2
FROM(
SELECT COUNT(*) cnt, e1.nombre AS 'entrenador1', e2.nombre AS 'entrenador2'
	FROM combate
		LEFT JOIN usuario e1 ON e1.id = combate.id_entrenador1
		LEFT JOIN usuario e2 ON e2.id = combate.id_entrenador2
	GROUP BY e1.nombre, e2.nombre
	HAVING COUNT(*) > 1
)repeticiones
GROUP BY repeticiones.entrenador1, repeticiones.entrenador2
ORDER BY Enfrentamientos DESC

--13) Todos los entrenadores derrotados por Red
DECLARE @red INT
SELECT @red = id
FROM usuario
WHERE nombre = 'Red'
SELECT usuario.nombre
FROM combate
	LEFT JOIN usuario ON usuario.id = combate.id_entrenador1 OR usuario.id = combate.id_entrenador2
WHERE combate.id_ganador = @red AND usuario.id <> @red

--14) Entrenador con mayor número de derrotas
SELECT TOP 1
	usuario.nombre, COUNT(usuario.nombre) AS derrotas
FROM combate
	LEFT JOIN usuario ON usuario.id = combate.id_entrenador1 OR usuario.id = combate.id_entrenador2
WHERE usuario.id <> combate.id_ganador
GROUP BY usuario.nombre
ORDER BY derrotas DESC

--15) Entrenadores que no evolucionan a sus bichos
SELECT usuario.nombre, bicho.id, especie.especie
FROM usuarioBicho
	LEFT JOIN bicho ON bicho.id = usuarioBicho.id_bicho
	LEFT JOIN especie ON especie.id = bicho.id_especie
	LEFT JOIN usuario ON usuario.id = usuarioBicho.id_usuario
WHERE especie.id NOT IN(
	SELECT especieEvolucion.id_especie_siguiente
FROM especieEvolucion
)

--16) Especie con la que más se han ganado combates
SELECT TOP 1
	especie.especie, COUNT(especie.especie) AS Victorias
FROM combate
	LEFT JOIN usuario ON usuario.id = combate.id_ganador
	LEFT JOIN ronda ON ronda.id_combate = combate.id_combate
	LEFT JOIN bicho ON bicho.id = ronda.id_atacante
	LEFT JOIN especie ON especie.id = bicho.id_especie
GROUP BY especie.especie
ORDER BY Victorias DESC

--17) Especies que no han ganado combates
SELECT DISTINCT especie.especie
FROM combate
	LEFT JOIN ronda ON ronda.id_combate = combate.id_combate
	LEFT JOIN usuario ON usuario.id = combate.id_entrenador1 OR usuario.id = combate.id_entrenador2
	LEFT JOIN bicho ON bicho.id = ronda.id_atacante
	LEFT JOIN especie ON especie.id = bicho.id_especie
WHERE usuario.id <> combate.id_ganador AND ronda.id_entrenador = usuario.id

--18) Bicho de mayor nivel que ha perdido un combate
SELECT TOP 1
	bicho.id, especie.especie, bicho.nivel AS nivel
FROM combate
	LEFT JOIN usuario ON usuario.id = combate.id_entrenador1 OR usuario.id = combate.id_entrenador2
	LEFT JOIN ronda ON ronda.id_combate = combate.id_combate AND ronda.id_entrenador = usuario.id
	LEFT JOIN bicho ON bicho.id = ronda.id_atacante
	LEFT JOIN especie ON especie.id = bicho.id_especie
WHERE usuario.id <> combate.id_ganador
GROUP BY bicho.id, especie.especie, bicho.nivel
ORDER BY bicho.nivel DESC

--19) Entrenadores invictos
	SELECT usuario.nombre
	FROM usuario
EXCEPT
	SELECT usuario.nombre
	FROM combate
		LEFT JOIN usuario ON usuario.id = combate.id_entrenador1 OR usuario.id = combate.id_entrenador2
	WHERE usuario.id <> combate.id_ganador

--20) Entrenadores que han ganado con un bicho recibido por intercambio
SELECT DISTINCT usuario.nombre, bicho.id, especie.especie
FROM combate
	LEFT JOIN ronda ON ronda.id_combate = combate.id_combate
	LEFT JOIN usuario ON usuario.id = combate.id_ganador
	LEFT JOIN bicho ON bicho.id = ronda.id_atacante
	LEFT JOIN especie ON especie.id = bicho.id
	LEFT JOIN intercambio ON (intercambio.id_entrenador1 = usuario.id AND intercambio.id_bicho2 = bicho.id) OR (intercambio.id_entrenador2 = usuario.id AND intercambio.id_bicho1 = bicho.id)
WHERE (usuario.id = intercambio.id_entrenador1 AND bicho.id = intercambio.id_bicho2) OR (usuario.id = intercambio.id_entrenador2 AND bicho.id = intercambio.id_bicho1)

--21) Evolución de Eevee con mayor velocidad
SELECT TOP 1
	especie.especie, especie.velocidad_maxima AS velocidad
FROM especieEvolucion
	LEFT JOIN especie ON especie.id = especieEvolucion.id_especie_siguiente
WHERE especieEvolucion.id_especie_actual = (SELECT especie.id
FROM especie
WHERE especie.especie = 'Eevee')
GROUP BY especie.especie, especie.velocidad_maxima
ORDER BY especie.velocidad_maxima DESC

--22) Especies que pueden usar el ataque físico más poderoso
SELECT especie.especie, ataque.nombre
FROM ataqueEspecie
	LEFT JOIN especie ON especie.id = ataqueEspecie.id_especie
	LEFT JOIN ataque ON ataque.id = (
SELECT TOP 1
		ataque.id
	FROM ataque
	WHERE ataque.categoria = 'f'
	ORDER BY ataque.potencia DESC)
WHERE ataqueEspecie.id_ataque = ataque.id

--23) Bichos que son invencibles
SELECT DISTINCT bicho.id, especie.especie
FROM combate
	LEFT JOIN ronda ON ronda.id_combate = combate.id_combate
	LEFT JOIN bicho ON bicho.id = ronda.id_atacante
	LEFT JOIN especie ON especie.id = bicho.id
WHERE bicho.id NOT IN(
SELECT ronda.id_atacante
FROM combate
	LEFT JOIN ronda ON ronda.id_combate = combate.id_combate
	LEFT JOIN usuario ON usuario.id = combate.id_entrenador1 OR usuario.id = combate.id_entrenador2
WHERE usuario.id <> combate.id_ganador AND ronda.id_entrenador = usuario.id
)

--24) Especie más común entre machos
SELECT TOP 1
	especie.especie, COUNT(especie.especie) AS repeticiones
FROM bicho
	LEFT JOIN especie ON especie.id = bicho.id_especie
WHERE bicho.genero = 'm'
GROUP BY especie.especie
ORDER BY repeticiones DESC

--25) Bicho hembra más fuerte
SELECT TOP 1
	bicho.id, especie.especie, bicho.ataque_normal
FROM bicho
	LEFT JOIN especie ON especie.id = bicho.id_especie
ORDER BY bicho.ataque_normal DESC

--26) Bichos más lentos que han ganado un combate
SELECT TOP 1
	bicho.id AS bicho, especie.especie, bicho.velocidad
FROM combate
	LEFT JOIN ronda ON ronda.id_combate = combate.id_combate
	LEFT JOIN bicho ON bicho.id = ronda.id_atacante
	LEFT JOIN especie ON especie.id = bicho.id_especie
	LEFT JOIN usuario ON usuario.id = combate.id_ganador
WHERE usuario.id = ronda.id_entrenador
ORDER BY bicho.velocidad ASC

--27) Especies que no puede evolucionar
	SELECT especie.especie
	FROM especie
EXCEPT
	SELECT especie.especie
	FROM especieEvolucion
		LEFT JOIN especie ON especie.id = especieEvolucion.id_especie_actual

--28) Especies con más de una evolución
SELECT especie.especie, COUNT(especie.especie) AS evoluciones
FROM especieEvolucion
	LEFT JOIN especie ON especie.id = especieEvolucion.id_especie_actual
GROUP BY especie.especie
HAVING COUNT(especie.especie) > 1

--29) Ataque más enseñado por entrenadores
SELECT TOP 1
	ataque.nombre, COUNT(ataque.nombre) AS repeticiones
FROM bicho
	LEFT JOIN ataque ON ataque.id = bicho.id_ataque1 OR ataque.id = bicho.id_ataque2 OR ataque.id = bicho.id_ataque3 OR ataque.id = bicho.id_ataque4
GROUP BY ataque.nombre
ORDER BY repeticiones DESC

--30) Entrenador que no ha ganado ningún combate
SELECT DISTINCT usuario.nombre
FROM usuario
WHERE usuario.id NOT IN(
SELECT usuario.id
FROM combate
	LEFT JOIN usuario ON usuario.id = combate.id_entrenador2 OR usuario.id = combate.id_entrenador2
WHERE usuario.id <> combate.id_ganador 
)
