/****** Eliminación ordenada de tablas ******/
SET NOCOUNT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Eliminar tablas con dependencias primero
    PRINT 'Eliminando tablas dependientes...';
    DROP TABLE IF EXISTS Email;
    DROP TABLE IF EXISTS MovimientoDebitoDisfrute;
    DROP TABLE IF EXISTS Movimiento;
    DROP TABLE IF EXISTS SolicitudVacacion;
    DROP TABLE IF EXISTS Supervisor;
    DROP TABLE IF EXISTS Empleado;
    
    -- Luego tablas independientes
    PRINT 'Eliminando tablas base...';
    DROP TABLE IF EXISTS Puesto;
    DROP TABLE IF EXISTS TipoMovimiento;
    DROP TABLE IF EXISTS TipoEvento;
    DROP TABLE IF EXISTS Usuario;
    DROP TABLE IF EXISTS Error;
    DROP TABLE IF EXISTS Feriado;
    
    PRINT 'Todas las tablas eliminadas exitosamente.';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    PRINT 'Error durante la eliminación: ' + ERROR_MESSAGE();
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;
GO

SET NOCOUNT OFF;
GO