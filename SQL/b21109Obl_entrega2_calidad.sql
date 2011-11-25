CREATE TABLE Calidad (
	nroExamen number(4) not null,
	fecha date not null,
	totalAlumnos number(10) not null check (totalAlumnos >= 0),
	totalAprobados number(10) not null check (totalAprobados >= 0),
	totalEliminados number(10) not null check (totalEliminados >= 0),
	Primary key (nroExamen, fecha)
)