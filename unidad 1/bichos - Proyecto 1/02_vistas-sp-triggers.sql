USE bichos
GO
--Vistas del proyecto
--1)Ataques que un bicho puede aprender
--2)
--3)
--4)
--5)

--Procedimientos almacenados
--1)Cálculo del daño del ataque y la salud restante del atacado
CREATE PROCEDURE calculoDaño
	(@atacante INT,
	@atacado INT,
	@ataque INT)
AS
BEGIN
	SET NOCOUNT ON
	SELECT (((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia) AS 'Daño inflingido'
	FROM resitenciasTipo ea
		JOIN ataque a1 ON a1.id_tipo = ea.id_tipo_ataque
		JOIN especie e1 ON a1.id_tipo = e1.tipo1 OR a1.id_tipo = e1.tipo2
		JOIN especie e2 ON e2.tipo1 = ea.id_atacado OR e2.tipo2 = ea.id_atacado
	WHERE e1 = @atacante AND e2 = @atacado AND a1 = @ataque
END
GO
--2)Cálculo de la experiencia adquirida en combate
--(6/5)n^3 - 15n^2 + 100n - 140 -> Dónde n es el nivel actual
CREATE PROCEDURE calculoExperiencia
	(@bicho INT)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @xp INT
	SELECT @xp = ((6/5) * POWER(bicho.nivel, 3) - 15 * POWER(bicho.nivel, 2) + 100 * bicho.nivel - 140)
	FROM bicho
	WHERE bicho.id = @bicho
	RETURN @xp
END
GO
--3)Formula de aumento de estadísticas
CREATE PROCEDURE calcularAumento
	(@base INT,
	@bicho INT,
	@esSalud BIT)
AS
BEGIN
	SET NONCOUNT ON
	DECLARE @suma INT, @aumento INT
	IF(@esSalud = 1)
BEGIN
		SELECT @suma = (bicho.nivel + 10)
		FROM bicho
		WHERE bicho.id = @bicho
	END
ELSE
BEGIN
		SET @suma = 5
	END
	SELECT @aumtento = (((@base * 2 * bicho.nivel) / 100) + @suma)
	FROM bicho
	WHERE bicho.id = @bicho
	RETURN @aumento
END
GO

--4)Aumentar estadísticas al subir de nivel (Llamado desde el trigger 4)
CREATE PROCEDURE aumentarEstadisticas
	(@bicho INT)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @base INT, @salud INT, @velocidad INT, @ataque INT

	--Cálculo de la salud
	SELECT @base = especie.salud_base
	FROM bicho
		LEFT JOIN especie ON especie.id = bicho.id_especie
	EXEC @salud = calcularAumento @base, @bicho, 1
	--Cálculo de la velocidad
	SELECT @base = especie.velocidad_base
	FROM bicho
		LEFT JOIN especie ON especie.id = bicho.id_especie
	EXEC @velocidad = calcularAumento @base, @bicho, 0
	--Cálculo del ataque
	SELECT @base = especie.ataque_base
	FROM bicho
		LEFT JOIN especie ON especie.id = bicho.id_especie
	EXEC @ataque = calcularAumento @base, @bicho, 0

	UPDATE bicho
	SET salud = @salud, velocidad = @velocidad, ataque = @ataque
	WHERE bicho.id = @bicho
END
GO

--5)Evolucionar un bicho
CREATE PROCEDURE evolucionarBicho
	(@id INT)
AS
BEGIN
	SET NONCOUNT ON

	DECLARE @especieSiguiente INT
	SELECT @especieSiguiente = especieEvolucion.id_especie_siguiente
	FROM bicho
		LEFT JOIN especie ON especie.id = bicho.id
		LEFT JOIN especieEvolucion ON especieEvolucion.id_especie_actual = especie.id
	WHERE bicho.id = @id

	UPDATE bicho
	SET bicho.id_especie = @especieSiguiente
	WHERE bicho.id = @id
END
GO

--Triggers
--1)Cambios de las tablas usuarioBicho al hacer intercambio
CREATE TRIGGER actualizarBichos
ON intercambio
AFTER INSERT
AS
	BEGIN
	SET NOCOUNT ON
	DECLARE @id1 INT, @id2 INT, @bicho1 INT, @bicho2 INT
	SELECT @id1 = id_entrenador1, @id2 = id_entrenador2, @bicho1 = id_bicho1, @bicho2 = id_bicho2
	FROM inserted

	UPDATE usuarioBicho
	SET id_usuario = @id2
	WHERE id_bicho = @bicho1

	UPDATE usuarioBicho
	SET id_usuario = @id1
	WHERE id_bicho = @bicho2
END
GO

--2)Validar que a un bicho se le enseña un ataque de los que su especie puede aprender

--3)Cálculos tras el combate (Llamar SP)
CREATE TRIGGER postCombate
ON combate
AFTER INSERT
AS 
BEGIN
	DECLARE @idGanador INT, @xpTotal INT, @nivelEvolucion INT, @nivelActual INT
	IF id_entrenador1 = id_ganador
	BEGIN
		SET @idGanador = id_bicho1
	END
	ELSE
	BEGIN
		SET @idGanador = id_bicho2
	END

	EXEC @xpTotal = calculoExperiencia @idGanador

	UPDATE bicho
	SET experiencia = bicho.experiencia + @xpTotal
	WHERE bicho.id = @idGanador

	IF bicho.experiencia >= 1000
	BEGIN
		UPDATE bicho
		SET bicho.experiencia = 0, bicho.nivel = (bicho.nivel + 1)
		WHERE bicho.id = @idGanador

		SELECT @nivelActual = bicho.nivel, @nivelEvolucion = especie.nivel_evolucion
		FROM bicho
			LEFT JOIN especie ON especie.id = bicho.id_especie
		WHERE bicho.id = @idGanador

		IF @nivelActual >= @nivelEvolucion
		BEGIN
			EXEC evolucionarBicho @idGanador
		END
	END
END
GO

--4)

--5)Validar que el intercambio se realice con bichos pertenecientes a los entrenadores involucrados en el intercambio
CREATE TRIGGER validarIntercambio
ON intercambio
AFTER INSERT
AS
BEGIN
	DECLARE @bicho1 INT, @bicho2 INT, @entrenador1 INT, @entrenador2 INT

	SELECT @entrenador1 = id_entrenador1, @entrenador2 = id_entrenador2, @bicho1 = id_bicho1, @bicho2 = id_bicho2
	FROM inserted
	IF NOT EXISTS (SELECT *
		FROM usuarioBicho
		WHERE id_usuario = @entrenador1 AND id_bicho = @bicho1) AND NOT EXISTS (SELECT *
		FROM usuarioBicho
		WHERE id_usuario = @entrenador2 AND id_bicho = @bicho2)
	BEGIN
		DELETE FROM intercambio WHERE intercambio.id_intercambio = inserted.id_intercambio
	END
END
GO