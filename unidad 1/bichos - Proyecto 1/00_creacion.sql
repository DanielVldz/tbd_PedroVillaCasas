create database bichos
go
use bichos
go

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

-- [id, bicho, Descripcion, tipo1, tipo2, id_siguiente, nivel_evolucion, id_anterior, 
--ratio_captura, ps_base, ataque_base, defensa_base, ataque_especial_base, 
--defensa_especial_base, velocidad_base, ps_maximo, ataque_maximo, defensa_maxima, 
--ataque_especial_maximo, defensa_especial_maxima, velocidad_maxima]

create table especie
(
	id_especie int identity not null primary key,
	bicho nvarchar(30) not null,
	descripcion text,
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
	defensa_especial_base int not null,
	velocidad_maxima int not null,
	foreign key(tipo1) references tipo(id_tipo),
	foreign key(tipo2) references tipo(id_tipo),
	foreign key(id_evolucion_anterior) references especie(id_especie),
	foreign key(id_evolucion_siguiente) references especie(id_especie)
)
go

create table ataque
(
	id_ataque int identity not null primary key,
	id_tipo int not null,
	categoria_ataque char(1) not null,
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
	eficacia numeric not null,
	id_atacado int not null,
	foreign key(id_tipo_ataque) references tipo(id_tipo),
	foreign key(id_atacado) references tipo(id_tipo),
	primary key(id_tipo, id_tipo)
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