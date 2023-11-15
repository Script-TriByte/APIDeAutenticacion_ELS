use scripttribyte;

create table turnos(
	idTurno int not null auto_increment primary key,
    horaInicio time not null,
    horaFinal time not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table categorias(
	tipo char not null primary key
);

create table departamentos(
	idDepartamento int not null primary key auto_increment,
    nombre varchar(20) not null
);

create table almacenes(
	idAlmacen int not null auto_increment primary key,
    capacidad int not null,
    direccion VARCHAR(40) not null,
    idDepartamento int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idDepartamento) references departamentos(idDepartamento)
);

create table estanterias(
	identificador int not null auto_increment primary key,
    peso double not null,
    apiladoMaximo int not null,
    idAlmacen int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idAlmacen) references almacenes(idAlmacen)
);

create table usuarios(
	docDeIdentidad int(8) not null primary key,
    nombre varchar(255) not null,
    apellido varchar(20) not null,
    telefono int(10) not null,
    direccion varchar(40) not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table user_usuario(
	id bigint(20) unsigned not null primary key,
    docDeIdentidad int(8) not null unique,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    foreign key (id) references users(id),
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad)
);

create table choferes(
	docDeIdentidad int(8) not null primary key,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad)
);

create table gerentes(
	docDeIdentidad int(8) not null primary key,
    idAlmacen int not null,
    idTurno int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad),
    foreign key (idAlmacen) references almacenes(idAlmacen),
    foreign key (idTurno) references turnos(idTurno)
);

create table administradores(
	docDeIdentidad int(8) not null primary key,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad)
);

create table cargadores(
	docDeIdentidad int(8) not null primary key,
    carnetTransporte int not null,
    idAlmacen int not null,
    idTurno int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad),
    foreign key (idAlmacen) references almacenes(idAlmacen),
    foreign key (idTurno) references turnos(idTurno)
);

create table licencias(
	idLicencia char(8) not null primary key,
    validoDesde date not null,
    validoHasta date not null,
    docDeIdentidad int(8) not null,
    categoria char not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references choferes(docDeIdentidad),
    foreign key (categoria) references categorias(tipo)
);

create table modelos(
	idModelo int not null primary key auto_increment,
    nombre varchar(255) not null,
    anio year not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table vehiculos(
	idVehiculo int not null primary key auto_increment,
    matricula char(8) not null unique,
    capacidad int not null,
    pesoMaximo int not null,
    modelo int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (modelo) references modelos(idModelo)
);

create table maneja(
	docDeIdentidad int(8) not null primary key,
    idVehiculo int not null unique,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references choferes(docDeIdentidad),
    foreign key (idVehiculo) references vehiculos(idVehiculo)
);

create table tipoArticulo(
	idTipoArticulo int not null auto_increment primary key,
    tipo char not null unique,
	nombre varchar(50) not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table articulos(
	idArticulo int not null auto_increment primary key,
    nombre varchar(50) not null,
    anioCreacion int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table codigoDeBulto(
	codigo int not null primary key auto_increment,
    tipo char not null unique,
    maximoApilado int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table paquetes(
	idPaquete int not null auto_increment primary key,
    cantidadArticulos int not null,
    peso int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table articulo_paquete(
	idArticulo int not null primary key,
    idPaquete int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idArticulo) references articulos(idArticulo),
    foreign key (idPaquete) references paquetes(idPaquete)
);

create table destinos(
	idDestino int not null primary key auto_increment,
    direccion varchar(50) not null,
    idDepartamento int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idDepartamento) references departamentos(idDepartamento)
);

create table lotes(
	idLote int not null auto_increment primary key,
    cantidadPaquetes int not null,
    idDestino int not null,
    idAlmacen int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idDestino) references destinos(idDestino),
    foreign key (idAlmacen) references almacenes(idAlmacen)
);

create table vehiculo_lote_destino(
    idLote int not null primary key,
    fechaEstimada date not null,
    horaEstimada time not null,
    docDeIdentidad int(8) not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idLote) references lotes(idLote),
    foreign key (docDeIdentidad) references maneja(docDeIdentidad)
);

create table estadoEntrega(
	idLote int not null primary key,
	fechaEntrega date not null,
    horaEntrega time not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idLote) references vehiculo_lote_destino(idLote)
);

create table paquete_lote(
	idPaquete int not null primary key,
    idLote int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idPaquete) references paquetes(idPaquete),
    foreign key (idLote) references lotes(idLote)
);

create table articulo_tipoArticulo(
	idRelacion int not null primary key auto_increment, /*Por Laravel*/
    idArticulo int not null,
    idTipo int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
	unique (idArticulo, idTipo),
    foreign key (idArticulo) references articulos(idArticulo),
    foreign key (idTipo) references tipoArticulo(idTipoArticulo)
);

create table paquete_estanteria(
	idRelacion int not null primary key auto_increment, /*Por Laravel*/
    idPaquete int not null,
    idEstanteria int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    unique (idPaquete, idEstanteria),
	foreign key (idPaquete) references paquetes(idPaquete),
    foreign key (idEstanteria) references estanterias(identificador)
);

create table paquete_codigoDeBulto(
	idRelacion int not null primary key auto_increment, /*Por Laravel*/
    idPaquete int not null,
    codigo int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    unique (idPaquete, codigo),
    foreign key (idPaquete) references paquetes(idPaquete),
    foreign key (codigo) references codigoDeBulto(codigo)
);

INSERT INTO categorias (tipo) VALUES ("A");
INSERT INTO categorias (tipo) VALUES ("B");
INSERT INTO categorias (tipo) VALUES ("C");
INSERT INTO categorias (tipo) VALUES ("D");
INSERT INTO categorias (tipo) VALUES ("E");
INSERT INTO categorias (tipo) VALUES ("F");
INSERT INTO categorias (tipo) VALUES ("G");
INSERT INTO categorias (tipo) VALUES ("H");

INSERT INTO departamentos (nombre) VALUES ("Montevideo");
INSERT INTO departamentos (nombre) VALUES ("Rivera");
INSERT INTO departamentos (nombre) VALUES ("Paysandu");
INSERT INTO departamentos (nombre) VALUES ("Florida");
INSERT INTO departamentos (nombre) VALUES ("Durazno");
INSERT INTO departamentos (nombre) VALUES ("Canelones");
INSERT INTO departamentos (nombre) VALUES ("Flores");
INSERT INTO departamentos (nombre) VALUES ("Maldonado");
INSERT INTO departamentos (nombre) VALUES ("Rocha");
INSERT INTO departamentos (nombre) VALUES ("Artigas");
INSERT INTO departamentos (nombre) VALUES ("Salto");
INSERT INTO departamentos (nombre) VALUES ("Treinta y Tres");
INSERT INTO departamentos (nombre) VALUES ("Soriano");
INSERT INTO departamentos (nombre) VALUES ("San José");
INSERT INTO departamentos (nombre) VALUES ("Tacuarembó");
INSERT INTO departamentos (nombre) VALUES ("Colonia");
INSERT INTO departamentos (nombre) VALUES ("Rio Negro");
INSERT INTO departamentos (nombre) VALUES ("Lavalleja");
INSERT INTO departamentos (nombre) VALUES ("Cerro Largo");