use bichos
go

--1) Bichos que cambian de tipo al evolucionar
select e1.id_especie, e1.bicho, e1.tipo1, e2.id_especie, e2.bicho, e2.tipo1 from especieEvolucion
join especie e1 on e1.id_especie = especieEvolucion.id_especie_actual
join especie e2 on e2.id_especie = especieEvolucion.id_especie_siguiente
where e1.tipo1 <> e2.tipo1 or e1.tipo2 <> e2.tipo2

