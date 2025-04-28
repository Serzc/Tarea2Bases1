CREATE OR ALTER PROCEDURE [dbo].[sp_EliminarEmpleado]
    @idEmpleado INT,
    @idPostByUser INT,
    @PostInIP VARCHAR(64),
    @CodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Resultado INT;
    DECLARE @TipoEvento INT = 9; -- Intento de borrado (10 si se confirma)
    DECLARE @NombreEmpleado VARCHAR(64);
    DECLARE @Documento VARCHAR(16);
    DECLARE @Puesto VARCHAR(64);

	DECLARE @EstadoError VARCHAR(16);
	DECLARE @Error_line INT;
	DECLARE @ErrorMessage NVARCHAR(128);
    BEGIN TRY
        BEGIN TRANSACTION;
			
        -- Obtener datos del empleado para la bitácora
        SELECT 
            @NombreEmpleado = E.Nombre,
            @Documento = E.ValorDocumentoIdentidad,
            @Puesto = P.Nombre
        FROM dbo.Empleado AS E
        JOIN Puesto AS P ON E.idPuesto = P.id
        WHERE E.id = @idEmpleado AND E.EsActivo = 1;

        -- Validar que el empleado exista
        IF @NombreEmpleado IS NULL
        BEGIN
            SET @CodigoError = 50013; -- Empleado no encontrado o ya inactivo
            ROLLBACK;
			SET @EstadoError = 5;
			SET @Error_line = 31;
			SET @ErrorMessage  = 'Empleado no encontrado o ya inactivo';
			EXEC logError 
				@idPostByUser,
				@CodigoError,
				@EstadoError,
				'High',
				@Error_line,
				'sp_EliminarEmpleado',
				@ErrorMessage,
				@Resultado OUTPUT;
            RETURN;
        END;

       
        UPDATE dbo.Empleado 
        SET EsActivo = 0 
        WHERE id = @idEmpleado;

       
        SET @TipoEvento = 10; -- Borrado exitoso
        DECLARE @Descripcion VARCHAR(128)= CONCAT(
            'Empleado eliminado: ', @NombreEmpleado, 
            ' (Documento: ', @Documento, ', Puesto: ', @Puesto, ')'
        );
        EXEC logEvent 
            @TipoEvento, 
            @idPostByUser, 
            @Descripcion, 
            @PostInIP, 
            @Resultado OUTPUT;

        COMMIT;
        SET @CodigoError = 0; -- Éxito
    END TRY
    BEGIN CATCH
        ROLLBACK;
        SET @CodigoError = 50008; -- Error de BD
        SET @EstadoError = ERROR_STATE();
        SET @Error_line  = ERROR_LINE();
        SET @ErrorMessage  = ERROR_MESSAGE();
        EXEC logError 
            @idPostByUser,
            @CodigoError,
            @EstadoError,
            'High',
            @Error_line,
            'sp_EliminarEmpleado',
            @ErrorMessage,
            @Resultado OUTPUT;
    END CATCH;
END;