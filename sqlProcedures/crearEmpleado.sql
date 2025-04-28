USE [tarea2BD1]
GO
/****** Object:  StoredProcedure [dbo].[sp_CrearEmpleado]    Script Date: 4/27/2025 8:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_CrearEmpleado]
    @idPuesto INT,
    @ValorDocumentoIdentidad VARCHAR(16),
    @Nombre VARCHAR(64),
    @FechaContratacion DATE,
    @idPostByUser INT,
    @PostInIP VARCHAR(64),
    @CodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Resultado INT;
    DECLARE @TipoEvento INT = 6; -- Inserción exitosa
    DECLARE @Descripcion VARCHAR(256);
    DECLARE @NuevoId INT;

	DECLARE @EstadoError VARCHAR(16);
	DECLARE @Error_line INT;
	DECLARE @ErrorMessage NVARCHAR(128);

    BEGIN TRY
        BEGIN TRANSACTION;
			
			
        --Validaciones
        IF @Nombre LIKE '%[^a-zA-Z ]%'
        BEGIN
            SET @CodigoError = 50009;
            
			SET @EstadoError = 1;
			SET @Error_line = 28;
			SET @ErrorMessage  = 'Nombre con caracteres numéricos';
			EXEC logError 
				@idPostByUser,
				@CodigoError,
				@EstadoError,
				'High',
				@Error_line,
				'sp_CrearEmpleado',
				@ErrorMessage,
				@Resultado OUTPUT;
            RETURN;
			ROLLBACK;
        END;

        IF @ValorDocumentoIdentidad LIKE '%[^0-9]%'
        BEGIN
            SET @CodigoError = 50010;
			SET @EstadoError = 2;
			SET @Error_line = 50;
			SET @ErrorMessage  = 'Valor Documento identidad no numérico';
			EXEC logError 
				@idPostByUser,
				@CodigoError,
				@EstadoError,
				'High',
				@Error_line,
				'sp_CrearEmpleado',
				@ErrorMessage,
				@Resultado OUTPUT;
            ROLLBACK;

            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = @ValorDocumentoIdentidad)
        BEGIN
            SET @CodigoError = 50004;
           
			SET @EstadoError = 3;
			SET @Error_line = 70;
			SET @ErrorMessage  = 'Documento ya existente';
			EXEC logError 
				@idPostByUser,
				@CodigoError,
				@EstadoError,
				'High',
				@Error_line,
				'sp_CrearEmpleado',
				@ErrorMessage,
				@Resultado OUTPUT;
			ROLLBACK;
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Empleado WHERE Nombre = @Nombre)
        BEGIN
            SET @CodigoError = 50005;
            
			SET @EstadoError = 4;
			SET @Error_line = 89;
			SET @ErrorMessage  = 'Nombre ya existente';
			EXEC logError 
				@idPostByUser,
				@CodigoError,
				@EstadoError,
				'High',
				@Error_line,
				'sp_CrearEmpleado',
				@ErrorMessage,
				@Resultado OUTPUT;
			ROLLBACK;
            RETURN;
        END;

        
        SELECT @NuevoId = ISNULL(MAX(id), 0) + 1 FROM Empleado;

        
        INSERT INTO Empleado (
            id,
            idPuesto,
            ValorDocumentoIdentidad,
            Nombre,
            FechaContratacion,
            EsActivo
        )
        VALUES (
            @NuevoId,
            @idPuesto,
            @ValorDocumentoIdentidad,
            @Nombre,
            @FechaContratacion,
            1
        );

       
        SET @Descripcion = CONCAT(
            'Nuevo empleado ID ', @NuevoId, ': ', 
            @Nombre, ' (Documento: ', @ValorDocumentoIdentidad, ')'
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
        SET @CodigoError = 50008;
        SET @EstadoError = ERROR_STATE();
        SET @Error_line  = ERROR_LINE();
        SET @ErrorMessage= ERROR_MESSAGE();
        EXEC logError 
            @idPostByUser,
            @CodigoError,
            @EstadoError,
            'High',
            @Error_line,
            'sp_CrearEmpleado',
            @ErrorMessage,
            @Resultado OUTPUT;
    END CATCH;
END;