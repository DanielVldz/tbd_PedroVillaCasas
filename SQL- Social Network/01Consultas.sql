use social
go

select *
from sys.tables

--1 Seleccionar amigos de Gabriel
select "Amigos" = H1.name
from Highschooler H1
	inner join Friend on H1.ID = Friend.ID1
	inner join Highschooler H2 on H2.ID = Friend.ID2
where H2.name = 'Gabriel';

--2 Gente que le gusta alguien dos grados menor
select "Enamorado" = H1.name,
	"Grado" = h1.grade,
	"Menor" = h2.name,
	"Grado" = h2.grade
from Highschooler H1
	inner join Likes on H1.ID = likes.ID1
	inner join Highschooler H2 on H2.ID = likes.ID2
where (h1.grade - h2.grade) >= 2

--3 Gusto mutuo
select "Enamorado 1" = h1.name,
	"Grado" = h1.grade,
	"Enamorado 2" = h2.name,
	"Grado" = h2.grade
from Highschooler h1, Highschooler h2, Likes l1, Likes l2
where (h1.ID = l1.ID1 and h2.ID = l1.ID2) and (h2.ID = l2.ID1 and h1.ID = l2.ID2) and h1.name < h2.name

--4 Friendzone
SELECT "Enamorado" = H1.name,
	"Grado" = H1.grade,
	"Rompecorazones" = H2.name,
	"Grado" = H2.grade,
	"Tercero" = H3.name,
	"Grado" = H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
WHERE H1.ID = L1.ID1 AND H2.ID = L1.ID2 AND (H2.ID = L2.ID1 AND H3.ID = L2.ID2 AND H3.ID <> H1.ID);

--5 need more intel
	select "Nombre" = h1.name,
		"Grado" = h1.grade
	from Highschooler h1
		left join Likes l1 on l1.ID1 = h1.ID or l1.ID2 = h1.ID
except
	select "Nombre" = h1.name,
		"Grado" = h1.grade
	from Highschooler h1
		right join Likes l1 on l1.ID1 = h1.ID or l1.ID2 = h1.ID
order by h1.grade, h1.name

-- sin except
select "Nombre" = h1.name,
	"Grado" = h1.grade
from Highschooler h1
	left join Likes l1 on l1.ID1 = h1.ID or l1.ID2 = h1.ID
where l1.ID1 is null
order by h1.grade, h1.name

--6 no sabemos quien le gusta
select "Enamorado" = h1.name,
	"Grado" = h1.grade,
	"Oportunidad de ligue" = h2.name,
	"Grado" = h2.grade
from Highschooler h1
	inner join Likes on h1.id = Likes.ID1
	inner join Highschooler h2 on h2.ID = Likes.ID2
where (h1.ID = likes.ID1 and h2.ID = Likes.ID2) and h2.ID not in(
  select distinct ID1
	from Likes
)

--7 mente cerrada
select "Estudiante" = h1.name,
	"Grado" = h1.grade
from Highschooler h1
where h1.id not in(
  select ID1
from friend, Highschooler h2
where h1.id = friend.ID1 and h2.ID = Friend.ID2 and h1.grade <> h2.grade
)

--8 mente abierta
select "Estudiante" = h1.name,
	"Grado" = h1.grade
from Highschooler h1
where h1.id not in(
  select ID1
from friend, Highschooler h2
where h1.id = friend.ID1 and h2.ID = Friend.ID2 and h1.grade = h2.grade
)

--9 me gusta tu amiga jsjsjs
select "Enamorado" = h1.name,
	"Grado" = h1.grade,
	"Tercero" = h2.name,
	"Grado" = h2.grade,
	"Amistad en com�n" = h3.name,
	"Grado" = h3.grade
from Highschooler h1
	inner join Likes l on l.ID1 = h1.ID
	inner join Highschooler h2 on h2.ID = l.ID2
	inner join Highschooler h3 on (1=1) -- sombadiseeeeeeeeifmiiiiiiii
	inner join Friend fAC on fAC.ID1 = h1.ID and fAC.ID2 = h3.ID
	inner join Friend fBC on fBC.ID1 = h2.ID and fBC.ID2 = h3.ID
where h1.id not in(
  select ID1
from friend
where h1.id = ID1 and h2.ID = ID2
)

--10 duplicados
select "numero de alumnos" = count(*),
	"numero de nombres" = count(distinct name),
	"diferencia (nombres repetidos)" = count(*) - count(distinct name)
from Highschooler

--11 promedio de amigos
select avg(cast(amigos as float))
-- se castea a float porque entero no daba decimal
from (
	select ID1,
		count(ID2) as amigos
	from Friend
	group by ID1) hola
-- lo �ltimo seg�n yo es para darle nombre a la tabla que genera el select dentro del from

--12 circulo social
declare @IDCassandra int = (
	-- para obtener el id de cassandra (1709)
	select ID
from Highschooler
where name = 'cassandra'
);
declare @amigosDeCassandra int = (
	-- para obtener los amigos de cassandra (2)
	select count(*)
from Friend
where ID1 = @IDCassandra
);
declare @amigosDeAmigosDeCassandra int = (
	-- para obtener los amigos de los amigos de cassandra (5)
	select count(idAmigo)
from (
		-- para obtener los id de los amigos de cassandra (1689 y 1247)
		select ID1 as idAmigo
	from Friend
	where ID2 = @IDCassandra) amigo
	inner join Friend f on f.ID1 = amigo.idAmigo and f.ID2 <> @IDCassandra
);
select "Amigos de Cassandra" = @amigosDeCassandra, "Amigos de amigos de Cassandra" = @amigosDeAmigosDeCassandra

--13 los guaperris
declare @numeroDeEnamoradosMayor int = (
	-- para obtener el valor de enamorados m�s grande que hay (2)
	select count(*)
from Likes
where ID2 = 1709 -- no s� como hacerlo, es el id de Cassandra :c
);
select "Nombre" = name, "Grado" = grade, "Enamorados" = @numeroDeEnamoradosMayor
from Highschooler
where @numeroDeEnamoradosMayor = (
		-- para saber si tiene de enamorados el valor @numeroDeEnamoradosMayor
		select count(*)
from Likes
where ID2 = ID
	)

--14 m�s populares, mucho compa tienen estos vatos
declare @numeroDeAmigosMayor int = max(
	-- para obtener el valor de enamorados m�s grande que hay (4)
	4 -- al chile no supe hacerlo :'c
);

select "Nombre" = name, "Grado" = grade, "Amigos" = @numeroDeAmigosMayor
from Highschooler
where @numeroDeAmigosMayor = (
		-- para saber si tiene de amigos el valor @numeroDeEnamoradosMayor
		select count(*)
from Friend
where ID2 = ID
	)

--15 fin del año escolar
update Highschooler
set grade = grade + 1

--16 graduación
delete from Highschooler where grade > 12

--17 Friendship ended with the grads, now undergrads are my best friends 
delete from Friend where ID1 not in (select ID
	from Highschooler) and ID2 not in (select ID
	from Highschooler);
delete from Likes where ID1 not in (select ID
	from Highschooler) and ID2 not in (select ID
	from Highschooler);
select H2.name
from Highschooler H1, Friend, Highschooler H2
where H1.name = 'Austin' and H1.ID = Friend.ID1 and H2.ID = Friend.ID2

--18 Verano pagado, verano pasado
insert into Friend(ID1, ID2)
	select f1.ID, f3.ID2
	from Highschooler f1
	left join Friend f2 on f1.ID = f2.ID1
	left join Friend f3 on f2.ID2 = f3.ID1
	where f1.ID not in(
		select ID1
		from Friend
		where ID2 = f3.ID2 or ID1 = f3.ID2
	)
select H2.name
from Highschooler H1, Friend, Highschooler H2
where H1.name = 'Jordan' and H1.ID = Friend.ID1 and H2.ID = Friend.ID2

-- Highschooler(ID, name, grade)
-- Friend(ID1, ID2)
-- Likes(ID1, ID2)

select *
from Highschooler
select *
from Friend
select *
from Likes


