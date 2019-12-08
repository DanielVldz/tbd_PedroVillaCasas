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
CREATE VIEW ViewMenuAlergias
AS
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
CREATE VIEW ViewAlimentosEnMenu
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
CREATE PROCEDURE insertarAlergiaAUnNiño
	@ingrediente NVARCHAR(15) = NULL,
	@id_niño INT = NULL
AS
	IF @ingrediente IS NULL OR @id_niño IS NULL
	BEGIN
		PRINT 'Alguno de los valores está vacío'
		RETURN
	END
	IF 0 in (SELECT COUNT(*) FROM ingrediente WHERE nombre = @ingrediente)
	BEGIN
		PRINT 'El ingrediente "'+@ingrediente+'" no existe'
		RETURN
	END
	IF 0 in (SELECT COUNT(*) FROM niño WHERE id_niño = @id_niño)
	BEGIN
		PRINT 'El id "'+CONVERT(VARCHAR(8), @id_niño)+'" de niño introducido no existe'
		RETURN
	END

	-- si llegó hasta acá, todo bien
	INSERT INTO niñoAlergias(id_niño, nombre) VALUES (@id_niño, @ingrediente)
GO
EXEC insertarAlergiaAUnNiño 'cebolla', 6
SELECT * FROM niñoAlergias WHERE id_niño = 6
GO


-- 2. Darle una dieta a un niño
CREATE PROCEDURE insertarDietaAUnNiño
	@id_niño INT = NULL,
	@fecha_inicio NVARCHAR(30) = NULL,
	@fecha_fin NVARCHAR(30)  = NULL
AS
	IF @fecha_inicio IS NULL OR @fecha_fin IS NULL OR @id_niño IS NULL
	BEGIN
		PRINT 'Alguno de los valores está vacío'
		RETURN
	END
	
	IF ISDATE(@fecha_inicio) = 0
	BEGIN
		PRINT 'La fecha "'+@fecha_inicio+'" de inicio introducida es incorrecta'
		RETURN
	END
	IF ISDATE(@fecha_fin) = 0
	BEGIN
		PRINT 'La fecha "'+@fecha_fin+'" de fin introducida es incorrecta'
		RETURN
	END
	IF 0 in (SELECT COUNT(*) FROM niño WHERE id_niño = @id_niño)
	BEGIN
		PRINT 'El id "'+CONVERT(VARCHAR(8), @id_niño)+'" de niño introducido no existe'
		RETURN
	END

	-- si llegó hasta acá, todo bien
	INSERT INTO dieta(id_niño, fecha_inicio, fecha_fin) VALUES (@id_niño, @fecha_inicio, @fecha_fin)
GO
EXEC insertarDietaAUnNiño 6, '20191219', '20200115'
SELECT * FROM dieta WHERE id_niño = 6
GO


-- 3. Cambiar de tutor a un niño
CREATE PROCEDURE cambiarTutor
	@id_tutor INT = NULL,
	@id_niño INT = NULL
AS
	IF @id_tutor IS NULL OR @id_niño IS NULL
	BEGIN
		PRINT 'Alguno de los valores está vacío'
		RETURN
	END

	IF 0 in (SELECT COUNT(*) FROM tutor WHERE id_tutor = @id_tutor)
	BEGIN
		PRINT 'El id "'+CONVERT(VARCHAR(8), @id_tutor)+'" de tutor introducido no existe'
		RETURN
	END
	IF 0 in (SELECT COUNT(*) FROM niño WHERE id_niño = @id_niño)
	BEGIN
		PRINT 'El id "'+CONVERT(VARCHAR(8), @id_niño)+'" de niño introducido no existe'
		RETURN
	END

	-- si llegó hasta acá, todo bien
	UPDATE niño SET id_tutor = @id_tutor WHERE id_niño = @id_niño
GO
EXEC cambiarTutor 4, 6
SELECT id_niño, id_tutor from niño where id_niño = 6
GO

-- 4. Añadir un platillo a la base de datos
CREATE PROCEDURE añadirAlimento
	@nombre NVARCHAR(20) = NULL,
	@tipo NVARCHAR(10) = NULL,
	@calorias NUMERIC = NULL,
	@carbohidratos NUMERIC = NULL,
	@proteinas NUMERIC = NULL,
	@grasas NUMERIC = NULL
AS
	IF @nombre IS NULL OR @tipo IS NULL OR @calorias IS NULL OR @carbohidratos IS NULL OR @proteinas IS NULL OR @grasas IS NULL
	BEGIN
		PRINT 'Alguno de los valores está vacío'
		RETURN
	END

	IF 0 < (SELECT COUNT(*) FROM alimento WHERE nombre = @nombre)
	BEGIN
		PRINT 'El alimento "'+@nombre+'" que quiso introducir ya existe en la base de datos.'
		RETURN
	END
	IF @tipo NOT LIKE 'Bebida' AND @tipo NOT LIKE 'Postre' AND @tipo NOT LIKE 'Comida'
	BEGIN
		PRINT 'El tipo "'+@tipo+'" de alimento no es válido. Debe ser comida, postre o bebida.'
		RETURN
	END

	-- si llegó hasta acá, todo bien
	INSERT INTO alimento(nombre, tipo, calorias, carbohidratos, proteinas, grasas) VALUES (@nombre, @tipo, @calorias, @carbohidratos, @proteinas, @grasas)
GO
EXEC añadirAlimento 'Chocolate caliente', 'Bebida', 100, 30, 20, 10
SELECT * FROM alimento WHERE nombre = 'Chocolate caliente'
GO

-- 5. Añadir un ingrediente a la base de datos
CREATE PROCEDURE añadirIngrediente
	@ingrediente NVARCHAR(15) = NULL,
	@caducidad VARCHAR(30) = NULL,
	@existencias int = 0
AS
	IF @ingrediente IS NULL
	BEGIN
		PRINT 'Alguno de los valores está vacío'
		RETURN
	END

	IF 0 < (SELECT COUNT(*) FROM ingrediente WHERE nombre = @ingrediente)
	BEGIN
		PRINT 'El ingrediente "'+@ingrediente+'" introducido ya existe en la base de datos'
		RETURN
	END
	IF ISDATE(@caducidad) = 0
	BEGIN
		PRINT 'La fecha "'+@caducidad+'" de caducidad introducida es incorrecta'
		RETURN
	END

	-- si llegó hasta acá, todo bien
	INSERT INTO ingrediente(nombre, caducidad, existencias) VALUES (@ingrediente, @caducidad, @existencias)
GO
EXEC añadirIngrediente 'Chocolate', 20200318
UPDATE ingrediente SET existencias = 50 where nombre = 'chocolate'
SELECT * from ingrediente WHERE nombre = 'chocolate'
GO

-- 6. Añadir ingredientes a un alimento
CREATE PROCEDURE añadirIngredienteAUnAlimento
	@id_ingrediente INT = NULL,
	@id_alimento INT = NULL,
	@cantidad INT = NULL
AS
	IF @id_ingrediente IS NULL OR @id_alimento IS NULL or @cantidad IS NULL
	BEGIN
		PRINT 'Alguno de los valores está vacío'
		RETURN
	END

	IF 0 in (SELECT COUNT(*) FROM ingrediente WHERE id_ingrediente = @id_ingrediente)
	BEGIN
		PRINT 'El id "'+CONVERT(VARCHAR(8), @id_ingrediente)+'" de ingrediente introducido no existe'
		RETURN
	END
	IF 0 in (SELECT COUNT(*) FROM alimento WHERE id_alimento = @id_alimento)
	BEGIN
		PRINT 'El id "'+CONVERT(VARCHAR(8), @id_alimento)+'" de alimento introducido no existe'
		RETURN
	END
	IF 0 > @cantidad
	BEGIN
		PRINT 'La cantidad introducida es negativa, los valores negativos no son válidos'
		RETURN
	END

	-- si llegó hasta acá, todo bien
	INSERT INTO alimento_ingrediente(id_alimento, id_ingrediente, cantidad) VALUES (@id_alimento, @id_ingrediente, @cantidad)
GO
EXEC añadirIngredienteAUnAlimento 8, 11, 2
EXEC añadirIngredienteAUnAlimento 22, 11, 2
SELECT alimento = a.nombre, a.tipo, ingrediente = i.nombre, ai.cantidad
	FROM alimento a
	JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	JOIN ingrediente i ON i.id_ingrediente = ai.id_ingrediente
	WHERE a.id_alimento = 11
GO

--######################################################################################--
--###################################### TRIGGERS ######################################--
--######################################################################################--
-- 1. Al borrar un tutor, desasignarlo de los niños que le tenian de FK

-- 2. Al hacer una comida x, una cantidad de sus ingredientes debe reducirse

-- 3. Al borrar un menu, eliminar todas sus dependencias

-- 4. Al borrar un niño, quitar todas sus dependencias

-- 5. Al borrar una dieta, quitar todas sus dependencias

-- 6. Al llegar a la fecha de esta, eliminar una lista de compras