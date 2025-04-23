
CREATE TABLE Puesto (
    id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    SalarioxHora DECIMAL(10, 2) NOT NULL
);


CREATE TABLE Empleado (
    id INT PRIMARY KEY IDENTITY(1,1),
    idPuesto INT NOT NULL,
    IdSupervisor INT NULL,
    ValorDocIdentidad NVARCHAR(20) NOT NULL UNIQUE,
    Nombre NVARCHAR(100) NOT NULL,
    FechaContratacion DATE NOT NULL,
    SaldoVacaciones DECIMAL(10, 2) NOT NULL DEFAULT 0,
    email NVARCHAR(100) NULL,
    EsActivo BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Empleado_Puesto FOREIGN KEY (idPuesto) REFERENCES Puesto(id),
    CONSTRAINT FK_Empleado_Supervisor FOREIGN KEY (IdSupervisor) REFERENCES Empleado(id)
);


CREATE TABLE Supervisor (
    idEmpleado INT PRIMARY KEY,
    CONSTRAINT FK_Supervisor_Empleado FOREIGN KEY (idEmpleado) REFERENCES Empleado(id)
);


CREATE TABLE TipoMovimiento (
    id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Accion CHAR(1) NOT NULL CHECK (Accion IN ('C', 'D')) -- C: Crédito, D: Débito
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


CREATE TABLE Movimiento (
    id INT PRIMARY KEY IDENTITY(1,1),
    IdEmpleado INT NOT NULL,
    idTipoMovimiento INT NOT NULL,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    Monto DECIMAL(10, 2) NOT NULL,
    VisibleFlag BIT NOT NULL DEFAULT 1,
    PostTime DATETIME NOT NULL DEFAULT GETDATE(),
    IdPostUser INT NOT NULL,
    PostIP NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_Movimiento_Empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado(id),
    CONSTRAINT FK_Movimiento_Tipo FOREIGN KEY (idTipoMovimiento) REFERENCES TipoMovimiento(id)
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

