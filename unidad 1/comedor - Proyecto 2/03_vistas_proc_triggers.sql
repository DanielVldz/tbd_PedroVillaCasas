USE comedor
GO

--######################################################################################--
--####################################### VISTAS #######################################--
--######################################################################################--
-- 02. Niños y los alimentos con ingredientes a los que éstos puedan ser alérgicos
CREATE VIEW AlimentoAlergias
AS
SELECT a.id_alimento, Alimento = a.nombre, i.id_ingrediente, Ingrediente = i.nombre, n.id_niño, Niño = n.nombre
	FROM alimento a
	INNER JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	INNER JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	INNER JOIN niñoAlergias na on na.nombre = i.nombre
	INNER JOIN niño n on n.id_niño = na.id_niño
GO

-- 03. Niños con dieta
SELECT *
	FROM niño n
	INNER JOIN dieta d on d.id_niño = n.id_niño

SELECT TOP 1 nombre = n.nombre+' '+n.apaterno+' '+n.amaterno, count(*) as alergias
	FROM niño n
	INNER JOIN  niñoAlergias na ON na.id_niño = n.id_niño
	GROUP BY n.nombre, n.apaterno, n.amaterno
	ORDER BY alergias DESC

-- tutores con adeudos
SELECT nombre = t.nombre+' '+t.apaterno+' '+t.amaterno, SUM(a.monto)
	FROM tutor t
	INNER JOIN adeudo a ON a.id_tutor = t.id_tutor
	GROUP BY t.nombre, t.apaterno, t.amaterno

-- 10. Menu con el mayor numero de calorias
SELECT Top 1 Menu = m.nombre, Calorias = SUM(a.calorias)
	FROM menu m
	INNER JOIN menu_alimento ma on ma.id_menu = m.id_menu
	INNER JOIN alimento a on a.id_alimento = ma.id_alimento
	GROUP BY m.nombre
	ORDER BY SUM(a.calorias) DESC

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
GO

-- 5. Alimentos en cada menu
CREATE VIEW alimentosEnMenu
AS
SELECT m.id_menu, menu = m.nombre, a.id_alimento, alimento = a.nombre
	FROM menu_alimento ma
	inner join menu m on m.id_menu = ma.id_menu
	inner join alimento a on a.id_alimento = ma.id_alimento
GO

--######################################################################################--
--############################# PROCEDIMIENTOS ALMACENADOS #############################--
--######################################################################################--

-- 1. Definir alguna alergia para un niño

-- 2. Darle una dieta a un niño

-- 3. Cambiar de tutor a un niño

-- 4. Añadir un platillo a la base de datos

-- 5. Añadir articulos para comprar a la lista de compras

--######################################################################################--
--###################################### TRIGGERS ######################################--
--######################################################################################--

-- 1. Al borrar un tutor, desasignarlo de los niños que le tenian de FK

-- 2. Al hacer una comida x, una cantidad de sus ingredientes debe reducirse

-- 3. Al borrar un menu, eliminar todas sus dependencias

-- 4. Al borrar un niño, quitar todas sus dependencias

-- 5. Al borrar una dieta, quitar todas sus dependencias

-- 6. Al llegar a la fecha de esta, eliminar una lista de compras