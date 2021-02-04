/* https://www.postgresql.org/docs/13/datatype.html */
/* \i file.sql */
/* \d table_tame */
/* list tables \dt 8*/


/* TABLESPACE */

/* DEFAULT */
/*
CREATE TABLESPACE APALDEF 
    DATAFILE 'APALDEF.DBF' SIZE 2M AUTOEXTEND ON;
*/
/* TEMPORARY */
/*
CREATE TEMPORARY TABLESPACE APALTMP 
    TEMPFILE 'APALTMP.DBF' SIZE 2M AUTOEXTEND ON;
    
*/
    
/* CREAR USUARIO BASE*/
 /*
CREATE USER APAL IDENTIFIED BY apal
DEFAULT TABLESPACE APALDEF
TEMPORARY TABLESPACE APALTMP
QUOTA 2M ON APALDEF
PASSWORD EXPIRE;

GRANT connect, resource TO APAL;
*/

/*
CREATE DATABASE apoyo_alimentario
USER APAL IDENTIFIED BY apal
EXTENT MANAGEMENT LOCAL
DEFAULT TEMPORARY TABLESPACE APALTMP
DEFAULT TABLESPACE APALDEF;
*/




/*
We should create two connections to the database depend on the user,
each connection has associated an user, this user have different
grants, so we avoid students creates in tables she/he is not allowed.
 */


/**************** USERS AUTHENTICATION ************************/
drop table if exists rol;
drop table if exists usuario;
drop table if exists periodo;
drop table if exists estado_convocatoria;
drop table if exists convocatoria;
drop table if exists historico_convocatoria;
drop table if exists estado_documento;
drop table if exists tipo_documento;
drop table if exists puntaje_tipo_documento;
drop table if exists documento_solicitud;
drop table if exists facultad;
drop table if exists proyecto_curricular;
drop table if exists estudiante;
drop table if exists estado_solicitud;
drop table if exists solicitud;
drop table if exists historico_solicitud;
drop table if exists convocatoria_facultad;
drop table if exists tipo_subsidio;
drop table if exists tipo_subsidio_convocatoria;
drop table if exists beneficiario;
drop table if exists ticket;
drop table if exists estado_actividad;
drop table if exists actividad;
drop table if exists responsable_actividad;
drop table if exists actividad_beneficiario;
drop table if exists parametro;


/* create table rol(
  id_rol integer primary key,
  nombre varchar (30) unique not null
); */
create table rol(
 id_rol number(2,0) not null,
 nombre varchar2(15 byte) not null,
 constraint rol_pk primary key (id_rol) enable;
);
insert into rol(id_rol, nombre) values(1, 'estudiante');
insert into rol(id_rol, nombre) values(2, 'administrador');

/* 
create table usuario(
  id_usuario serial primary key,
  password varchar( 256 ) not null,
  fecha_creacion timestamp not null,
  ultimo_accesso timestamp default current_timestamp,
  id_rol integer not null
); */

create table usuario(
  id_usuario number(11,0) not null,
  id_rol number(2,0) not null,
  password varchar2( 256 byte) not null,
  fecha_creacion timestamp not null,
  ultimo_acceso timestamp default current_timestamp,
  constraint usuario_pk primary key (id_usuario) enable);

insert into usuario(id_usuario, password, fecha_creacion, id_rol) values (1, 'pass', current_timestamp, 1);
insert into usuario(id_usuario, password, fecha_creacion, id_rol) values (2, 'pass', current_timestamp, 2);


/**************** CONVOCATORIA ************************/


-- create table periodo(
  -- id_periodo serial primary key,
  -- nombre varchar(10) not null,
  -- descripcion varchar(200) ,
  -- fecha_inicio timestamp not null,
  -- fecha_fin timestamp not null constraint chk_periodo_feacha_fin_greater_fecha_inicio check(fecha_fin>fecha_inicio),
  -- semanas_periodo integer  generated always as (trunc(date_part('day'::text,fecha_fin-fecha_inicio)/7)) stored
-- );

create table periodo(
  id_periodo number(2,0) not null,
  nombre varchar2(10 byte) not null,
  descripcion varchar2(200 byte),
  fecha_inicio timestamp not null,
  fecha_fin timestamp not null,
  semanas_periodo number(2,0) generated always as ((trunc(fecha_fin) - trunc(fecha_inicio))/7) VIRTUAL,
  constraint periodo_pk primary key (id_periodo) enable);
  
alter table periodo add constraint chk_periodo_fin_inicio check(fecha_fin>fecha_inicio);

-- insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin)
-- values (1, '2020-3','2020-10-27 00:00:00', '2020-12-27 23:59:59');

insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin)
values (1, '2020-3',to_date('2020-10-27 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), to_date('2020-12-27 23:59:59','yyyy-mm-dd hh24:mi:ss'));

-- insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin)
-- values (2, '2020-1','2020-02-01 00:00:00', '2020-05-29 23:59:59');

insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin)
values (2, '2020-1',to_date('2020-02-01 00:00:00','yyyy-mm-dd hh24:mi:ss'), to_date('2020-05-29 23:59:59', 'yyyy-mm-dd hh24:mi:ss');


-- create table estado_convocatoria(
  -- id_estado_convocatoria serial primary key,
  -- estado varchar(30) not null,
  -- descripcion varchar(200)
-- );

create table estado_convocatoria(
  id_estado_convocatoria number(2,0) not null,
  estado varchar2(30 byte) not null,
  descripcion varchar2(200 byte),
  constraint estado_convocatoria_pk primary key (id_estado_convocatoria)enable);
  
--estado convocatoria
insert into estado_convocatoria(id_estado_convocatoria, estado) values('1', 'activa');
insert into estado_convocatoria(id_estado_convocatoria, estado) values('2', 'cerrada');
insert into estado_convocatoria(id_estado_convocatoria, estado) values('3', 'publicada');

-- create table convocatoria(
  -- id_convocatoria serial primary key,
  -- fecha_inicio date not null,
  -- fecha_fin date not null constraint chk_convocatoria_fecha_fin_greater_fecha_inicio check(fecha_fin>fecha_inicio),
  -- id_periodo integer not null unique,
  -- id_estado_convocatoria integer not null,
  -- foreign key(id_periodo) references periodo(id_periodo),
  -- foreign key(id_estado_convocatoria) references estado_convocatoria(id_estado_convocatoria)
-- );

create table convocatoria(
  id_convocatoria number(2,0) not null,
  fecha_inicio timestamp not null,
  fecha_fin timestamp not null,
  id_periodo number(2,0) not null unique,
  id_estado_convocatoria number(2,0) not null,
  constraint id_convocatoria primary key (id_convocatoria) enable);
  
 
alter table convocatoria add constraint convocatoria_periodo_fk foreign key (id_periodo) references periodo (id_periodo) enable;
alter table convocatoria add constraint estado_convocatoria_fk foreign key (id_estado_convocatoria) references estado_convocatoria (id_estado_convocatoria) enable;


alter table convocatoria add constraint chk_conv_fecha_fin_inicio check(fecha_fin>fecha_inicio);



-- create table historico_convocatoria(
  -- id_historico_convocatoria serial primary key,
  -- id_convocatoria integer,
  -- id_estado_convocatoria integer not null,
  -- fecha timestamp not null,
  -- foreign key(id_estado_convocatoria) references estado_convocatoria(id_estado_convocatoria),
  -- foreign key(id_convocatoria) references convocatoria(id_convocatoria)
-- );

create table historico_convocatoria(
  id_historico_convocatoria number(2,0) not null,
  id_convocatoria number(2,0),
  id_estado_convocatoria number(2,0) not null,
  fecha timestamp not null,
  constraint id_historico_convocatoria primary key (id_historico_convocatoria) enable);
  
alter table historico_convocatoria add constraint historico_estado_conv_fk foreign key(id_estado_convocatoria) references estado_convocatoria (id_estado_convocatoria) enable;
alter table historico_convocatoria add constraint convocatoria_fk foreign key(id_convocatoria) references convocatoria(id_convocatoria) enable;


/**************** ESTUDIANTES ************************/



-- create table estado_documento(
  -- id_estado_documento serial primary key,
  -- nombre varchar(30) not null,
  -- descripcion varchar(200)
-- );

create table estado_documento(
  id_estado_documento number(2,0) not null,
  nombre varchar2(30 BYTE) not null,
  descripcion varchar2(200 BYTE),
  constraint id_estado_documento primary key (id_estado_documento) enable);

insert into estado_documento(id_estado_documento, nombre) values ('1', 'Sin Revisar');
insert into estado_documento(id_estado_documento, nombre) values ('2', 'Aprovado');
insert into estado_documento(id_estado_documento, nombre) values ('3', 'Requiere cambios');
insert into estado_documento(id_estado_documento, nombre) values ('4', 'Rechazado');


-- create table tipo_documento(
  -- id_tipo_documento serial primary key,
  -- obligatorio numeric(1,0) check(obligatorio in(0, 1)) not null,
  -- nombre varchar(200)
-- );

create table tipo_documento(
  id_tipo_documento number(2,0) not null,
  obligatorio number(1,0) not null,
  nombre varchar2(200 BYTE),
  constraint id_tipo_documento primary key (id_tipo_documento) enable);

alter table tipo_documento add constraint chk_obligatorio check(obligatorio in (0,1)); 

insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(1, 'Formulario de Solicitud de ingreso al Programa Apoyo Alimentario', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(2, 'Carta dirigida al director del Centro de Bienestar Institucional', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(3, 'Certificado de estratificación del lugar de residencia del estudiante', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(4, 'Fotocopia de la factura de un recibo de servicio público de su domicilio', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(5, 'Certificado de desplazamiento forzoso por violencia del Departamento', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(6, 'Si es padre/madre, certificado Civil de nacimiento de los o las hijas', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(7, 'Certificado de Discapacidad Medica, avalado por Bienestar Institucional', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(8, 'Examen y Diagnostico Médico, Enfermedades presentes del estudiante', 0);

-- create table puntaje_tipo_documento(
  -- id_puntaje_tipo_documento serial primary key,
  -- nombre varchar(200) not null,
  -- id_tipo_documento integer not null,
  -- puntaje smallint not null constraint chk_documento_puntaje_greater_than_zero check(puntaje>=0 and puntaje <=100),
  -- foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento)
-- );

create table puntaje_tipo_documento(
  id_puntaje_tipo_documento number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  id_tipo_documento number(2,0) not null,
  puntaje number not null, 
  constraint id_puntaje_tipo_documento primary key (id_puntaje_tipo_documento) enable);

alter table puntaje_tipo_documento add constraint id_tipo_documento_fk foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento);
alter table puntaje_tipo_documento add constraint chk_documento_puntaje check(puntaje>=0 and puntaje <=100);

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (1,'Formulario solicitud bien diligenciado', 1,  100);

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (2,'Formulario solicitud mal diligenciado', 1,  0);

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (3,'Carta al director bien escrita', 2,100);

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (4,'Carta al director mal escrita', 2,100);

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (5,'Estrato 1', 3,100  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (6,'Estrato 2', 3,90  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (7,'Estrato 3', 3,70  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (8,'Estrato 4', 3,50  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (9,'Estrato 5', 3,10  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (10,'Recibo Actual', 4, 100 );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (11,'Recibo Desactualizado', 4,20  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (12,'Certificado desplazamiento forzoso correcto', 5, 100 );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (13,'Certificado desplazamiento forzoso invalido', 5, 0 );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (14,'Registro civil nacimento hijos valido', 6, 100  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (15,'Registro civil nacimento hijos invalido', 6, 0  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (16,'Certificado discapacidad medica valido', 7, 100 );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (17,'Certificado discapacidad medica invalido', 7, 0  );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (18,'Certificado enfermedades presentes valido ', 8, 100 );

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (19,'Certificado enfermedades presentes valido ', 8,  0);


-- create table facultad(
  -- id_facultad serial primary key,
  -- nombre varchar(50) not null
-- );

create table facultad(
  id_facultad number(2,0) not null,
  nombre varchar2(50 BYTE) not null,
  constraint id_facultad primary key (id_facultad) enable);

insert into facultad( id_facultad, nombre) values (1,'artes');
insert into facultad( id_facultad, nombre) values (2,'ingenieria');

-- create table proyecto_curricular(
  -- id_proyecto_curricular serial primary key,
  -- id_facultad integer not null,
  -- nombre varchar(200) not null,
  -- foreign key(id_facultad) references facultad(id_facultad)
-- );

create table proyecto_curricular(
  id_proyecto_curricular number(2,0) not null,
  id_facultad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  constraint id_proyecto_curricular primary key (id_proyecto_curricular) enable);


alter table proyecto_curricular add constraint id_facultad_fk foreign key(id_facultad) references facultad(id_facultad);

insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values ( 1, 1, 'electronica');
insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values ( 2, 2, 'industrial');


-- create table estudiante(
  -- id_estudiante serial primary key,
  -- identificacion varchar(30) unique not null,
  -- nombre varchar(50) not null,
  -- apellido varchar(50) not null,
  -- promedio numeric(3,2) constraint chk_estudiante_promedio_greater_in_zero_five_range check(promedio >=0 and promedio <=5.0),
  -- matriculas_restantes smallint default 10,
  -- email varchar(100),
  -- id_usuario integer not null,
  -- id_proyecto_curricular integer not null,
  -- foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular),
  -- foreign key(id_usuario) references usuario(id_usuario)
-- );

create table estudiante(
  id_estudiante number(11,0) not null,
  identificacion varchar2(30 BYTE) unique not null,
  nombre varchar2(50 BYTE) not null,
  apellido varchar2(50 BYTE) not null,
  promedio number(3,2) not null, 
  matriculas_restantes number(2,0) not null,
  email varchar2(100 BYTE),
  id_usuario number(11,0) not null,
  id_proyecto_curricular number(2,0) not null,
  constraint estudiante_pk primary key (id_estudiante) enable);

alter table estudiante add constraint id_proyecto_curricular_fk foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular);
alter table estudiante add constraint id_usuario_fk foreign key(id_usuario) references usuario(id_usuario);
alter table estudiante add constraint chk_estudiante_promedio check(promedio >=0 and promedio <=5.0);

insert into estudiante(id_estudiante, identificacion, nombre, apellido, promedio, matriculas_restantes, email, id_proyecto_curricular, id_usuario) values (1, '20131020001', 'jhon', 'doe', 4.5, 8, 'jhon@email.com', 2, 1);


/**************** SOLICITUD APOYO ALIMENTARIO ************************/

-- create table estado_solicitud(
  -- id_estado_solicitud serial primary key,
  -- estado varchar(30) not null,
  -- descripcion varchar(200)
-- );

create table estado_solicitud(
  id_estado_solicitud number(2,0) not null,
  estado varchar2(30 BYTE) not null,
  descripcion varchar(200),
  constraint estado_solicitud_pk primary key (id_estado_solicitud) enable);

insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 1, 'en progreso', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 2, 'completada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 3, 'rechazada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 4, 'cancelada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 5, 'aprobada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 6, 'requiere cambios', '');


-- create table solicitud(
  -- id_solicitud serial primary key,
  -- id_estudiante integer not null,
  -- puntaje smallint constraint chk_puntaje_in_zero_hundred_range check(puntaje >=0 and puntaje <=100),
  -- ultima_actualizacion timestamp not null default current_timestamp,
  -- id_estado_solicitud integer default 1,
  -- id_convocatoria integer not null,
  -- foreign key (id_convocatoria) references convocatoria(id_convocatoria),
  -- foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  -- foreign key (id_estudiante) references estudiante(id_estudiante),
  -- unique(id_convocatoria, id_estudiante)
-- );
--nota default timestamp
create table solicitud(
  id_solicitud number(2,0) not null,
  id_estudiante number(11,0) not null,
  puntaje number(3,0),
  ultima_actualizacion timestamp not null,
  id_estado_solicitud number(1,0) default 1,
  id_convocatoria number(2,0) not null,
  constraint solicitud_pk primary key (id_solicitud) enable);

alter table solicitud add constraint chk_puntaje_in_zero check(puntaje >=0 and puntaje <=100);
alter table solicitud add constraint id_convocatoria_fk foreign key (id_convocatoria) references convocatoria(id_convocatoria);
alter table solicitud add constraint id_estado_solicitud_fk foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud);
alter table solicitud add constraint id_estudiante foreign key (id_estudiante) references estudiante(id_estudiante);
alter table solicitud add constraint uq_id_convocatoria unique(id_convocatoria);
alter table solicitud add constraint uq_id_estudiante unique(id_estudiante);

-- create table historico_solicitud(
  -- id_historico_solicitud serial primary key,
  -- id_solicitud integer not null,
  -- id_estado_solicitud integer not null,
  -- foreign key(id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  -- foreign key(id_solicitud) references solicitud(id_solicitud),
  -- fecha timestamp not null
-- );

create table historico_solicitud(
  id_historico_solicitud number(2,0) not null,
  id_solicitud number(2,0) not null,
  id_estado_solicitud number(2,0) not null,
  fecha timestamp not null,
  constraint historico_solicitud_pk primary key (id_historico_solicitud) enable);

alter table historico_solicitud add constraint id_estado_his_solicitud_fk foreign key(id_estado_solicitud) references estado_solicitud(id_estado_solicitud);
alter table historico_solicitud add constraint id_solicitud_fk foreign key(id_solicitud) references solicitud(id_solicitud);
  

-- create table documento_solicitud(
  -- id_solicitud integer not null,
  -- id_puntaje_tipo_documento integer,
  -- id_estado_documento integer,
  -- id_tipo_documento integer not null,
  -- comentarios varchar(300),
  -- url varchar(200) not null,
  -- necesita_cambios numeric(1,0) default 0,
  -- revisado numeric(1,0) default 0,
  -- foreign key(id_estado_documento) references estado_documento(id_estado_documento),
  -- foreign key(id_solicitud) references solicitud(id_solicitud) on delete cascade,
  -- foreign key(id_puntaje_tipo_documento) references puntaje_tipo_documento(id_puntaje_tipo_documento),
  -- foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento),
  -- primary key(id_solicitud, id_tipo_documento)
-- );

create table documento_solicitud(
  id_solicitud number(2,0) not null,
  id_puntaje_tipo_documento number(2,0),
  id_estado_documento number(2,0),
  id_tipo_documento number(2,0) not null,
  comentarios varchar2(300 BYTE),
  url varchar2(200 BYTE) not null,
  necesita_cambios number(1,0) default 0,
  revisado number(1,0) default 0,
  constraint documento_solicitud_pk primary key (id_solicitud, id_tipo_documento) enable);
  
alter table documento_solicitud add constraint id_estado_documento_fk foreign key(id_estado_documento) references estado_documento(id_estado_documento);
alter table documento_solicitud add constraint id_solicitud_documento_fk foreign key(id_solicitud) references solicitud(id_solicitud) on delete cascade;
alter table documento_solicitud add constraint id_puntaje_tipo_documento_fk foreign key(id_puntaje_tipo_documento) references puntaje_tipo_documento(id_puntaje_tipo_documento);
alter table documento_solicitud add constraint id_tipo_documento_solicitud_fk foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento);


/**************** PUNTAJES Y SUBSIDIOS ************************/



-- create table tipo_subsidio(
  -- id_tipo_subsidio serial primary key,
  -- nombre varchar(30) not null,
  -- descripcion varchar(200),
  -- porcentaje_subsidiado smallint not null constraint chk_tipo_subsidiado_porcentaje_in_zero_hundred_range check(porcentaje_subsidiado>=0 and porcentaje_subsidiado<=100),
  -- puntos_requeridos  smallint not null constraint chk_tipo_subsidiado_puntos_requeridos_greater_than_zero check( puntos_requeridos>=0),
  -- horas_semanales_a_cumplir smallint not null
-- );

create table tipo_subsidio(
  id_tipo_subsidio number(2,0) not null,
  nombre varchar2(30 BYTE) not null,
  descripcion varchar2(200 BYTE),
  porcentaje_subsidiado number(3,0) not null,
  puntos_requeridos  number(3,0) not null,
  horas_semanales_a_cumplir number(3,0) not null,
  constraint tipo_subsidio_pk primary key (id_tipo_subsidio) enable);

alter table tipo_subsidio add constraint chk_tipo_subsidiado_porcentaje check(porcentaje_subsidiado>=0 and porcentaje_subsidiado<=100);
alter table tipo_subsidio add constraint chk_tipo_subsidiado_puntos check( puntos_requeridos>=0);

insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(1, 'tipo A',100, 90, 30);
insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(2, 'tipo B',70, 80, 40);


-- create table convocatoria_facultad(
  -- id_facultad  integer not null,
  -- id_convocatoria integer not null,
  -- cantidad_de_almuerzos smallint not null constraint chk_convocatoria_facultad_cantidad_almuerzos_greater_than_zero check(cantidad_de_almuerzos>=0),
  -- primary key(id_facultad, id_convocatoria),
  -- foreign key( id_convocatoria) references convocatoria(id_convocatoria)  on delete cascade,
  -- foreign key( id_facultad) references facultad(id_facultad)
-- );

create table convocatoria_facultad(
  id_facultad number(2,0) not null,
  id_convocatoria number(2,0) not null,
  cantidad_de_almuerzos number(4,0) not null,
  constraint convocatoria_facultad_pk primary key(id_facultad, id_convocatoria) enable);

alter table convocatoria_facultad add constraint id_convocatoria_facultad_fk foreign key( id_convocatoria) references convocatoria(id_convocatoria)  on delete cascade;
alter table convocatoria_facultad add constraint id_facultad__fk foreign key( id_facultad) references facultad(id_facultad);
alter table convocatoria_facultad add constraint chk_conv_facultad_cantidad check(cantidad_de_almuerzos>=0);

-- create table tipo_subsidio_convocatoria(
  -- id_convocatoria integer not null,
  -- id_tipo_subsidio integer not null,
  -- cantidad_de_almuerzos_ofertados  smallint constraint chk_subsidio_periodo_cantidad_almuerzos_positive check(cantidad_de_almuerzos_ofertados>=0),
  -- foreign key( id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  -- foreign key (id_convocatoria) references convocatoria(id_convocatoria) on delete cascade,
  -- primary key(id_tipo_subsidio, id_convocatoria)
-- );

create table tipo_subsidio_convocatoria(
  id_convocatoria number(2,0) not null,
  id_tipo_subsidio number(2,0) not null,
  cant_almuerzos_ofertados  number(3,0), 
  constraint tipo_subsidio_convocatoria_pk primary key(id_tipo_subsidio, id_convocatoria) enable);

alter table tipo_subsidio_convocatoria add constraint id_tipo_subsidio_fk foreign key( id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio);
alter table tipo_subsidio_convocatoria add constraint id_convocatoria_tipo_fk foreign key (id_convocatoria) references convocatoria(id_convocatoria) on delete cascade;
alter table tipo_subsidio_convocatoria add constraint chk_antidad_almuerzos check(cant_almuerzos_ofertados>=0);
/**************** TICKET and BENEFICIARIO ************************/
-- create table beneficiario(
  -- id_beneficiario serial primary key,
  -- id_tipo_subsidio integer not null,
  -- id_solicitud integer not null,
  -- foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  -- foreign key (id_solicitud) references solicitud(id_solicitud)
-- );

create table beneficiario(
  id_beneficiario number(3,0) not null,
  id_tipo_subsidio number(2,0) not null,
  id_solicitud number(2,0) not null,
  constraint beneficiario_pk primary key (id_beneficiario) enable);

alter table beneficiario add constraint id_tipo_subsidio_benef_fk foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio);
alter table beneficiario add constraint id_solicitud_beneficiario_fk foreign key (id_solicitud) references solicitud(id_solicitud);

-- create table ticket(
  -- id_ticket serial primary key,
  -- id_beneficiario integer not null,
  -- fecha_creacion timestamp default current_timestamp,
  -- fecha_uso timestamp,
  -- id_tipo_ticket varchar(15) constraint chk_ticket_tipo_in_defined_types check(id_tipo_ticket in('refrigerio', 'almuerzo')),
  -- foreign key (id_beneficiario) references beneficiario(id_beneficiario)
-- );

create table ticket(
  id_ticket number(2,0) not null,
  id_beneficiario number (3,0) not null,
  fecha_creacion timestamp default current_timestamp,
  fecha_uso timestamp,
  id_tipo_ticket varchar2(15 BYTE),
  constraint ticket_pk primary key (id_ticket) enable);
  
alter table ticket add constraint id_beneficiario_fk foreign key (id_beneficiario) references beneficiario(id_beneficiario);
alter table ticket add constraint chk_ticket_tipo check(id_tipo_ticket in('refrigerio', 'almuerzo'));

/**************** ACTIVIDADES ************************/

-- create table estado_actividad(
  -- id_estado_actividad serial primary key,
  -- nombre varchar(200) not null,
  -- descripcion varchar(2000)
-- );

create table estado_actividad(
  id_estado_actividad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  descripcion varchar2(2000 BYTE),
  constraint estado_actividad_pk primary key (id_estado_actividad) enable);


-- create table actividad(
  -- id_actividad serial primary key,
  -- nombre varchar(200) not null,
  -- descripcion varchar(1000),
  -- horas_equivalentes smallint not null constraint chk_actividad_horas_positive check(horas_equivalentes >=0)
-- );

create table actividad(
  id_actividad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  descripcion varchar2(1000 BYTE),
  horas_equivalentes number(3,0) not null,
  constraint actividad_pk primary key (id_actividad) enable);

alter table actividad add constraint chk_actividad_horas_positive check(horas_equivalentes >=0);

-- create table responsable_actividad(
  -- id_responsable serial primary key,
  -- id_usuario integer not null,
  -- nombre varchar(30) not null,
  -- email varchar(100),
  -- foreign key (id_usuario) references usuario(id_usuario)
-- );

create table responsable_actividad(
  id_responsable number(2,0) not null,
  id_usuario number(11,0) not null,
  nombre varchar(30) not null,
  email varchar2(100 BYTE),
  constraint responsable_actividad_pk primary key (id_responsable) enable);
  
alter table responsable_actividad add constraint id_usuario_responsable_fk foreign key (id_usuario) references usuario(id_usuario);


-- create table actividad_beneficiario(
  -- id_actividad_beneficiario serial primary key,
  -- id_beneficiario integer,
  -- id_actividad integer,
  -- id_estado_actividad integer,
  -- id_responsable integer
-- );

create table actividad_beneficiario(
  id_actividad_beneficiario number(2,0) not null,
  id_beneficiario number(2,0),
  id_actividad number(2,0),
  id_estado_actividad number(2,0),
  id_responsable number(2,0),
  constraint actividad_beneficiario_pk primary key (id_actividad_beneficiario) enable);

/**************** PARAMETROS ************************/

-- create table parametro(
  -- id_parametro serial primary key,
  -- nombre_tabla varchar(30),
  -- clave varchar(100),
  -- valor varchar(100)
-- );



/* costo almuerzo, costo refrigerio, verificado(SI, NO)*/

