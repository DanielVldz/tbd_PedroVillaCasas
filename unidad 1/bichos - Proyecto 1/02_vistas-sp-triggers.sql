USE bichos
GO
--Vistas del proyecto
--1)Entrenadores que han perdido
	create view entrenadoresDerrotados
	AS
	select usuario.id from combate
	left join usuario on usuario.id = combate.id_entrenador1 or usuario.id = combate.id_entrenador2
	where usuario.id <> combate.id_ganador;

--2)Bichos que están en nivel para evolucionar
	create view puedeEvolucionar
	as
	select bicho.id from bicho
	left join especie on especie.id = bicho.id_especie
	where bicho.nivel >= especie.nivel_evolucion;

--3)Entrenadores con bichos eléctricos
	create view entrenadorElectrico
	as
	select especie.especie from usuarioBicho
	left join bicho on bicho.id = usuarioBicho.id_bicho
	left join usuario on usuario.id = usuarioBicho.id_usuario
	left join especie on especie.id = bicho.id_especie
	left join tipo on tipo.id = especie.tipo1 or tipo.id = especie.tipo2
	where tipo.nombre = 'Eléctrico'

--4)Bichos que no tienen nombre asignado por su entrenador
create view sinNombre
as
select usuarioBicho.id_bicho from usuarioBicho
where usuarioBicho.nombre is null

--5)Combates donde había ventaja de tipo
create view ventajaTipo
as
select distinct combate.id_combate, e1.especie as atacante, e2.especie as atacado from combate
left join ronda on ronda.id_combate = combate.id_combate
left join bicho b1 on b1.id = ronda.id_atacante
left join bicho b2 on b2.id = ronda.id_atacado
left join especie e1 on e1.id = b1.id_especie
left join especie e2 on e2.id = b2.id_especie
left join resitenciasTipo on resitenciasTipo.id_atacado = e2.tipo1 or resitenciasTipo.id_atacado = e2.tipo2
where resitenciasTipo.eficacia > 1;

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
		JOIN especie e1 ON e1.tipo1 = a1.id_tipo OR e1.tipo2 = a1.id_tipo
		JOIN especie e2 ON e2.tipo1 = ea.id_atacado OR e2.tipo2 = ea.id_atacado
	where e1.id = @atacante and e2.id = @atacado and a1.id = @ataque
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
	SET NOCOUNT ON
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
	SELECT @aumento = (((@base * 2 * bicho.nivel) / 100) + @suma)
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
	DECLARE @base INT, @salud INT, @velocidad INT, @ataque_normal INT, @ataque_especial INT

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
	--Cálculo del ataque normal
	SELECT @base = especie.ataque_normal_base
	FROM bicho
		LEFT JOIN especie ON especie.id = bicho.id_especie
	EXEC @ataque_normal = calcularAumento @base, @bicho, 0
	--Cálculo de ataque especial
	SELECT @base = especie.ataque_especial_base
	FROM bicho
		LEFT JOIN especie ON especie.id = bicho.id_especie
	EXEC @ataque_especial = calcularAumento @base, @bicho, 0

	UPDATE bicho
	SET salud = @salud, velocidad = @velocidad, ataque_normal = @ataque_normal, ataque_especial = @ataque_especial
	WHERE bicho.id = @bicho
END
GO


--5)Evolucionar un bicho
CREATE PROCEDURE evolucionarBicho
	(@id INT)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @especieSiguiente INT

select @especieSiguiente = e1.id from especieEvolucion
left join bicho on bicho.id_especie = especieEvolucion.id_especie_actual
left join especie e1 on e1.id = especieEvolucion.id_especie_siguiente
where bicho.id = @id


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

--2)Validar que no se agregue una ronda a un combate finalizado y realizar ajuste de las estadísticas de los bichos combatientes tras el turno. Finalizar si la vida de algún bicho llega a 0
CREATE TRIGGER validarCombate
ON ronda
AFTER INSERT
AS
BEGIN
	DECLARE @ganador INT, @id INT

	SELECT @id = inserted.id_combate
	FROM inserted

	SELECT @ganador = combate.id_ganador
	FROM combate
	WHERE combate.id_combate = @id
	
	IF @ganador IS NOT NULL
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('El combate ya finalizó',16,1)
	END
END
GO

--3)Cálculos tras el combate (Llamar SP)
CREATE TRIGGER postCombate
ON combate
AFTER UPDATE
AS 
BEGIN
	DECLARE  @xpTotal INT, @nivelEvolucion INT, @nivelActual INT, @idGanador INT

	select @idGanador = ronda.id_atacante from inserted
	left join ronda on ronda.id_combate = inserted.id_combate
	where ronda.id_entrenador = inserted.id_ganador

	EXEC @xpTotal = calculoExperiencia @idGanador

	UPDATE bicho
	SET experiencia = bicho.experiencia + @xpTotal
	WHERE bicho.id = @idGanador

	IF (select bicho.experiencia from bicho where bicho.id = @idGanador) >= 1000
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

--4)Llenar los datos al insertar un nuevo bicho con valores aleatorios en rango de las estadísticas de la especie
CREATE TRIGGER crearBicho
ON capturas
AFTER INSERT
AS
BEGIN
	DECLARE @especie INT,@salud int, @ataque INT, @genero INT, @ataque_normal INT, @ataque_especial INT, @defensa_normal INT, @defensa_especial INT, @velocidad INT, @nivel int, @experiencia int
	DECLARE @generoFinal CHAR
	select @especie = inserted.id_especie from inserted
	set @genero = rand()*(2 - 1) + 1
	if @genero = 1
	begin
	set @generoFinal = 'f'
	end
	else
	begin
	set @generoFinal = 'm'
	end

	select top 1 @ataque = ataqueEspecie.id_ataque from ataqueEspecie
	where ataqueEspecie.id_especie = @especie
	order by newid()

	select @salud = rand()*((especie.salud_maxima - especie.salud_base)+especie.salud_base) ,@ataque_normal = rand()*((especie.ataque_normal_maximo - especie.ataque_normal_base) + especie.ataque_normal_base), @ataque_especial = ((especie.ataque_especial_maximo - especie.ataque_especial_base) + especie.ataque_especial_base), @defensa_normal = ((especie.defensa_normal_maxima - especie.defensa_normal_base) + especie.defensa_normal_base), @defensa_especial = ((especie.defensa_especial_maxima- especie.defensa_especial_base) + especie.defensa_especial_base), @velocidad =((especie.velocidad_maxima - especie.velocidad_base) + especie.velocidad_base), @nivel = rand()*(20 - 5) + 5, @experiencia = rand()*(500 - 50) + 50 from especie
	where especie.id = @especie

	insert into bicho(id_especie, id_ataque1, genero, salud, ataque_normal, ataque_especial, defensa_normal, defensa_especial, velocidad, nivel, experiencia)
	values(@especie,@ataque, @genero, @salud, @ataque_normal, @ataque_especial, @defensa_normal, @defensa_especial, @velocidad, @nivel, @experiencia)
	DECLARE @usuario INT, @bichoNuevo INT
	SELECT @usuario = inserted.id_usuario from inserted
	SELECT top 1 @bichoNuevo = bicho.id from bicho order by bicho.id desc
	insert into usuarioBicho(id_usuario, id_bicho) values(@usuario, @bichoNuevo) 
END
GO
--5)Realizar el cálculo del daño y determinar un ganador si un bicho llega a 0 de vida
CREATE TRIGGER calculoPostRonda
ON ronda
AFTER INSERT
AS
BEGIN
	DECLARE @especie1 INT, @especie2 INT, @ataque INT, @daño INT, @atacado INT
	select @especie1 = e1.id, @especie2 = e2.id, @ataque = inserted.id_ataque_realizado, @atacado = inserted.id_atacado from inserted
	left join especie e1 on e1.id = inserted.id_atacante
	left join especie e2 on e2.id = inserted.id_atacado
	
	Exec @daño = calculoDaño @especie1, @especie2, @ataque

	update bicho
	set bicho.salud = case
					when bicho.salud - @ataque < 0 then 0
					else bicho.salud - @ataque
					end
	where bicho.id = @atacado

	if (select bicho.salud from bicho where id = @atacado) = 0
	begin
	declare @ganador int, @combate INT
	select @ganador = inserted.id_entrenador, @combate = inserted.id_combate from inserted
		update combate
		set combate.id_ganador = @ganador
		where combate.id_combate = @combate
	end
END
GO