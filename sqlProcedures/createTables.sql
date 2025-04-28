CREATE TABLE Puesto (
    id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(64) NOT NULL,
    SalarioxHora DECIMAL(10, 2) NOT NULL
);


CREATE TABLE Empleado (
    id INT PRIMARY KEY,
    idPuesto INT NOT NULL,
    IdSupervisor INT NULL,
    ValorDocumentoIdentidad VARCHAR(16) NOT NULL UNIQUE,
    Nombre VARCHAR(64) NOT NULL,
    FechaContratacion DATE NOT NULL,
    SaldoVacaciones INT NOT NULL DEFAULT 0,
    email VARCHAR(32) NULL,
    EsActivo BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Empleado_Puesto FOREIGN KEY (idPuesto) REFERENCES Puesto(id),
    CONSTRAINT FK_Empleado_Supervisor FOREIGN KEY (IdSupervisor) REFERENCES Empleado(id)
);


CREATE TABLE Supervisor (
    idEmpleado INT PRIMARY KEY,
    CONSTRAINT FK_Supervisor_Empleado FOREIGN KEY (idEmpleado) REFERENCES Empleado(id)
);


CREATE TABLE TipoEvento (
    id INT PRIMARY KEY,
    Nombre VARCHAR(64) NOT NULL,
);

CREATE TABLE BitacoraEvento (
    id INT PRIMARY KEY,
    idTipoEvento INT NOT NULL,
    idPostByUser INT NOT NULL,
    Descripcion VARCHAR(128),
    PostInIP VARCHAR(64) NOT NULL,
	PostTime DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Bitacora_TipoEvento FOREIGN KEY (idTipoEvento) REFERENCES TipoEvento(id),
    CONSTRAINT FK_Bitacora_Usuario FOREIGN KEY (idPostByUser) REFERENCES Usuario(id),
);



CREATE TABLE SolicitudVacacion (
    id INT PRIMARY KEY IDENTITY(1,1),
    idEmpleado INT NOT NULL,
    IdSupervisorAprueba INT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    QDiasSolicitados INT NOT NULL,
    SaldoQDiasSolicitados DECIMAL(10, 2) NOT NULL,
    Estado TINYINT NOT NULL DEFAULT 0 CHECK (Estado IN (0, 1, 2)), -- 0:Pendiente, 1:Aprobado, 2:Rechazado
    CONSTRAINT FK_Solicitud_Empleado FOREIGN KEY (idEmpleado) REFERENCES Empleado(id),
    CONSTRAINT FK_Solicitud_Supervisor FOREIGN KEY (IdSupervisorAprueba) REFERENCES Supervisor(idEmpleado)
);

CREATE TABLE TipoMovimiento (
    id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(64) NOT NULL,
    TipoAccion VARCHAR(16) NOT NULL CHECK (TipoAccion IN ('Credito', 'Debito')) 
);


CREATE TABLE Movimiento (
    id INT PRIMARY KEY IDENTITY(1,1),
	idEmpleado INT NOT NULL,
	idTipoMovimiento INT NOT NULL,
	Fecha DATE NOT NULL DEFAULT GETDATE(),
	Monto DECIMAL(10, 2) NOT NULL,
    NuevoSaldo DECIMAL(10, 2) NOT NULL,
	idPostByUser INT NOT NULL,
	PostInIP VARCHAR(64) NOT NULL,
	PostTime DATETIME NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT FK_Movimiento_Tipo FOREIGN KEY (idTipoMovimiento) REFERENCES TipoMovimiento(id),
    CONSTRAINT FK_Movimiento_Empleado FOREIGN KEY (idEmpleado) REFERENCES Empleado(id),
    CONSTRAINT FK_Movimiento_Usuario FOREIGN KEY (idPostByUser) REFERENCES Usuario(id),
);


CREATE TABLE MovimientoDebitoDisfrute (
    idMovimiento INT PRIMARY KEY,
    IdSolicitudVacacion INT NOT NULL,
    CONSTRAINT FK_DebitoDisfrute_Movimiento FOREIGN KEY (idMovimiento) REFERENCES Movimiento(id),
    CONSTRAINT FK_DebitoDisfrute_Solicitud FOREIGN KEY (IdSolicitudVacacion) REFERENCES SolicitudVacacion(id)
);


CREATE TABLE Email (
    id INT PRIMARY KEY IDENTITY(1,1),
    idMovimiento INT NOT NULL,
    Texto NVARCHAR(MAX) NOT NULL,
    CONSTRAINT FK_Email_Movimiento FOREIGN KEY (idMovimiento) REFERENCES Movimiento(id)
);

CREATE TABLE Error (
	Codigo INT PRIMARY KEY,
	Descripcion VARCHAR(128)
);

CREATE TABLE DBError (
    id INT PRIMARY KEY IDENTITY(1,1),
    UserName VARCHAR(32) NOT NULL,
    ErrorNumber INT NOT NULL,
    ErrorState VARCHAR(16) NOT NULL,
    Severity VARCHAR(16) NOT NULL,
    ErrorLine INT NOT NULL,
    OriginProcedure VARCHAR(16) NOT NULL,
    ErrorMessage VARCHAR (128),
    ErrorDatetime DATETIME NOT NULL DEFAULT GETDATE(),
);

CREATE TABLE Usuario (
	id INT PRIMARY KEY,
	Nombre VARCHAR(32) NOT NULL,
	Pass   VARCHAR(16) NOT NULL,
);

CREATE TABLE Feriado (
	id INT PRIMARY KEY IDENTITY(1,1),
	Fecha DATE NOT NULL,
	Descripcion VARCHAR(128)
);