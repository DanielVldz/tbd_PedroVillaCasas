create database bichos
go
use bichos
GO

--use northwind
--drop database bichos

create table usuario
(
	id_usuario int identity not null primary key,
	nombre nvarchar(30) not null
)
go

create table tipo
(
	id_tipo int identity not null primary key,
	nombre nvarchar(20) not null
)
go

create table especie
(
	id_especie int identity not null primary key,
	bicho nvarchar(30) not null,
	descripcion nvarchar(250),
	tipo1 int not null,
	tipo2 int,
	nivel_evolucion int,
	ratio_captura int,
	salud_base int not null,
	ataque_normal_base int not null,
	defensa_normal_base int not null,
	ataque_especial_base int not null,
	defensa_especial_base int not null,
	velocidad_base int not null,
	salud_maxima int not null,
	ataque_normal_maximo int not null,
	defensa_normal_maxima int not null,
	ataque_especial_maximo int not null,
	defensa_especial_maxima int not null,
	velocidad_maxima int not null,
	foreign key(tipo1) references tipo(id_tipo),
	foreign key(tipo2) references tipo(id_tipo),
)
go
create table ataque
(
	id_ataque int identity not null primary key,
	nombre_ataque nvarchar(20),
	categoria_ataque char(1) not null,
	potencia int not null,
	id_tipo int not null,
	foreign key(id_tipo) references tipo(id_tipo)
)
go

create table ataqueEspecie
(
	id_ataque int not null,
	id_especie int not null,
	foreign key(id_ataque) references ataque(id_ataque),
	foreign key(id_especie) references especie(id_especie),
	primary key(id_ataque, id_especie)
)
go

create table bicho
(
	id_bicho int identity not null primary key,
	id_especie int not null,
	id_ataque1 int not null,
	id_ataque2 int,
	id_ataque3 int,
	id_ataque4 int,
	foreign key(id_especie) references especie(id_especie),
	foreign key(id_ataque1) references ataque(id_ataque),
	foreign key(id_ataque2) references ataque(id_ataque),
	foreign key(id_ataque3) references ataque(id_ataque),
	foreign key(id_ataque4) references ataque(id_ataque)
)
go

create table usuarioBicho
(
	id_bicho int identity not null primary key,
	id_usuario int not null,
	salud int not null,
	nombre nvarchar(20),
	experiencia int not null,
	latitud_Captura decimal not null,
	longitud_Captura decimal not null,
	foreign key(id_usuario) references usuario(id_usuario),
	foreign key(id_bicho) references bicho(id_bicho)
)
go

create table intercambio
(
	id_intercambio int identity not null primary key,
	id_entrenador1 int not null,
	id_entrenador2 int not null,
	id_bicho1 int not null,
	id_bicho2 int not null,
	foreign key(id_entrenador1) references usuario(id_usuario),
	foreign key(id_entrenador2) references usuario(id_usuario),
	foreign key(id_bicho1) references bicho(id_bicho),
	foreign key(id_bicho2) references bicho(id_bicho)
)
go

create table combate
(
	id_combate int identity not null primary key,
	id_entrenador1 int not null,
	id_entrenador2 int not null,
	id_bicho1 int not null,
	id_bicho2 int not null,
	id_ganador int not null,
	foreign key(id_entrenador1) references usuario(id_usuario),
	foreign key(id_entrenador2) references usuario(id_usuario),
	foreign key(id_bicho1) references bicho(id_bicho),
	foreign key(id_bicho2) references bicho(id_bicho),
	foreign key(id_ganador) references usuario(id_usuario),
)
go

create table resitenciasTipo
(
	id_tipo_ataque int not null,
	eficacia float not null,
	id_atacado int not null,
	foreign key(id_tipo_ataque) references tipo(id_tipo),
	foreign key(id_atacado) references tipo(id_tipo),
	primary key(id_tipo_ataque, id_atacado)
)
go

create table especieEvolucion
(
	id_especie_actual int not null,
	id_especie_siguiente int not null,
	foreign key(id_especie_actual) references especie(id_especie),
	foreign key(id_especie_siguiente) references especie(id_especie),
	primary key(id_especie_actual, id_especie_siguiente)
)
go

select * from ataque
select * from tipo
select * from especie
select * from resitenciasTipo

set identity_insert bichos.dbo.especie off
set identity_insert bichos.dbo.tipo on
go
INSERT INTO tipo(id_tipo, nombre) VALUES(1,'Acero');
INSERT INTO tipo(id_tipo, nombre) VALUES(2,'Agua');
INSERT INTO tipo(id_tipo, nombre) VALUES(3,'Bicho');
INSERT INTO tipo(id_tipo, nombre) VALUES(4,'Dragón');
INSERT INTO tipo(id_tipo, nombre) VALUES(5,'Eléctrico');
INSERT INTO tipo(id_tipo, nombre) VALUES(6,'Fantasma');
INSERT INTO tipo(id_tipo, nombre) VALUES(7,'Fuego');
INSERT INTO tipo(id_tipo, nombre) VALUES(8,'Hada');
INSERT INTO tipo(id_tipo, nombre) VALUES(9,'Hielo');
INSERT INTO tipo(id_tipo, nombre) VALUES(10,'Lucha');
INSERT INTO tipo(id_tipo, nombre) VALUES(11,'Normal');
INSERT INTO tipo(id_tipo, nombre) VALUES(12,'Planta');
INSERT INTO tipo(id_tipo, nombre) VALUES(13,'Psíquico');
INSERT INTO tipo(id_tipo, nombre) VALUES(14,'Roca');
INSERT INTO tipo(id_tipo, nombre) VALUES(15,'Siniestro');
INSERT INTO tipo(id_tipo, nombre) VALUES(16,'Tierra');
INSERT INTO tipo(id_tipo, nombre) VALUES(17,'Veneno');
INSERT INTO tipo(id_tipo, nombre) VALUES(18,'Volador');
set identity_insert bichos.dbo.tipo OFF
go

set identity_insert bichos.dbo.ataque on
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(1,'Burbuja','e',40,2);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(2,'Cascada','f',80,2);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(3,'Hidrobomba','e',110,2);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(4,'Martillazo','f',100,2);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(5,'Pistola agua','e',40,2);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(6,'Rayo burbuja','e',65,2);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(7,'Surf','e',90,2);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(8,'Tenaza','f',35,2);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(9,'Chupavidas','f',80,3);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(10,'Doble ataque','f',25,3);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(11,'Pin misil','f',25,3);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(12,'Impactrueno','e',40,5);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(13,'Puño trueno','f',75,5);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(14,'Rayo','e',90,5);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(15,'Trueno','e',110,5);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(16,'Lengüetazo','f',30,6);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(17,'Ascuas','e',40,7);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(18,'Giro fuego','e',35,7);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(19,'Lanzallamas','e',90,7);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(20,'Llamarada','e',110,7);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(21,'Puño fuego','f',75,7);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(22,'Puño hielo','f',75,9);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(23,'Rayo aurora','e',65,9);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(24,'Rayo hielo','e',90,9);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(25,'Ventisca','e',110,9);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(26,'Doble patada','f',30,10);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(27,'Patada giro','f',60,10);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(28,'Patada salto','f',100,10);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(29,'Patada salto alta','f',130,10);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(30,'Sumisión','f',80,10);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(31,'Agarre','f',55,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(32,'Arañazo','f',40,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(33,'Atadura','f',15,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(34,'Ataque furia','f',15,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(35,'Ataque rápido','f',40,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(36,'Autodestrucción','f',200,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(37,'Bomba huevo','f',100,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(38,'Cabezazo','f',130,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(39,'Clavo cañón','f',20,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(40,'Cornada','f',65,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(41,'Corte','f',50,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(42,'Cuchillada','f',70,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(43,'Derribo','f',90,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(44,'Destructor','f',40,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(45,'Día de pago','f',40,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(46,'Doble filo','f',120,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(47,'Doblebofetón','f',15,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(48,'Explosión','f',250,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(49,'Fuerza','f',80,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(50,'Furia','f',20,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(51,'Golpe','f',120,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(52,'Golpe cabeza','f',70,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(53,'Golpe cuerpo','f',85,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(54,'Golpe kárate ','f',50,10);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(55,'Golpes furia','f',18,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(56,'Hiper colmillo','f',80,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(57,'Hiperrayo','e',150,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(58,'Megapatada','f',120,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(59,'Megapuño','f',80,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(60,'Mordisco ','f',60,15);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(61,'Pisotón','f',65,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(62,'Placaje','f',40,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(63,'Atizar','f',80,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(64,'Presa','f',15,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(65,'Puño cometa','f',18,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(66,'Puño mareo','f',70,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(67,'Rapidez','e',60,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(68,'Constricción','f',15,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(69,'Restricción','f',10,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(70,'Tornado ','e',40,18);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(71,'Triataque','e',80,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(72,'Viento cortante','e',80,11);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(73,'Absorber','e',20,12);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(74,'Danza pétalo','e',120,12);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(75,'Hoja afilada','f',55,12);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(76,'Látigo cepa','f',45,12);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(77,'Megaagotar','e',40,12);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(78,'Rayo solar','e',120,12);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(79,'Come sueños','e',100,13);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(80,'Confusión','e',50,13);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(81,'Psicorrayo','e',65,13);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(82,'Psíquico','e',90,13);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(83,'Avalancha','f',75,14);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(84,'Lanzarrocas','f',50,14);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(85,'Excavar','f',80,16);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(86,'Hueso palo','f',65,16);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(87,'Huesomerang','f',50,16);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(88,'Terremoto','f',100,16);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(89,'Ácido','e',40,17);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(90,'Picotazo venenoso','f',15,17);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(91,'Polución','e',30,17);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(92,'Residuos','e',65,17);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(93,'Ataque aéreo','f',140,18);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(94,'Ataque ala','f',60,18);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(95,'Pico taladro','f',80,18);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(96,'Picotazo','f',35,18);
INSERT INTO ataque(id_ataque, nombre_ataque, categoria_ataque, potencia, id_tipo) VALUES(97,'Vuelo','f',90,18);
set identity_insert ataque off
go

set identity_insert bichos.dbo.especie on
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(1,'Bulbasaur',' Este Pokémon nace con una semilla en el lomo. Con el tiempo, la semilla brota.',12,17,16,45, 45, 49, 49, 65, 65, 45, 294, 197, 197, 229, 229, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(2,'Ivysaur',' Este Pokémon tiene un bulbo en el lomo. Dicen que, al absorber nutrientes, el bulbo se transforma en una flor grande.',12,17,32,45, 60, 62, 63, 80, 80, 60, 324, 223, 225, 259, 259, 219);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(3,'Venusaur',' La flor que tiene en el lomo libera un delicado aroma. En combate, este aroma tiene un efecto relajante.',12,17,null,45, 80, 82, 83, 100, 100, 80, 364, 263, 265, 299, 299, 259);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(4,'Charmander',' Este Pokémon nace con una llama en la punta de la cola. Si la llama se apagara, el Pokémon se debilitaría.',7,null,16,45, 39, 52, 43, 60, 50, 65, 282, 203, 185, 219, 199, 229);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(5,'Charmeleon',' Suele usar la cola para derribar a su rival. Cuando lo tira, se vale de sus afiladas garras para acabar con él.',7,null,null,45, 58, 64, 58, 80, 65, 80, 320, 227, 215, 259, 229, 259);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(6,'Charizard',' Con las alas que tiene puede alcanzar una altura de casi 1.400 m. Suele escupir fuego por la boca.',7,18,36,45, 78, 84, 78, 109, 85, 100, 360, 267, 255, 317, 269, 299);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(7,'Squirtle',' Cuando se esconde en el caparazón, dispara agua a una presión increíble.',2,null,16,45, 44, 48, 65, 50, 64, 43, 292, 195, 229, 199, 227, 185);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(8,'Wartortle',' Es el Pokémon que se suele tener como mascota. La cola tan larga y peluda que posee simboliza lo longevo que es.',2,null,36,45, 59, 63, 80, 65, 80, 58, 322, 225, 259, 229, 259, 215);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(9,'Blastoise',' Para acabar con su enemigo, lo aplasta con el peso de su cuerpo. En momentos de apuro, se esconde en el caparazón.',2,null,null,45, 79, 83, 100, 85, 105, 78, 362, 265, 299, 269, 309, 255);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(10,'Caterpie',' Tiene la piel de color verde. Cuando la muda, se recubre de seda y se convierte en capullo.',3,null,7,255, 45, 30, 35, 20, 20, 45, 294, 159, 169, 139, 139, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(11,'Metapod',' Aunque tiene una coraza muy dura, el cuerpo del Pokémon es blando. Un ataque violento puede acabar con él.',3,null,10,120, 50, 20, 55, 25, 25, 30, 304, 139, 209, 149, 149, 159);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(12,'Butterfree',' Tiene las alas protegidas con una capa impermeable, de ahí que pueda volar también cuando llueve.',3,18,null,45, 60, 45, 50, 90, 80, 70, 324, 189, 199, 279, 259, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(13,'Weedle',' Suele habitar bosques y praderas. Tiene un afilado y venenoso aguijón de unos 5 cm encima de la cabeza.',3,17,7,255, 40, 35, 30, 20, 20, 50, 284, 169, 159, 139, 139, 199);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(14,'Kakuna',' Este Pokémon permanece inmóvil mientras desarrolla internamente su organismo. Es prácticamente incapaz de moverse solo.',3,17,10,120, 45, 25, 50, 25, 25, 35, 294, 149, 199, 149, 149, 169);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(15,'Beedrill',' Puede aparecer en enjambres volando a gran velocidad. Suele usar el venenoso aguijón inferior para atacar.',3,17,null,45, 65, 90, 40, 45, 80, 75, 334, 279, 179, 189, 259, 249);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(16,'Pidgey',' A este Pokémon no le gusta luchar. Suele permanecer escondido en zonas de hierba alta. Se alimenta de pequeños insectos.',11,18,18,255, 40, 45, 40, 35, 35, 56, 284, 189, 179, 169, 169, 211);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(17,'Pidgeotto',' Tiene unas garras desarrolladas. Puede atrapar un Exeggcute y transportarlo desde una distancia de casi 100 km.',11,18,36,120, 63, 60, 55, 50, 50, 71, 330, 219, 209, 199, 199, 241);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(18,'Pidgeot',' Para intimidar a su enemigo, extiende las increíbles alas que tiene. Este Pokémon vuela a una velocidad increíble.',11,18,null,45, 83, 80, 75, 70, 70, 101, 370, 259, 249, 239, 239, 301);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(19,'Rattata',' Tiene unos largos y afilados colmillos que no dejan de crecer. Le resultan muy útiles para destruir cosas.',11,null,20,255, 30, 56, 35, 25, 35, 72, 264, 211, 169, 149, 169, 243);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(20,'Raticate',' Cada pata trasera tiene tres dedos palmeados que le permiten nadar por los ríos.',11,null,null,127, 55, 81, 60, 50, 70, 97, 314, 261, 219, 199, 239, 293);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(21,'Spearow',' Va siempre revoloteando de aquí para allá. Aunque frágil, puede ser un duro rival cuando usa Movimiento espejo.',11,18,20,255, 40, 60, 30, 31, 31, 70, 284, 219, 159, 161, 161, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(22,'Fearow',' Gracias a sus espléndidas alas puede alcanzar una gran altura y volar durante un día entero sin tener que parar.',11,18,null,90, 65, 90, 65, 61, 61, 100, 334, 279, 229, 221, 221, 299);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(23,'Ekans',' Es fácil encontrarlo en praderas y zonas similares. A este Pokémon le basta con sacar la lengua para detectar el peligro.',17,null,22,255, 35, 60, 44, 40, 54, 55, 274, 219, 187, 179, 207, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(24,'Arbok',' El dibujo que tiene en la panza aterroriza. Los rivales más débiles salen huyendo al verlo.',17,null,null,90, 60, 95, 69, 65, 79, 80, 324, 289, 237, 229, 257, 259);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(25,'Pikachu',' Las bolsas de las mejillas están llenas de electricidad, que libera cuando se siente amenazado.',5,null,null,190, 35, 55, 40, 50, 50, 90, 274, 209, 179, 199, 199, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(26,'Raichu',' Suelta descargas eléctricas de hasta 100.000 voltios, con lo que es capaz de derribar al mayor de los Pokémon.',5,null,null,75, 60, 90, 55, 90, 80, 110, 324, 279, 209, 279, 259, 319);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(27,'Sandshrew',' Este Pokémon permanece bajo tierra. Si se siente amenazado, se enrosca para defenderse.',16,null,22,255, 50, 75, 85, 20, 30, 40, 304, 249, 269, 139, 159, 179);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(28,'Sandslash',' Suele hacerse una bola y rodar a toda velocidad al tiempo que va clavándole las púas y las garras al enemigo.',16,null,null,90, 75, 100, 110, 45, 55, 65, 354, 299, 319, 189, 209, 229);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(29,'Nidoran♀',' No es grande, pero tampoco inofensivo. Las tóxicas púas que tiene son peligrosas. La hembra tiene cuernos pequeños.',17,null,16,235, 55, 47, 52, 40, 40, 41, 314, 193, 203, 179, 179, 181);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(30,'Nidorina',' Las hembras tienen una agradable temperatura. Emiten ondas ultrasónicas para confundir al enemigo.',17,null,null,120, 70, 62, 67, 55, 55, 56, 344, 223, 233, 209, 209, 211);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(31,'Nidoqueen',' Está protegido por duras escamas. Cuando está nervioso, las usa para defenderse.',17,16,null,45, 90, 92, 87, 75, 85, 76, 384, 283, 273, 249, 269, 251);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(32,'Nidoran♂',' Cambia la orientación de las grandes orejas que tiene para oír mejor. Si se enfada, sus venenosos cuernos crecen.',17,null,16,235, 46, 57, 40, 40, 40, 50, 296, 213, 179, 179, 179, 199);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(33,'Nidorino',' Se enfada con facilidad y es capaz de romper un diamante con el potente cuerpo que tiene.',17,null,null,120, 61, 72, 57, 55, 55, 65, 326, 243, 213, 209, 209, 229);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(34,'Nidoking',' Es fácil reconocerlo por tener una dura piel y un gran cuerno lleno de peligrosísimo veneno.',17,16,null,45, 81, 102, 77, 85, 75, 85, 366, 303, 253, 269, 249, 269);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(35,'Clefairy',' Es una de las mascotas preferidas de todo el mundo por el aspecto tan dulce que tiene. Pero no es fácil dar con él.',8,null,null,150, 70, 45, 48, 60, 65, 35, 344, 189, 195, 219, 229, 169);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(36,'Clefable',' Tiene un agudísimo sentido del oído. Es capaz de oír la caída de un alfiler a 1km de distancia.',8,null,null,25, 95, 70, 73, 95, 90, 60, 394, 239, 245, 289, 279, 219);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(37,'Vulpix',' De pequeño, tiene seis colas increíbles. A medida que crece, le van saliendo más.',7,null,null,190, 38, 41, 40, 50, 65, 65, 280, 181, 179, 199, 229, 229);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(38,'Ninetales',' Tiene nueve colas y un pelaje de color dorado. Dicen que este Pokémon llega a vivir 1000 años.',7,null,null,75, 73, 76, 75, 81, 100, 100, 350, 251, 249, 261, 299, 299);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(39,'Jigglypuff',' Cautiva con la mirada a su enemigo y hace que se quede profundamente dormido mientras entona una dulce melodía.',11,8,null,170, 115, 45, 20, 45, 25, 20, 434, 189, 139, 189, 149, 139);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(40,'Wigglytuff',' Tiene un pelaje excepcional, muy fino, pero tupido y suave. Resulta único y llamativo.',11,8,null,50, 140, 70, 45, 85, 50, 45, 484, 239, 189, 269, 199, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(41,'Zubat',' No tiene ojos. Se guía por las ondas ultrasónicas que emite. El eco le indica por dónde tiene que ir en la oscuridad.',17,18,22,255, 40, 45, 35, 30, 40, 55, 284, 189, 169, 159, 179, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(42,'Golbat',' Se lanza sobre su presa con los afilados colmillos que tiene y puede chuparle hasta 300 cc de sangre de una vez.',17,18,null,90, 75, 80, 70, 65, 75, 90, 354, 259, 239, 229, 249, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(43,'Oddish',' Su nombre científico es Oddium Wanderus. Dicen que usa las raíces para desplazarse. Llega a hacerse 300 m.',12,17,21,255, 45, 50, 55, 75, 65, 30, 294, 199, 209, 249, 229, 159);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(44,'Gloom',' Libera un fétido olor por los pistilos. El fuerte hedor acaba con cualquier rival que se encuentre a 2 km de distancia.',12,17,null,120, 60, 65, 70, 85, 75, 40, 324, 229, 239, 269, 249, 179);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(45,'Vileplume',' Tiene unos pétalos inmensos. Libera con la mejor sonrisa un polen que provoca agudos ataques de alergia.',12,17,null,45, 75, 80, 85, 110, 90, 50, 354, 259, 269, 319, 279, 199);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(46,'Paras',' Lleva en el lomo dos setas parásitas llamadas tochukaso, que crecen con él.',3,12,24,190, 35, 70, 55, 45, 55, 25, 274, 239, 209, 189, 209, 149);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(47,'Parasect',' Libera esporas tóxicas a través de la seta que lo cubre. En China, las esporas se usan como remedios medicinales.',3,12,null,75, 60, 95, 80, 60, 80, 30, 324, 289, 259, 219, 259, 159);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(48,'Venonat',' Los ojos le funcionan como radar. Gracias a ellos puede moverse en la oscuridad y disparar potentes rayos.',3,17,31,190, 60, 55, 50, 40, 55, 45, 324, 209, 199, 179, 209, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(49,'Venomoth',' Tiene alas cubiertas de un polvillo de escamas que esparce cada vez que las bate.',3,17,null,75, 70, 65, 60, 90, 75, 90, 344, 229, 219, 279, 249, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(50,'Diglett',' Este Pokémon se entierra a gran profundidad, pero como levanta tierra al cavar, es fácil localizarlo.',16,null,26,255, 10, 55, 25, 35, 45, 95, 224, 209, 149, 169, 189, 289);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(51,'Dugtrio',' En combate, cava la tierra, se esconde y sale de repente para golpear a su rival. Nunca se sabe por dónde puede aparecer.',16,null,null,50, 35, 100, 50, 50, 70, 120, 274, 299, 199, 199, 239, 339);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(52,'Meowth',' Durante el día se dedica a dormir, y de noche vigila su territorio. Tiene unos ojos muy sensibles a todo lo que brilla.',11,null,28,255, 40, 45, 35, 40, 40, 90, 284, 189, 169, 179, 179, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(53,'Persian',' Tiene un carácter muy fuerte. Cuando va a propinar un golpe y morder al rival, suele estirar y levantar la cola.',11,null,null,90, 65, 70, 60, 65, 65, 115, 334, 239, 219, 229, 229, 329);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(54,'Psyduck',' Padece continuamente dolores de cabeza. Cuando son muy fuertes, empieza a usar misteriosos poderes.',2,null,33,190, 50, 52, 48, 65, 50, 55, 304, 203, 195, 229, 199, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(55,'Golduck',' Las patas traseras palmípedas le permiten nadar. Es común verlo chapotear con estilo en lagos y otras zonas acuáticas.',2,null,null,75, 80, 82, 78, 95, 80, 85, 364, 263, 255, 289, 259, 269);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(56,'Mankey',' Es muy ligero y ágil, y también violento. Cuando se enfada, no hay quien controle el estado de furia en el que entra.',10,null,28,190, 40, 80, 35, 35, 45, 70, 284, 259, 169, 169, 189, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(57,'Primeape',' Siempre está tremendamente enfadado. Cuando se empeña en una presa, no hay distancia para él.',10,null,null,75, 65, 105, 60, 60, 70, 95, 334, 309, 219, 219, 239, 289);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(58,'Growlithe',' Es muy agradable y leal. Para ahuyentar al enemigo, se pone a ladrar y a dar bocados.',7,null,null,190, 55, 70, 45, 70, 50, 60, 314, 239, 189, 239, 199, 219);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(59,'Arcanine',' Las leyendas chinas hablan de este Pokémon. Se dice que es capaz de correr a velocidades inimaginables.',7,null,null,75, 90, 110, 80, 100, 80, 95, 384, 319, 259, 299, 259, 289);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(60,'Poliwag',' Tiene una piel extraordinaria, fina y húmeda, que deja entrever las vísceras que tiene dispuestas en espiral.',2,null,25,255, 40, 50, 40, 40, 40, 90, 284, 199, 179, 179, 179, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(61,'Poliwhirl',' Tiene unas extremidades inferiores muy desarrolladas. Aunque puede vivir en tierra, prefiere el medio acuático.',2,null,null,120, 65, 65, 65, 50, 50, 90, 334, 229, 229, 199, 199, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(62,'Poliwrath',' Es un nadador nato. Sabe nadar a crol y a mariposa entre otros estilos, y es más rápido que los nadadores profesionales.',2,10,null,45, 90, 95, 95, 70, 90, 70, 384, 289, 289, 239, 279, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(63,'Abra',' Duerme 18 horas al día y mientras lo hace es capaz de usar una serie de poderes extrasensoriales.',13,null,16,200, 25, 20, 15, 105, 55, 90, 254, 139, 129, 309, 209, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(64,'Kadabra',' Cuentan que una mañana, un niño que tenía poderes extrasensoriales, se despertó convertido en Kadabra.',13,null,null,100, 40, 35, 30, 120, 70, 105, 284, 169, 159, 339, 239, 309);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(65,'Alakazam',' No le gustan los ataques físicos. Este Pokémon prefiere hacer uso de sus poderes extrasensoriales cuando lucha.',13,null,null,50, 55, 50, 45, 135, 95, 120, 314, 199, 189, 369, 289, 339);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(66,'Machop',' Es una masa de músculos y, aunque es pequeño, tiene fuerza de sobra para tomar en brazos a 100 personas.',10,null,28,180, 70, 80, 50, 35, 35, 35, 344, 259, 199, 169, 169, 169);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(67,'Machoke',' Tiene una complexión tan fuerte que nunca se cansa. Suele ayudar a la gente a cargar objetos pesados.',10,null,null,90, 80, 100, 70, 50, 60, 45, 364, 299, 239, 199, 219, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(68,'Machamp',' Tiene cuatro brazos tan bien desarrollados que puede dar una serie de 1.000 puñetazos en cuestión de dos segundos.',10,null,null,45, 90, 130, 80, 65, 85, 55, 384, 359, 259, 229, 269, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(69,'Bellsprout',' Tiene cara de persona. Por el aspecto que tiene se ha comentado que podría ser algún tipo de mandrágora legendaria.',12,17,21,255, 50, 75, 35, 70, 30, 40, 304, 249, 169, 239, 159, 179);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(70,'Weepinbell',' Las hojas que tiene actúan como cuchillas en combate. Otra de sus armas es el corrosivo fluido que expulsa.',12,17,null,120, 65, 90, 50, 85, 45, 55, 334, 279, 199, 269, 189, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(71,'Victreebel',' Deja que su presa se le acerque a la boca, atraída por el aroma a miel. Una vez adentro, la disuelve con un fluido.',12,17,null,45, 80, 105, 65, 100, 70, 70, 364, 309, 229, 299, 239, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(72,'Tentacool',' Tiene unos ojos transparentes como el cristal, que disparan misteriosos rayos.',2,17,30,190, 40, 40, 35, 50, 100, 70, 284, 179, 169, 199, 299, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(73,'Tentacruel',' Tiene 80 tentáculos que se mueven a su aire. Con ellos pica, envenena, y causa un dolor agudo e intenso.',2,17,null,60, 80, 70, 65, 80, 120, 100, 364, 239, 229, 259, 339, 299);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(74,'Geodude',' Es fácil atraparlo por la forma redonda que tiene. Cuando hay batallas de bolas de nieve, la gente lo usa para lanzarlo.',14,16,25,255, 40, 80, 100, 30, 30, 20, 284, 259, 299, 159, 159, 139);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(75,'Graveler',' Este Pokémon es un peligro. Suele bajar rodando las montañas a toda velocidad por los caminos reservados para el senderismo.',14,16,null,120, 55, 95, 115, 45, 45, 35, 314, 289, 329, 189, 189, 169);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(76,'Golem',' Está encerrado en un duro caparazón formado por escamas de piedra. Para fortalecerse, lo muda una vez al año.',14,16,null,45, 80, 120, 130, 55, 65, 45, 364, 339, 359, 209, 229, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(77,'Ponyta',' Tiene un cuerpo ligero, pero unas patas tremendamente fuertes. Es capaz de destrozar un peñón de una patada.',7,null,40,190, 50, 85, 55, 65, 65, 90, 304, 269, 209, 229, 229, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(78,'Rapidash',' Al galope puede alcanzar los 240 km por hora. Impresiona verlo con sus llameantes melenas, a la velocidad del rayo.',7,null,null,60, 65, 100, 70, 80, 80, 105, 334, 299, 239, 259, 259, 309);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(79,'Slowpoke',' Está siempre en su mundo, pero nadie sabe en qué piensa. Suele pescar con la cola.',2,13,37,190, 90, 65, 65, 40, 40, 15, 384, 229, 229, 179, 179, 129);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(80,'Slowbro',' Según parece, cuando Slowpoke fue a pescar al río, le mordió un Shellder en la cola y así se convirtió en Slowbro.',2,13,null,75, 95, 75, 110, 100, 80, 30, 394, 249, 319, 299, 259, 159);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(81,'Magnemite',' Está suspendido en el aire y no para de moverse. A través de las extremidades laterales dispara Onda Trueno.',5,1,30,190, 25, 35, 70, 95, 55, 45, 254, 169, 239, 289, 209, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(82,'Magneton',' Lo constituye un grupo de Magnemite. Descarga potentes ondas magnéticas de alto voltaje.',5,1,null,60, 50, 60, 95, 120, 70, 70, 304, 219, 289, 339, 239, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(83,'Farfetch’d',' Siempre lleva una ramita en el pico, con la que construye su nido.',11,18,null,45, 52, 90, 55, 58, 62, 60, 308, 279, 209, 215, 223, 219);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(84,'Doduo',' Este Pokémon de dos cabezas es el resultado de una mutación. Cuando corre, puede alcanzar casi 100 km por hora.',11,18,null,190, 35, 85, 45, 35, 35, 75, 274, 269, 189, 169, 169, 249);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(85,'Dodrio',' Pertenece a una rara especie difícil de encontrar. Las tres cabezas simbolizan la alegría, la tristeza y la ira.',11,18,null,45, 60, 110, 70, 60, 60, 110, 324, 319, 239, 219, 219, 319);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(86,'Seel',' Está recubierto de un pelaje de color azul, y tiene una piel gruesa y tosca. Se mantiene activo a 40 grados bajo 0.',2,null,34,190, 65, 45, 55, 45, 70, 45, 334, 189, 209, 189, 239, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(87,'Dewgong',' Está recubierto de un luminoso pelaje blanco. Este Pokémon aumenta su actividad cuando bajan las temperaturas.',2,9,null,75, 90, 70, 80, 70, 95, 70, 384, 239, 259, 239, 289, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(88,'Grimer',' Nace de lodo alterado al filtrarse en el agua los rayos X reflejados por la Luna. Se alimenta de sustancias desagradables.',17,null,38,190, 80, 80, 50, 40, 50, 25, 364, 259, 199, 179, 199, 149);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(89,'Muk',' Normalmente pasa desapercibido porque se mezcla con lo que haya en el suelo. Al contacto resulta tóxico.',17,null,null,75, 105, 105, 75, 65, 100, 50, 414, 309, 249, 229, 299, 199);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(90,'Shellder',' Está metido en una concha sólida como el diamante, pero tiene un cuerpo muy blando.',2,null,null,190, 30, 65, 100, 45, 25, 40, 264, 229, 299, 189, 149, 179);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(91,'Cloyster',' La concha que lo cubre es extremadamente dura. No es posible causarle rasguños y sólo se abre si lo atacan.',2,9,null,60, 50, 95, 180, 85, 45, 70, 304, 289, 459, 269, 189, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(92,'Gastly',' Está compuesto prácticamente de un gas ligero con el que es capaz de asfixiar al mayor de los Pokémon en dos segundos.',6,17,25,190, 30, 35, 30, 100, 35, 80, 264, 169, 159, 299, 169, 259);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(93,'Haunter',' Cuando tienes la sensación de que te están observando, seguro que es porque Haunter está cerca.',6,17,null,90, 45, 50, 45, 115, 55, 95, 294, 199, 189, 329, 209, 289);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(94,'Gengar',' Dicen que sale de la oscuridad para robarle el alma a los que se pierden por las montañas.',6,17,null,45, 60, 65, 60, 130, 75, 110, 324, 229, 219, 359, 249, 319);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(95,'Onix',' Suele vivir bajo tierra. Va buscando comida a medida que se va abriendo camino a 80 km por hora.',14,16,null,45, 35, 45, 160, 30, 45, 70, 274, 189, 419, 159, 189, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(96,'Drowzee',' Desciende del legendario animal baku, del que se dice que come sueños. Tiene grandes habilidades hipnóticas.',13,null,26,190, 60, 48, 45, 43, 90, 42, 324, 195, 189, 185, 279, 183);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(97,'Hypno',' Lleva un péndulo en la mano. Una vez, hizo desaparecer a un niño al que había hipnotizado.',13,null,null,75, 85, 73, 70, 73, 115, 67, 374, 245, 239, 245, 329, 233);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(98,'Krabby',' Es fácil encontrarlo cerca del mar. Las largas pinzas que tienen vuelven a crecer si se las quitan de su sitio.',2,null,28,225, 30, 105, 90, 25, 25, 50, 264, 309, 279, 149, 149, 199);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(99,'Kingler',' La pinza tan grande que tiene posee una fuerza de 10.000 caballos de potencia. Pero, por su gran tamaño, cuesta moverla.',2,null,null,60, 55, 130, 115, 50, 50, 75, 314, 359, 329, 199, 199, 249);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(100,'Voltorb',' La procedencia de esta forma de vida no está muy clara. Dicen que usa chirrido y autodestrucción.',5,null,30,190, 40, 30, 50, 55, 55, 100, 284, 159, 199, 209, 209, 299);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(101,'Electrode',' Explotan a la mínima. Por eso se le tiene mucho miedo. Estos Pokémon reciben el nombre de Bomba Ball.',5,null,null,60, 60, 50, 70, 80, 80, 150, 324, 199, 239, 259, 259, 399);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(102,'Exeggcute',' Aunque los huevos que lo constituyen parecen de verdad, se ha visto que son como semillas.',12,13,null,90, 60, 40, 80, 60, 45, 40, 324, 179, 259, 219, 189, 179);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(103,'Exeggutor',' Suelen referirse a él como la vegetación del trópico con patas. Cada una de sus cabezas tiene autonomía.',12,13,null,45, 95, 95, 85, 125, 75, 55, 394, 289, 269, 349, 249, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(104,'Cubone',' Lleva puesto el cráneo de su madre. Cuando se siente solo se pone a gritar muy fuerte.',16,null,28,190, 50, 50, 95, 40, 50, 35, 304, 199, 289, 179, 199, 169);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(105,'Marowak',' Es pequeño y siempre ha sido muy débil. Cuando empezó a usar huesos, se volvió más violento.',16,null,null,75, 60, 80, 110, 50, 80, 45, 324, 259, 319, 199, 259, 189);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(106,'Hitmonlee',' Encoge y estira las patas a su antojo. Cuando las estira, es capaz de propinar una buena patada al enemigo.',10,null,null,45, 50, 120, 53, 35, 110, 87, 304, 339, 205, 169, 319, 273);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(107,'Hitmonchan',' Dicen que tiene el alma de un boxeador profesional. Da puñetazos a la velocidad del rayo.',10,null,null,45, 50, 105, 79, 35, 110, 76, 304, 309, 257, 169, 319, 251);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(108,'Lickitung',' La lengua es tan alta que duplica su altura. Es útil porque puede moverla para agarrar comida y atacar.',11,null,null,45, 90, 55, 75, 60, 75, 30, 384, 209, 249, 219, 249, 159);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(109,'Koffing',' Tiene forma de globo y es muy ligero. Está compuesto por gases tóxicos, y apesta.',17,null,35,190, 40, 65, 95, 60, 45, 35, 284, 229, 289, 219, 189, 169);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(110,'Weezing',' En ocasiones, puede mutar y originar dos Koffing pequeños idénticos que, al unirse, forman un Weezing.',17,null,null,60, 65, 90, 120, 85, 70, 60, 334, 279, 339, 269, 239, 219);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(111,'Rhyhorn',' Es muy fuerte, pero no especialmente listo. Es capaz de derribar rascacielos usando placaje varias veces.',16,14,42,120, 80, 85, 95, 30, 30, 25, 364, 269, 289, 159, 159, 149);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(112,'Rhydon',' Cuando evoluciona, comienza a andar con las patas traseras. Es capaz de horadar rocas con el cuerno que tiene.',16,14,null,60, 105, 130, 120, 45, 45, 40, 414, 359, 339, 189, 189, 179);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(113,'Chansey',' Pone varios huevos al día. Según parece son muy nutritivos y están riquísimos.',11,null,null,30, 250, 5, 5, 35, 105, 50, 704, 109, 109, 169, 309, 199);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(114,'Tangela',' Las cintas de tipo alga que tiene a modo de tentáculos le dan su identidad. Es una masa que todo lo enreda.',12,null,null,45, 65, 55, 115, 100, 40, 60, 334, 209, 329, 299, 179, 219);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(115,'Kangaskhan',' La hembra cría a sus pequeños en la bolsa que tiene en la panza. Es muy buena usando puño cometa.',11,null,null,45, 105, 95, 80, 40, 80, 90, 414, 289, 259, 179, 259, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(116,'Horsea',' Tiene enrollada la cola y la usa para mantener el equilibrio. En ocasiones tira tinta por la boca.',2,null,32,225, 30, 40, 70, 70, 25, 60, 264, 179, 239, 239, 149, 219);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(117,'Seadra',' Las afiladas púas que le recubren el cuerpo se le erizan y pueden causar el debilitamiento con sólo tocarlo.',2,null,null,75, 55, 65, 95, 95, 45, 85, 314, 229, 289, 289, 189, 269);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(118,'Goldeen',' Las aletas dorsales están tan desarrolladas que actúan como músculos. Puede nadar a casi 10 km por hora.',2,null,33,225, 45, 67, 60, 35, 50, 63, 294, 233, 219, 169, 199, 225);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(119,'Seaking',' El cuerno que tiene en la cabeza está tan afilado como un taladro. Suele usarlo para horadar rocas y construir su nido.',2,null,null,60, 80, 92, 65, 65, 80, 68, 364, 283, 229, 229, 259, 235);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(120,'Staryu',' Suele aparecer en grupos en la orilla de la playa. Por la noche, el órgano central que tiene brilla con una luz roja.',2,null,null,225, 30, 45, 55, 70, 55, 85, 264, 189, 209, 239, 209, 269);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(121,'Starmie',' Este Pokémon tiene un cuerpo geométrico que le da un aspecto extraterrestre.',2,13,null,60, 60, 75, 85, 100, 85, 115, 324, 249, 269, 299, 269, 329);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(122,'Mr. Mime',' Dicen que puede hacer un muro a partir del aire mediante la pantomima. Es experto en crear ilusiones ópticas.',13,8,null,45, 40, 45, 65, 100, 120, 90, 284, 189, 229, 299, 339, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(123,'Scyther',' Destroza a su presa con las guadañas que tiene. No es común que use las alas para volar.',3,18,null,45, 70, 110, 80, 55, 80, 105, 344, 319, 259, 209, 259, 309);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(124,'Jynx',' Habla emitiendo sonidos que parecen humanos. Se está intentando descifrar lo que dice cuando habla.',9,13,null,45, 65, 50, 35, 115, 95, 95, 334, 199, 169, 329, 289, 289);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(125,'Electabuzz',' Le encanta alimentarse de alta tensión. A veces, aparece cerca de centrales eléctricas y zonas similares.',5,null,null,45, 65, 83, 57, 95, 85, 105, 334, 265, 213, 289, 269, 309);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(126,'Magmar',' A este Pokémon se lo encontraron cerca de un volcán. Esta criatura ígnea tiene una temperatura corporal de unos 1.200º.',7,null,null,45, 65, 95, 57, 100, 85, 93, 334, 289, 213, 299, 269, 285);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(127,'Pinsir',' Los cuernos que tiene a modo de pinzas son infalibles. Cuando atrapan al rival, no lo sueltan hasta que no acaban con él.',3,null,null,45, 65, 125, 100, 55, 70, 85, 334, 349, 299, 209, 239, 269);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(128,'Tauros',' Cuando va a utilizar placaje se azota repetidas veces con las tres colas que tiene.',11,null,null,45, 75, 100, 95, 40, 70, 110, 354, 299, 289, 179, 239, 319);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(129,'Magikarp',' No es precisamente rápido ni fuerte. Es el Pokémon más debilucho y simplón de todos los que hay.',2,null,20,255, 20, 10, 55, 15, 20, 80, 244, 119, 209, 129, 139, 259);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(130,'Gyarados',' Es exageradamente agresivo. Lanza hiperrayo por la boca para achicharrar a su rival.',2,18,null,45, 95, 125, 79, 60, 100, 81, 394, 349, 257, 219, 299, 261);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(131,'Lapras',' Tiene un coeficiente intelectual tan alto que puede entender el lenguaje humano. Le encanta llevar a gente sobre el lomo.',2,9,null,45, 130, 85, 80, 85, 95, 60, 464, 269, 259, 269, 289, 219);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(132,'Ditto',' Tiene la capacidad de reorganizar su estructura celular para convertirse en otras formas de vida.',11,null,null,35, 48, 48, 48, 48, 48, 48, 300, 195, 195, 195, 195, 195);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(133,'Eevee',' Es un Pokémon rarísimo que puede evolucionar de mil formas distintas según las circunstancias.',11,null,null,45, 55, 55, 50, 45, 65, 55, 314, 209, 199, 189, 229, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(134,'Vaporeon',' La composición celular de su cuerpo es tan similar a la estructura molecular del agua que se confunde con ella.',2,null,null,45, 130, 65, 60, 110, 95, 65, 464, 229, 219, 319, 289, 229);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(135,'Jolteon',' Si se le enfada o asusta, se le eriza el pelaje. Cada pelo se le convierte en una afilada púa que hace trizas al rival.',5,null,null,45, 65, 65, 60, 110, 95, 130, 334, 229, 219, 319, 289, 359);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(136,'Flareon',' Almacena llamas en el interior de su cuerpo. Tras inhalar profundamente, las lanza a una temperatura de 1.700º.',7,null,null,45, 65, 130, 60, 95, 110, 65, 334, 359, 219, 289, 319, 229);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(137,'Porygon',' Puede convertirse en datos informáticos y entrar en el ciberespacio.',11,null,null,45, 65, 60, 70, 85, 75, 40, 334, 219, 239, 269, 249, 179);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(138,'Omanyte',' Pokémon prehistórico que vivió en el océano primordial. Para nadar se valía de sus 10 tentáculos.',14,2,40,45, 35, 40, 100, 90, 55, 35, 274, 179, 299, 279, 209, 169);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(139,'Omastar',' Tiene los tentáculos tan desarrollados que le sirven de mano y pies.Con ellos atrapa a sus presas y les da un bocado.',14,2,null,45, 70, 60, 125, 115, 70, 55, 344, 219, 349, 329, 239, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(140,'Kabuto',' Es un Pokémon regenerado a partir de un fósil de una criatura ancestral. Está protegido por un duro caparazón.',14,2,40,45, 30, 80, 90, 55, 45, 55, 264, 259, 279, 209, 189, 209);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(141,'Kabutops',' Le gusta nadar a su aire. Cuando atrapa a su presa con las garras, le absorbe todos los fluidos.',14,2,null,45, 60, 115, 105, 65, 70, 80, 324, 329, 309, 229, 239, 259);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(142,'Aerodactyl',' Se regeneró a partir de material genético de un dinosaurio, encontrado en ámbar. Cuando vuela emite escandalosos alaridos.',14,18,null,45, 80, 105, 65, 60, 75, 130, 364, 309, 229, 219, 249, 359);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(143,'Snorlax',' No se encuentra satisfecho hasta que no se come 400 kg de comida cada día. Cuando acaba de comer, se queda dormido.',11,null,null,25, 160, 110, 65, 65, 110, 30, 524, 319, 229, 229, 319, 159);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(144,'Articuno',' Es uno de los legendarios pájaros Pokémon. Vuela con la cola al viento haciendo gala de su magnificencia.',9,18,null,3, 90, 85, 100, 95, 125, 85, 384, 269, 299, 289, 349, 269);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(145,'Zapdos',' Es uno de los legendarios pájaros Pokémon. Cuando vuela hace ruidos, emite una especie de chasquido y chisporroteo.',5,18,null,3, 90, 90, 85, 125, 90, 100, 384, 279, 269, 349, 279, 299);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(146,'Moltres',' Es uno de los legendarios pájaros Pokémon. Quien lo ve, se queda embobado con las alas que tiene, parece que arden.',7,18,null,3, 90, 100, 90, 125, 85, 90, 384, 299, 279, 349, 269, 279);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(147,'Dratini',' Las crías pueden medir más de 2 m y crecen más mudando muchas veces la piel.',4,null,30,45, 41, 64, 45, 50, 50, 50, 286, 227, 189, 199, 199, 199);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(148,'Dragonair',' Dicen que habita ríos y mares. Aunque no tiene alas, a veces se le ha visto volar.',4,null,55,45, 61, 84, 65, 70, 70, 70, 326, 267, 229, 239, 239, 239);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(149,'Dragonite',' A pesar del tamaño que tiene y de lo pesado que es, puede volar. Es capaz de dar la vuelta al mundo en solo 16 horas.',4,18,null,45, 91, 134, 95, 100, 100, 80, 386, 367, 289, 299, 299, 259);
INSERT INTO especie(id_especie, bicho, descripcion, tipo1, tipo2, nivel_evolucion, ratio_captura, salud_base, ataque_normal_base, defensa_normal_base, ataque_especial_base, defensa_especial_base, velocidad_base, salud_maxima, ataque_normal_maximo, defensa_normal_maxima, ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima) VALUES(150,'Mewtwo',' Su código genético se recombinó repetidas veces por motivos científicos y el resultado fue este curioso Pokémon.',13,null,null,3, 106, 110, 90, 154, 90 , 130, 416, 319, 279, 407, 279, 359);

INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(1,2);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(2,3);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(4,5);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(7,8);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(8,9);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(10,11);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(11,12);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(13,14);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(14,15);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(16,17);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(17,18);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(19,20);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(21,22);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(23,24);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(25,26);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(27,28);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(29,30);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(30,31);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(32,33);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(33,34);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(35,36);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(37,38);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(39,40);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(41,42);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(43,44);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(44,45);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(46,46);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(48,49);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(50,51);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(52,53);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(54,55);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(56,57);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(58,59);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(60,61);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(61,62);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(63,63);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(63,65);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(66,67);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(67,68);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(69,70);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(70,71);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(72,73);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(74,75);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(75,76);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(77,78);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(79,80);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(81,82);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(84,85);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(86,87);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(88,89);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(90,91);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(92,93);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(93,94);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(96,97);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(98,99);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(100,101);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(102,103);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(104,105);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(109,110);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(111,112);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(116,117);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(118,119);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(120,121);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(129,130);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(129,131);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(129,132);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(133,134);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(133,135);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(133,136);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(138,139);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(140,140);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(147,148);
INSERT INTO especieEvolucion(id_especie_actual, id_especie_siguiente) VALUES(148,149);

INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(1,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(1,0.5,2);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(1,0.5,5);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(1,0.5,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(1,2,8);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(1,2,9);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(1,2,14);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(2,0.5,2);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(2,0.5,4);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(2,2,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(2,0.5,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(2,2,14);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(2,2,16);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,0.5,6);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,0.5,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,0.5,8);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,0.5,10);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,2,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,2,13);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,2,15);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,0.5,17);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(3,0.5,18);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(4,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(4,2,4);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(4,0,8);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(5,2,2);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(5,0.5,4);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(5,0.5,5);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(5,0.5,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(5,0,16);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(5,2,18);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(6,2,6);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(6,0,11);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(6,2,13);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(6,0.5,15);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(7,2,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(7,0.5,2);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(7,2,3);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(7,0.5,4);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(7,0.5,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(7,2,9);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(7,2,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(7,0.5,14);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(8,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(8,2,4);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(8,0.5,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(8,2,10);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(8,2,15);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(8,0.5,17);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(9,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(9,0.5,2);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(9,2,4);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(9,0.5,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(9,0.5,9);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(9,2,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(9,2,16);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(9,2,18);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,2,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,0.5,3);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,0,6);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,0.5,8);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,2,9);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,2,11);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,0.5,13);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,2,14);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,2,15);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,0.5,17);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(10,0.5,18);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(11,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(11,0,6);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(11,0.5,14);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,2,2);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,0.5,3);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,0.5,4);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,0.5,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,0.5,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,2,14);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,2,16);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,0.5,17);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(12,0.5,18);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(13,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(13,2,10);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(13,0.5,13);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(13,0,15);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(13,2,17);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(14,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(14,2,3);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(14,2,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(14,2,9);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(14,0.5,10);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(14,0.5,16);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(14,2,18);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(15,2,6);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(15,0.5,8);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(15,0.5,10);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(15,2,13);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(15,0.5,15);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(16,2,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(16,0.5,3);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(16,2,5);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(16,2,7);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(16,0.5,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(16,2,14);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(16,2,17);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(16,0,18);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(17,0,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(17,0.5,6);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(17,2,8);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(17,2,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(17,0.5,14);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(17,0.5,16);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(17,0.5,17);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(18,0.5,1);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(18,2,3);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(18,0.5,5);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(18,2,10);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(18,2,12);
INSERT INTO resitenciasTipo(id_tipo_ataque, eficacia, id_atacado) VALUES(18,0.5,14);
