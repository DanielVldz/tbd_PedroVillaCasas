USE comedor
GO


insert into tutor(nombre, apaterno, amaterno, lugar_de_trabajo, telefono_trabajo, telefono_celular) values
	('Guillermo', 'Gonzales', 'Carrazco', 'Carnicería Don Beni',   11111111, 10101010),
	('Maria',	  'Angulo',   'Cevilla',  'Tiendita Doña Mary',    22222222, 20202020),
	('Augusto',	  'Alvarado', 'Jimenez',  'Refaccionaria Jimenez', 33333333, 30303030),
	('Antonia',   'Quintero', 'Zazueta',  'Ama de casa',		   44444444, 40404040)

insert into niño(nombre, apaterno, amaterno, nivel, grado, id_tutor, fecha_de_nacimiento) values
	('Jorge',		'Martinez',  'Aispuro',  2, 'A', 1, '20070102'),
	('Luis',		'Mezquillo', 'Almendra',  6, 'A', 1, '20010622'),
	('Fernando',	'Salazar',   'Salazar',   3, 'B', 2, '20070312'),
	('Jose',		'Martinez',  'Gonzales',  2, 'A', 1, '20070102'),
	('Lucho',		'Mezquillo', 'Almendra',  6, 'A', 1, '20010622'),
	('Martin',		'Moringa',   'Salazar',   3, 'B', 2, '20070312'),
	('Hernesto',	'Angulo',    'Gonzales',  1, 'A', 2, '20091130'),
	('Hector',		'Hernandez', 'Gamez',	  5, 'B', 2, '20070102'),
	('Amalia',		'Lazcano',	 'Santillan', 2, 'A', 3, '20080715'),

	('Marco',		'Gonzales',  'Almendra',  2, 'A', 1, '20070102'),
	('Leticia',		'Gonzales',  'Almendra',  6, 'A', 1, '20010622'),
	('Jesus',		'Angulo',    'Salazar',   3, 'B', 2, '20070312'),
	('Gonzalo',		'Angulo',    'Salazar',   1, 'A', 2, '20091130'),
	('Ariel',		'Hernandez', 'Santillan', 5, 'B', 2, '20070102'),
	('Joaquin',		'Alvarado',  'Mendez',    2, 'A', 3, '20080715'),
	('Mario',		'Alvarado',  'Patiño',    3, 'A', 3, '20070102'),
	('Norma',		'Quintero',  'Felix',     4, 'B', 4, '20070805'),
	('Leslie',		'Quintero',  'Felix',     2, 'B', 4, '20070417'),
	('Luis',		'Quintero',  'Felix',     3, 'A', 4, '20070623')
update dbo.niño set especial = 1 where id_niño = 5

insert into niñoAlergias(id_niño, nombre) values
	(5, 'Brocoli'),
	(5, 'Rabano'),
	(5, 'Ajonjolí'),
	(10, 'Naranja')

insert into adeudo(id_tutor, monto, fecha_ultimo_abono) values
	(1, 500, '2019-06-13'),
	(2, 200, '20190705'),
	(3, 150, '20190613'),
	(3, 400, '20190705'),
	(3, 50,  '20190705')


insert into menu(nombre, fecha_inicio, fecha_final) values
	('Menu verde', '20190808', '20190815'),
	('Menu rojo', '20190816', '20190823')

insert into alimento(nombre, tipo, calorias, carbohidratos, proteinas, grasas) values
	('Leche de soja',		'Bebida', 127,	12.08,	10.98,	4.7),
	('Albondigas',			'Comida', 57,	2.12,	3.47,	3.69),
	('Ensalada de huevo',	'Comida', 706,	4.28,	20.42,	67.18),
	('3 Enchiladas Suizas', 'Comida', 500,	52.9,	25,		11),
	('Caldo Tlalpeño',		'Comida', 318,	31,		21,		13),
	('Pay de limón',	    'Postre', 230,	28,		7,		10),
	('Helado de limón',		'Postre', 301,	46,		4,		13),
	('Licuado de frutas',	'Bebida', 130,	33.52,	0.88,	0.29),
	('Jugo de Manzana',		'Bebida', 117,	28.97,	0.15,	0.27),
	('Jugo de Naranja',		'Bebida', 100,	30,		0.5,	0.5)

insert into menu_alimento(id_menu, id_alimento) values
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 5),
	(1, 8),
	(1, 9),
	(2, 1),
	(2, 2),
	(2, 4),
	(2, 6),
	(2, 7),
	(2, 8),
	(2, 10)

insert into ingrediente(nombre, caducidad, existencias) values
	('Carne de res',	'20200120', 50),
	('Cebolla',			'20191201', 5),
	('Maiz',			'20191215', 10),
	('Chile seco rojo',	'20191201', 3),
	('Arroz',			'20200101', 50),
	('Limón',			'20191201', 15),
	('Huevos',			'20191211', 300),
	('Leche de soja',	'20191205', 100),
	('Manzana',			'20191201', 20),
	('Plátano',			'20191121', 30),
	('Pera',			'20191130', 15),
	('Papaya',			'20191201', 30),
	('Cilantro',		'20191111', 5),
	('Ajo',				'20200215', 5),
	('Lechuga romana',	'20191125', 15),
	('Queso fresco',	'20191215', 15),
	('Queso chihuahua',	'20200315', 20),
	('Rabano',			'20200105', 15),
	('Brocoli',			'20191115', 5),
	('Harina',			'20191215',	15),
	('Naranja',			'20191215',	30)

insert into alimento_ingrediente(id_alimento, id_ingrediente) values
	(1, 9),
	(2, 1),
	(2, 2),
	(2, 5),
	(2, 13),
	(2, 14),
	(2, 19),
	(3, 3),
	(3, 6),
	(3, 7),
	(3, 15),
	(3, 16),
	(4, 1),
	(4, 2),
	(4, 4),
	(4, 6),
	(4, 15),
	(4, 18),
	(4, 16),
	(4, 17),
	(5, 1),
	(5, 2),
	(5, 3),
	(5, 4),
	(5, 5),
	(6, 6),
	(6, 7),
	(6, 8),
	(6, 20),
	(7, 6),
	(7, 7),
	(7, 8),
	(8, 8),
	(8, 9),
	(8, 10),
	(8, 11),
	(8, 12),
	(9, 9),
	(10, 21)

insert into dieta(id_niño, fecha_inicio, fecha_fin) values
	(3, '20190815', '20191220')

insert into alimento_dieta(id_alimento, id_dieta) values
	(1, 1),
	(3, 1),
	(5, 1),
	(8, 1),
	(9, 1)

insert into listaDeCompras(fecha) values
	('20191220')

insert into ingrediente_listaDeCompras(id_ingrediente, id_lista) values
	(1, 1),
	(4, 1),
	(2, 1),
	(8, 1),
	(15, 1),
	(13, 1),
	(17, 1)

select * from tutor
select * from niño
select * from niñoAlergias
select * from adeudo
select * from menu
select * from alimento
select ma.id_menu, m.nombre, ma.id_alimento, a.nombre from menu_alimento ma
	inner join menu m on m.id_menu = ma.id_menu
	inner join alimento a on a.id_alimento = ma.id_alimento
select * from ingrediente
select ai.id_alimento, a.nombre, ai.id_ingrediente, i.nombre from alimento_ingrediente ai
	inner join alimento a on a.id_alimento = ai.id_alimento
	inner join ingrediente i on i.id_ingrediente = ai.id_ingrediente
select * from dieta
select ad.id_alimento, a.nombre, 'dieta' = ad.id_dieta, niño = n.nombre+' '+n.apaterno+' '+n.amaterno, d.id_niño from alimento_dieta ad
	inner join alimento a on a.id_alimento = ad.id_alimento
	inner join dieta d on d.id_dieta = ad.id_dieta
	inner join niño n on d.id_niño = n.id_niño