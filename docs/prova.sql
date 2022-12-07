DROP DATABASE IF EXISTS provabcd;
CREATE DATABASE provabcd CHARSET=UTF8 COLLATE UTF8_GENERAL_CI;

USE provabcd;

CREATE TABLE Professores(
    id_prof integer primary key not null auto_increment,
    nome_prof varchar(50) not null,
    formacao varchar(100) not null
);

CREATE TABLE Telefones(
    id integer primary key not null auto_increment,
    id_prof integer not null,
    telProf varchar(14) not null,
    foreign key (id_prof) references Professores(id_prof) on delete cascade
);

CREATE TABLE Turmas(
    cod_turma integer primary key not null auto_increment,
    id_prof integer not null,
    horario varchar(5) not null,
    tipo varchar(50) not null,
    foreign key (id_prof) references Professores(id_prof)
);

CREATE TABLE Alunos(
    ra integer primary key not null auto_increment,
    cod_turma integer not null,
    nome_aluno varchar(50) not null,
    sexo varchar(1) not null,
    dnascimento date not null,
    foreign key (cod_turma) references Turmas(cod_turma)
);

CREATE TABLE Disciplinas(
    id_Disc integer primary key not null auto_increment,
    cod_turma integer not null,
    nomeDisc varchar(50) not null,
    foreign key (cod_turma) references Turmas(cod_turma)
);

CREATE TABLE Horarios(
    id_Hor integer primary key not null auto_increment,
    id_Disc integer not null,
    inicio time not null,
    fim time not null,
    foreign key (id_Disc) references Disciplinas(id_Disc)
);

SHOW TABLES;

DESCRIBE Professores;
DESCRIBE Telefones;
DESCRIBE Turmas;
DESCRIBE Diciplinas;
DESCRIBE Alunos; 
DESCRIBE Horarios; 

insert into Professores(id_prof, nome_prof, formacao) values 
(default,"Rogerio","Ensino Medio Completo"),
(default,"Miguel","Mestrado");
insert into Telefones(id, id_prof, telProf) values 
(default,1,"(19)97109_1267"),
(default,1,"(19)12345_6789"),
(default,2,"(19)98765_4321"),
(default,2,"(19)99999_9999");
insert into Turmas(cod_turma, id_prof, horario, tipo) values 
(default,1,"manha","portador de necessidades especiais"),
(default,2,"tarde","velho"),
(default,2,"noite","jovem");
insert into Alunos(ra, cod_turma, nome_aluno, sexo, dnascimento) values 
(default,1,"Gui","M","2003/03/15"),
(default,1,"Biel","M","2002/11/21"),
(default,1,"Ju","H","2004/09/18"),
(default,2,"Kauan","M","2003/03/16"),
(default,2,"Mateus","H","2003/02/25"),
(default,2,"Gusta","M","1512/01/01"),
(default,3,"Italo","H","2002/12/02"),
(default,3,"Paixao","M","2003/06/11"),
(default,3,"Vitorinha","H","2002/11/06");
insert into Disciplinas(id_Disc, cod_turma, nomeDisc) values 
(default,1,"lambada"),
(default,1,"salsa"),
(default,2,"samba"),
(default,2,"valsa"),
(default,3,"hiphop"),
(default,3,"zumba");
insert into Horarios(id_Hor, id_Disc,inicio, fim) values 
(default,1,"07:30","09:30"),
(default,2,"09:30","11:30"),
(default,3,"13:30","15:30"),
(default,4,"15:30","17:30"),
(default,5,"19:30","21:30"),
(default,6,"19:30","21:30"),
(default,6,"21:30","23:30");

select * from Professores;
select * from Telefones;
select * from Turmas;
select * from Disciplinas;
select * from Alunos;
select * from Horarios;

CREATE VIEW vw_professores AS
SELECT p.id_prof AS id_prof, p.nome_prof, p.formacao, t.id AS id, t.telProf
FROM Telefones t
INNER JOIN Professores p ON p.id_prof = t.id;

select * from vw_professores;

create view vw_prof_turma as
select t.id_prof, p.nome_prof, t.tipo
from Professores p inner join Turmas t;

select * from vw_prof_turma;

CREATE VIEW vw_turmas_alunos AS
SELECT t.cod_turma AS cod_turma, t.tipo, a.ra AS ra, a.nome_aluno, a.sexo, (SELECT YEAR(CURDATE())-YEAR(a.dnascimento)-IF(MONTH(CURDATE())*32+DAY(CURDATE())<MONTH(a.dnascimento)*32+DAY(a.dnascimento),1,0) as idade)
FROM Alunos a
INNER JOIN Turmas t ON t.cod_turma = a.ra;

select * from vw_turmas_alunos;

CREATE VIEW vw_turmas_disc AS
SELECT t.cod_turma AS cod_turma, t.tipo, d.id_Disc AS id_Disc, d.nomeDisc
FROM Turmas t
INNER JOIN Disciplinas d ON t.cod_turma = d.id_Disc;

select * from vw_turmas_disc;

CREATE VIEW vw_disc_horario AS
SELECT d.id_Disc AS id_Disc, d.nomeDisc, h.id_Hor AS id_Hor, h.inicio, h.fim
FROM Disciplinas d
INNER JOIN Horarios h ON d.id_Disc = h.id_Hor;

select * from vw_disc_horario;
