create schema neon;

create table idade(
	adate date,
	atime time,
	atimest timestamp
);
insert into idade (adate,atime,atimest) values ('2021-07-13','19:31:50.123',current_timestamp);

select *
from idade;

select current_date as Data_Atual, current_time as Hora_atual;

create table bask(
	aa int,
	bb int,
	cc int
);
insert into bask(aa,bb,cc) values ('1','2','4');

select *
from bask

select ((bb + |/((bb^'2')-('4'*aa*cc))/('2'*aa))
from bask

select bb^2 as at1, '-4'*aa*cc as at2, '2'*aa as at3, at1 + at2  as at0
from bask

		
