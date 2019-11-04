use comedor
go

-- 01. Cantidad de dinero que los tutores le deben a la escuela hijos de perra malapaga
SELECT SUM(monto) FROM adeudo -- en realidad está bien meco, dudo que este sea bueno :'c'

-- 03. Ni�o con m�s alergias
SELECT TOP 1 nombre = n.nombre+' '+n.apaterno+' '+n.amaterno, count(*) as alergias
	from ni�o n
	INNER JOIN  ni�oAlergias na ON na.id_ni�o = n.id_ni�o
	GROUP BY n.nombre, n.apaterno, n.amaterno
	ORDER BY alergias DESC

-- 05. Tutores con 4 o m�s ni�os en la escuela
SELECT nombre = t.nombre+' '+t.apaterno+' '+t.amaterno, count(*) as ni�os
	FROM tutor t
	INNER JOIN  ni�o n ON n.id_tutor = t.id_tutor
	WHERE 3 < (
		SELECT COUNT(*)
			FROM ni�o nn
			WHERE nn.id_tutor = t.id_tutor
		)
	GROUP BY t.nombre, t.apaterno, t.amaterno
	ORDER BY ni�os DESC


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

-- 09. Ni�os que tienen primos en la escuela (repite los ya mostrados)
SELECT [Nombre A] = a.nombre+' '+a.apaterno+' '+a.amaterno, [Nombre B] = b.nombre+' '+b.apaterno+' '+b.amaterno
	FROM ni�o a
	INNER JOIN ni�o b on b.id_ni�o != a.id_ni�o
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
