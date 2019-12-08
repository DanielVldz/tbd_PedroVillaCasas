USE comedor
GO

--######################################################################################--
--####################################### VISTAS #######################################--
--######################################################################################--
-- 1. Niños y los alimentos con ingredientes a los que éstos puedan ser alérgicos
CREATE VIEW ViewAlimentoAlergias
AS
SELECT a.id_alimento, Alimento = a.nombre, i.id_ingrediente, Ingrediente = i.nombre, n.id_niño, Niño = n.nombre
	FROM alimento a
	INNER JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	INNER JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	INNER JOIN niñoAlergias na on na.nombre = i.nombre
	INNER JOIN niño n on n.id_niño = na.id_niño
GO

-- 2. Niños con dieta
CREATE VIEW ViewNiñoDieta
AS
SELECT n.id_niño, niño = n.nombre, d.id_dieta, d.fecha_inicio, d.fecha_fin
	FROM niño n
	INNER JOIN dieta d on d.id_niño = n.id_niño
GO

-- 3. Niños y cuantas alergias tiene cada uno
CREATE VIEW ViewNiñoAlergias
AS
SELECT n.id_niño, niño = n.nombre+' '+n.apaterno+' '+n.amaterno, count(*) as alergias
	FROM niño n
	INNER JOIN  niñoAlergias na ON na.id_niño = n.id_niño
	GROUP BY n.id_niño, n.nombre, n.apaterno, n.amaterno
GO

-- 4. Tutores con adeudos
CREATE VIEW ViewTutorDeuda
AS
SELECT Tutor = t.nombre+' '+t.apaterno+' '+t.amaterno, deudaTotal = SUM(a.monto)
	FROM tutor t
	INNER JOIN adeudo a ON a.id_tutor = t.id_tutor
	GROUP BY t.nombre, t.apaterno, t.amaterno
GO

-- 5. Contenido nutricional total por cada menu
CREATE VIEW ViewMenuContenidoNutricional
AS
SELECT Menu = m.nombre, Calorias = SUM(a.calorias), Carbohidratos = SUM(a.carbohidratos), Grasas = SUM(a.grasas), Proteinas = SUM(a.proteinas)
	FROM menu m
	INNER JOIN menu_alimento ma on ma.id_menu = m.id_menu
	INNER JOIN alimento a on a.id_alimento = ma.id_alimento
	GROUP BY m.nombre
GO

-- 6. Menus que tienen alimentos con ingredientes a los que algún niño es alérgico
SELECT Menu = m.nombre, n.id_niño, Niño = n.nombre+' '+n.apaterno+' '+n.amaterno, a.id_alimento,
		Alimento = a.nombre, i.id_ingrediente, [Ingrediente de la alergia] = i.nombre
	FROM menu m
	INNER JOIN menu_alimento ma on ma.id_menu = m.id_menu
	INNER JOIN alimento a on a.id_alimento = ma.id_alimento
	INNER JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	INNER JOIN ingrediente i on i.id_ingrediente = ai.id_ingrediente
	INNER JOIN niñoAlergias na on na.nombre = i.nombre
	JOIN niño n on n.id_niño = na.id_niño
GO

-- 7. Alimentos en cada menu
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