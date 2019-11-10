use bichos
go


--1) Bichos que cambian de tipo al evolucionar
select e1.id_especie, e1.bicho, e1.tipo1, e2.id_especie, e2.bicho, e2.tipo1
from especieEvolucion
	join especie e1 on e1.id_especie = especieEvolucion.id_especie_actual
	join especie e2 on e2.id_especie = especieEvolucion.id_especie_siguiente
where e1.tipo1 <> e2.tipo1 or e1.tipo2 <> e2.tipo2

--2) Seleccionar bichos que puedan sobrevivir al ataque físico más poderoso (Explosión)
select especie.bicho, especie.defensa_normal_maxima
from especie
where especie.defensa_normal_maxima > (select max(ataque.potencia)
from ataque
where ataque.categoria_ataque = 'f')

--3) Mostrar el ataque físico más poderoso posible considerando el ataque y quien realiza el ataque
select especie.bicho, ataque.nombre_ataque, (especie.ataque_normal_maximo + ataque.potencia) as 'Potencia'
from especie, ataque
where (especie.ataque_normal_maximo + ataque.potencia) = (select max(especie.ataque_normal_maximo + ataque.potencia)
from especie, ataque
where ataque.categoria_ataque = 'f')

--4) Cantidad máxima de daño especial posible.
--Considere que el ataque empleado debe ser del mismo tipo que el atacante (considerando que el atacante puede tener dos tipos)
--Y cuan eficiente es contra el tipo del bicho atacado.
--Considerando, además, las estadísticas de los bichos y el ataque.
--Considerando el bicho atacante en su nivel máximo y el bicho atacado con estadísticas base
--¿Por qué es útil para el escenario? Por cuestiones de balance del juego

--El cálculo de daño se realiza con la siguiente formula:
--(((((2 x nivel atacante) / 5) + 2) * potencia de ataque * (poder del atacante / defensa del atacado)) / 50) + 2
select e1.bicho as 'Atacante', e1.tipo1, e1.tipo2, a1.nombre_ataque, a1.id_tipo, e2.bicho as 'Atacado', (((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia) as 'Daño inflingido'
from resitenciasTipo ea
	join ataque a1 on a1.id_tipo = ea.id_tipo_ataque
	join especie e1 on a1.id_tipo = e1.tipo1 or a1.id_tipo = e1.tipo2
	join especie e2 on e2.tipo1 = ea.id_atacado or e2.tipo2 = ea.id_atacado
where a1.categoria_ataque = 'e' and (((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia) = (
select max(((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia)
	from resitenciasTipo ea
		join ataque a1 on a1.id_tipo = ea.id_tipo_ataque
		join especie e1 on a1.id_tipo = e1.tipo1 or a1.id_tipo = e1.tipo2
		join especie e2 on e2.tipo1 = ea.id_atacado or e2.tipo2 = ea.id_atacado
	where
(e2.tipo1 = ea.id_atacado or e2.tipo2 = ea.id_atacado) and a1.id_tipo = ea.id_tipo_ataque and
		(e1.tipo1 = a1.id_tipo or e1.tipo2 = a1.id_tipo) and ea.eficacia = 2 and a1.categoria_ataque = 'e')

--5)