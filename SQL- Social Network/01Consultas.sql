use social
go

select *
from sys.tables

--Seleccionar amigos de Gabriel
select H1.name
from Highschooler H1
  inner join Friend on H1.ID = Friend.ID1
  inner join Highschooler H2 on H2.ID = Friend.ID2
where H2.name = 'Gabriel';

--2 Gente que le gusta alguien dos grados menor
select H1.name, h1.grade, h2.name, h2.grade
from Highschooler H1
  inner join Likes on H1.ID = likes.ID1
  inner join Highschooler H2 on H2.ID = likes.ID2
where (h1.grade - h2.grade) >= 2

--3 Gusto mutuo
select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1, Highschooler h2, Likes l1, Likes l2
where (h1.ID = l1.ID1 and h2.ID = l1.ID2) and (h2.ID = l2.ID1 and h1.ID = l2.ID2) and h1.name < h2.name

--4 Friendzone
SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
WHERE H1.ID = L1.ID1 AND H2.ID = L1.ID2 AND (H2.ID = L2.ID1 AND H3.ID = L2.ID2 AND H3.ID <> H1.ID);

--5 need more intel
select h1.name, h1.grade
from Highschooler h1
  left join Likes l1 on l1.ID1 = h1.ID
  left join Likes l2 on l2.ID2 = h1.ID
where l1.ID1 is null and l2.ID2 is null
order by h1.grade, h1.name

--6 no sabemos quien le gusta
select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1
inner join Likes on h1.id = Likes.ID1
inner join Highschooler h2 on h2.ID = Likes.ID2
where (h1.ID = likes.ID1 and h2.ID = Likes.ID2) and h2.ID not in(
  select distinct ID1
  from Likes
)

--7 mente cerrada
select h1.name, h1.grade
from Highschooler h1
where h1.id not in(
  select ID1
  from friend, Highschooler h2
  where h1.id = friend.ID1 and h2.ID = Friend.ID2 and h1.grade <> h2.grade
)

--8 mente abierta

--9 me gusta tu amiga jsjsjs

-- Highschooler(ID, name, grade)
-- Friend(ID1, ID2)
-- Likes(ID1, ID2)

select *
from Highschooler
select *
from Friend
select *
from Likes


