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
SELECT n.id_niño, n.nombre, n.apaterno, n.amaterno, n.nivel, n.grado, n.id_tutor, n.fecha_de_nacimiento, alergia = Count(na.nombre)
	FROM niño n
	INNER JOIN  niñoAlergias na ON na.id_niño = n.id_niño
	group by n.id_niño, n.nombre, n.apaterno, n.amaterno, n.nivel, n.grado, n.id_tutor, n.fecha_de_nacimiento
GO

-- Formulario niño
CREATE VIEW ViewNiñoFormulario
AS
SELECT n.id_niño, n.nombre, n.apaterno, n.amaterno, n.nivel, n.grado, n.id_tutor, n.fecha_de_nacimiento,
  tutorNombre = t.nombre, tutorApaterno = t.apaterno, tutorAmaterno = t.amaterno
	FROM niño n
	JOIN tutor t on t.id_tutor = n.id_tutor
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

-- tutor con su adeudo total
CREATE VIEW ViewTutorFormulario
AS
SELECT t.id_tutor, t.nombre, t.apaterno, t.amaterno, t.lugar_de_trabajo, t.telefono_celular, t.telefono_trabajo, adeudo = SUM(a.monto)
	FROM tutor t
	JOIN adeudo a on a.id_tutor = t.id_tutor
	GROUP BY t.id_tutor, t.nombre, t.apaterno, t.amaterno, t.lugar_de_trabajo, t.telefono_celular, t.telefono_trabajo
GO
--######################################################################################--
--############################# PROCEDIMIENTOS ALMACENADOS #############################--
--######################################################################################--
-- alergias niño, concatenadas
select nombre, apaterno, amaterno from niño
select i.nombre, ai.cantidad
	from ingrediente i
	JOIN alimento_ingrediente ai on ai.id_ingrediente = i.id_ingrediente
	JOIN alimento a on ai.id_alimento = a.id_alimento
GO
CREATE PROCEDURE devuelveIDTutor
	@nom NVARCHAR(30),
	@apa NVARCHAR(30),
	@ama NVARCHAR(30),
	@id  INT OUTPUT
AS
	SELECT @id = id_tutor FROM tutor WHERE nombre = @nom AND apaterno = @apa AND amaterno = @ama
GO
/*
declare @menus NVARCHAR(200)
exec menuNiñoConcatenadas 'Marco', 'Gonzales', 'Almendra', @menus OUTPUT
SELECT @menus
*/
-- alergias niño, concatenadas
CREATE PROCEDURE alergiasNiñoConcatenadas
	@nom NVARCHAR(30),
	@apa NVARCHAR(30),
	@ama NVARCHAR(30),
	@alergias NVARCHAR(200) OUTPUT
AS 
	SELECT @alergias = ''

	SELECT @alergias+= na.nombre + ' '
		from niño n
		JOIN niñoAlergias na on n.id_niño = na.id_niño
		WHERE n.nombre = @nom AND n.apaterno = @apa AND n.amaterno = @ama
	
	IF @alergias = ''
	BEGIN
		SELECT @alergias = 'Sin alergias'
	END
GO
/*
declare @alergias NVARCHAR(200) 
exec alergiasNiñoConcatenadas 'Lucho', 'Mezquillo', 'Almendra', @alergias OUTPUT 
SELECT @alergias
*/

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
/*
EXEC insertarAlergiaAUnNiño 'cebolla', 6
SELECT * FROM niñoAlergias WHERE id_niño = 6
GO
*/
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
/*
EXEC insertarDietaAUnNiño 6, '20191219', '20200115'
SELECT * FROM dieta WHERE id_niño = 6
GO
*/
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
/*
EXEC cambiarTutor 4, 6
SELECT id_niño, id_tutor from niño where id_niño = 6
GO
*/
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
/*
EXEC añadirAlimento 'Chocolate caliente', 'Bebida', 100, 30, 20, 10
SELECT * FROM alimento WHERE nombre = 'Chocolate caliente'
GO
*/
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
/*
EXEC añadirIngrediente 'Chocolate', 20200318
UPDATE ingrediente SET existencias = 50 where nombre = 'chocolate'
SELECT * from ingrediente WHERE nombre = 'chocolate'
GO
*/
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
/*
EXEC añadirIngredienteAUnAlimento 8, 11, 2
EXEC añadirIngredienteAUnAlimento 22, 11, 2
SELECT alimento = a.nombre, a.tipo, ingrediente = i.nombre, ai.cantidad
	FROM alimento a
	JOIN alimento_ingrediente ai on ai.id_alimento = a.id_alimento
	JOIN ingrediente i ON i.id_ingrediente = ai.id_ingrediente
	WHERE a.id_alimento = 11
GO
*/
-- 7. Hacer albondigas, sólo si hay suficientes ingredientes para ello
CREATE PROCEDURE hacerAlbondigas
	@porciones int = 1
AS
	-- ID de los distintos ingredientes a usar
	DECLARE @carne INT = 1, @cebolla INT = 2, @arroz INT = 5, @cilantro INT = 13, @ajo INT = 14, @brocoli INT = 19;
	DECLARE @id_albondigas INT
	SELECT @id_albondigas = id_alimento FROM alimento WHERE nombre = 'albondigas'

	IF 1*@porciones > (SELECT existencias FROM ingrediente WHERE id_ingrediente = @carne)
	BEGIN
		PRINT 'No hay suficiente carne para '+CONVERT(VARCHAR(8), @porciones)+' porciones de albondigas'
		RETURN
	END
	IF 2*@porciones > (SELECT existencias FROM ingrediente WHERE id_ingrediente = @cebolla)
	BEGIN
		PRINT 'No hay suficiente cebolla para '+CONVERT(VARCHAR(8), @porciones)+' porciones de albondigas'
		RETURN
	END
	IF 3*@porciones > (SELECT existencias FROM ingrediente WHERE id_ingrediente = @arroz)
	BEGIN
		PRINT 'No hay suficiente arroz para '+CONVERT(VARCHAR(8), @porciones)+' porciones de albondigas'
		RETURN
	END
	IF 4*@porciones > (SELECT existencias FROM ingrediente WHERE id_ingrediente = @cilantro)
	BEGIN
		PRINT 'No hay suficiente cilantro para '+CONVERT(VARCHAR(8), @porciones)+' porciones de albondigas'
		RETURN
	END
	IF 2*@porciones > (SELECT existencias FROM ingrediente WHERE id_ingrediente = @ajo)
	BEGIN
		PRINT 'No hay suficiente ajo para '+CONVERT(VARCHAR(8), @porciones)+' porciones de albondigas'
		RETURN
	END
	IF 4*@porciones > (SELECT existencias FROM ingrediente WHERE id_ingrediente = @brocoli)
	BEGIN
		PRINT 'No hay suficiente brocoli para '+CONVERT(VARCHAR(8), @porciones)+' porciones de albondigas'
		RETURN
	END

	UPDATE ingrediente SET existencias-= 1*@porciones WHERE id_ingrediente = @carne
	UPDATE ingrediente SET existencias-= 2*@porciones WHERE id_ingrediente = @cebolla
	UPDATE ingrediente SET existencias-= 3*@porciones WHERE id_ingrediente = @arroz
	UPDATE ingrediente SET existencias-= 4*@porciones WHERE id_ingrediente = @cilantro
	UPDATE ingrediente SET existencias-= 2*@porciones WHERE id_ingrediente = @ajo
	UPDATE ingrediente SET existencias-= 4*@porciones WHERE id_ingrediente = @brocoli
	
	UPDATE alimento SET porcionesDisponibles+= @porciones WHERE id_alimento = @id_albondigas
GO
/*
EXEC hacerAlbondigas 3
SELECT * FROM alimento WHERE nombre = 'albondigas'
SELECT nombre, existencias FROM ingrediente WHERE id_ingrediente = 1 OR id_ingrediente = 2 OR id_ingrediente = 5 OR id_ingrediente = 13 OR id_ingrediente = 14 OR id_ingrediente = 19
GO
*/
--######################################################################################--
--###################################### TRIGGERS ######################################--
--######################################################################################--
-- 1. Al borrar un tutor, dar de baja a los niños que le tenian de FK
CREATE TRIGGER TR_borrarTutor
ON tutor
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @id_tutor int
	SELECT @id_tutor = d.id_tutor FROM deleted d

	WHILE 0 < (SELECT COUNT(*) FROM niño WHERE id_tutor = @id_tutor)
		DELETE FROM niño WHERE id_tutor = @id_tutor
	RAISERROR ('niños dependientes del tutor eliminados correctamente', 10, 1)
	DELETE FROM adeudo WHERE id_tutor = @id_tutor
	RAISERROR ('adeudos del tutor eliminados', 10, 1)
	DELETE FROM tutor WHERE id_tutor = @id_tutor
	RAISERROR ('tutor eliminado', 10, 1)
END	
GO
/*
DELETE FROM tutor WHERE id_tutor = 3
SELECT * FROM niñoAlergias
SELECT * FROM niño where id_tutor = 3
SELECT * FROM tutor
GO
*/
-- 2. Al actualizar un alimento, verificar que este no quede en negativos
CREATE TRIGGER TR_ReducirCantidadDeAlimento
ON alimento
FOR UPDATE
AS
BEGIN
	DECLARE @id_alimento int
	SELECT @id_alimento = i.id_alimento FROM inserted i

	IF 0 > (SELECT porcionesDisponibles FROM inserted)
	BEGIN
		RAISERROR ('No hay suficiente alimento como para solicitar tantos platillos', 10, 1)
		ROLLBACK TRAN
		RETURN
	END
	RAISERROR ('alimento actualizado', 10, 1)
END
GO
/*
UPDATE alimento SET porcionesDisponibles-=1 WHERE nombre = 'Albondigas'
SELECT * from alimento WHERE nombre = 'albondigas'
GO
*/

-- 3. Al borrar un menu, eliminar todas sus dependencias
CREATE TRIGGER TR_BorrarMenu
ON menu
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @id_menu int;
	SELECT @id_menu = d.id_menu from deleted d

	DELETE FROM niñoMenu WHERE id_menu = @id_menu
	RAISERROR ('eliminadas las relaciones entre este menu y los niños', 10, 1)
	DELETE FROM menu_alimento WHERE id_menu = @id_menu
	RAISERROR ('alimentos enlistados en el menu eliminados', 10, 1)
	DELETE FROM menu WHERE id_menu = @id_menu
	RAISERROR ('menu borrado', 10, 1)
END
GO
/*
DELETE FROM menu WHERE nombre = 'Menu verde'
SELECT * from menu
GO
*/
-- 4. Al borrar un niño, quitar todas sus dependencias
CREATE TRIGGER TR_BorrarNiño
ON niño
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @id_niño int
	SELECT @id_niño = d.id_niño
		FROM deleted d
	DELETE FROM niñoMenu WHERE id_niño = @id_niño
	RAISERROR ('eliminadas las relaciones entre este niño y sus menus', 10, 1)
	DELETE FROM niñoAlergias WHERE id_niño = @id_niño
	RAISERROR ('alergias del niño eliminadas', 10, 1)
	WHILE 0 < (SELECT COUNT(*) FROM dieta WHERE id_niño = @id_niño)
		DELETE FROM dieta WHERE id_niño = @id_niño
	RAISERROR ('dietas eliminadas correctamente', 10, 1)
	DELETE FROM niño WHERE id_niño = @id_niño
	RAISERROR ('niño dado de baja', 10, 1)
END
GO
/*
DELETE FROM niño WHERE id_niño = 1
SELECT * FROM dieta
SELECT * FROM niñoAlergias
SELECT * FROM niño
GO
*/
-- 5. Al borrar una dieta, quitar todas sus dependencias
CREATE TRIGGER TR_BorrarDieta
ON dieta
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @id_dieta int
	SELECT @id_dieta = d.id_dieta FROM deleted d

	DELETE FROM alimento_dieta WHERE id_dieta = @id_dieta
	RAISERROR ('alimentos de dieta eliminados', 10, 1)
	DELETE FROM dieta WHERE id_dieta = @id_dieta
	RAISERROR ('dieta eliminada', 10, 1)
END
GO
/*
DELETE FROM dieta WHERE id_dieta = 1
SELECT * FROM dieta
SELECT * FROM alimento_Dieta
GO
*/
-- 6. Verifica que no exista un alimento con el nombre de un alimento que se quiere introducir a la base de datos
CREATE TRIGGER TR_InsertarAlimento
ON alimento
FOR INSERT
AS
BEGIN
	DECLARE @nombre NVARCHAR(30)
	SELECT @nombre = nombre FROM inserted
	IF 0 < (SELECT COUNT(*) FROM alimento WHERE nombre = @nombre)
	BEGIN
		ROLLBACK TRAN
		RAISERROR ('Ese alimento ya existe en la base de datos, se cancela la operación.', 10, 1)
		RETURN
	END
END
GO

-- 7. Verifica que no exista un menu con el nombre con el que se quiere introducir otro nuevo
CREATE TRIGGER TR_InsertarMenu
ON menu
FOR INSERT
AS
BEGIN
	DECLARE @nombre NVARCHAR(30)
	SELECT @nombre = nombre FROM inserted
	IF 0 < (SELECT COUNT(*) FROM menu WHERE nombre = @nombre)
	BEGIN
		ROLLBACK TRAN
		RAISERROR ('Ese menu ya existe en la base de datos, se cancela la operación.', 10, 1)
		RETURN
	END
END
GO

-- 8. Igual que las dos anteriores, pero para ingredientes
CREATE TRIGGER TR_InsertarIngrediente 
ON ingrediente
FOR INSERT
AS
BEGIN
	DECLARE @nombre NVARCHAR(30)
	SELECT @nombre = nombre FROM inserted
	IF 0 < (SELECT COUNT(*) FROM ingrediente WHERE nombre = @nombre)
	BEGIN
		ROLLBACK TRAN
		RAISERROR ('Ese ingrediente ya existe en la base de datos, se cancela la operación.', 10, 1)
		RETURN
	END
END
GO