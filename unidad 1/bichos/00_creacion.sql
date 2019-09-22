create database bichos
go
use bichos
go

create table usuario(
	id_usuario int identity not null primary key,
	nombre nvarchar(30) not null
)
go

create table tipo(
	id_tipo int identity not null primary key,
	descripcion nvarchar(100) not null
)
go

create table especie(
	id_especie int identity not null primary key,
	id_tipo int not null,
	nombre_especie nvarchar(30) not null,
	velocidad_ataque numeric not null,
	salud_maxima int not null,
	daño_ataque int not null,
	foreign key(id_tipo) references tipo(id_tipo)
)
go

create table bicho(
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

create table usuarioBicho(
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

create table intercambio(
	id_intercambio int identity not null,
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

create table combate(
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

create table ataque(
	id_ataque int identity not null primary key,
	id_tipo int not null,
	descripcion_ataque text not null,
	foreign key(id_tipo) references tipo(id_tipo)
)
go

create table ataqueEspecie(
	id_ataque int not null,
	id_especie int not null,
	foreign key(id_ataque) references ataque(id_ataque),
	foreign key(id_especie) references especie(id_especie)
)
go

create table resitenciasTipo(
	id_tipo int not null,
	id_ataque int not null,
	foreign key(id_tipo) references tipo(id_tipo),
	foreign key(id_ataque) references ataque(id_ataque)
)
go

create table especieEvolucion(
	id_especie_actual int not null,
	id_especie_siguiente int not null,
	foreign key(id_especie_actual) references especie(id_especie),
	foreign key(id_especie_siguiente) references especie(id_especie)
)
go