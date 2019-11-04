use comedor
go

-- 01. Cantidad de dinero que los tutores le deben a la escuela hijos de perra malapaga
SELECT SUM(monto) FROM adeudo -- en realidad estÃ¡ bien meco, dudo que este sea bueno :'c'

-- 03. Niño con más alergias
SELECT TOP 1 nombre = n.nombre+' '+n.apaterno+' '+n.amaterno, count(*) as alergias
	from niño n
	INNER JOIN  niñoAlergias na ON na.id_niño = n.id_niño
	GROUP BY n.nombre, n.apaterno, n.amaterno
	ORDER BY alergias DESC

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

-- 09. Niños que tienen primos en la escuela (repite los ya mostrados)
SELECT [Nombre A] = a.nombre+' '+a.apaterno+' '+a.amaterno, [Nombre B] = b.nombre+' '+b.apaterno+' '+b.amaterno
	FROM niño a
	INNER JOIN niño b on b.id_niño != a.id_niño
	WHERE (a.amaterno = b.amaterno OR a.amaterno = b.apaterno OR a.apaterno = b.amaterno OR a.apaterno = b.apaterno) AND NOT (a.amaterno=b.amaterno AND a.apaterno=b.apaterno)
	ORDER BY [Nombre A]

-- 11. Nose chale

-- 13. Nose chale

-- 15. Nose chale

-- 17. Nose chale

-- 19. Nose chale

-- 21. Nose chale

-- 23. Nose chale

-- 25. Nose chale

-- 27. Nose chale

-- 29. Nose chale
