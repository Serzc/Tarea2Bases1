USE [tarea2BD1]
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarEmpleado]    Script Date: 4/27/2025 8:05:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ActualizarEmpleado]
    @idEmpleado INT,
    @NuevoNombre VARCHAR(64) = NULL,
    @NuevoDocumento VARCHAR(16) = NULL,
    @NuevoIdPuesto INT = NULL,
    @idPostByUser INT,
    @PostInIP VARCHAR(64),
    @CodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Resultado INT;
    DECLARE @TipoEvento INT = 8; -- Update exitoso (7 si falla)
    DECLARE @Descripcion VARCHAR(256);
    DECLARE @ValoresAntes VARCHAR(MAX);
    DECLARE @ValoresDespues VARCHAR(MAX);

	DECLARE @EstadoError VARCHAR(16);
	DECLARE @Error_line INT;
	DECLARE @ErrorMessage NVARCHAR(128);

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Obtener valores actuales para bitácora
        SELECT 
            @ValoresAntes = CONCAT(
                'Nombre: ', E.Nombre, ', ',
                'Documento: ', E.ValorDocumentoIdentidad, ', ',
                'Puesto: ', P.Nombre
            )
        FROM Empleado E
        JOIN Puesto P ON E.idPuesto = P.id
        WHERE E.id = @idEmpleado;

        -- Validar y actualizar cada campo si es diferente
        IF @NuevoNombre IS NOT NULL
        BEGIN
            -- Validar nombre alfabético
            IF @NuevoNombre LIKE '%[^a-zA-Z ]%'
            BEGIN
                SET @CodigoError = 50009; -- Nombre no alfabético
                
				SET @EstadoError = 6;
				SET @Error_line = 47;
				SET @ErrorMessage  = 'Nombre con caracteres numéricos';
				EXEC logError 
					@idPostByUser,
					@CodigoError,
					@EstadoError,
					'High',
					@Error_line,
					'sp_ActualizarEmpleado',
					@ErrorMessage,
					@Resultado OUTPUT;
				ROLLBACK;
                RETURN;
            END;

            -- Validar unicidad
            IF EXISTS (SELECT 1 FROM Empleado WHERE Nombre = @NuevoNombre AND id <> @idEmpleado)
            BEGIN
                SET @CodigoError = 50007; -- Nombre ya existe
                
				SET @EstadoError = 7;
				SET @Error_line = 67;
				SET @ErrorMessage  = 'Nombre ya existe';
				EXEC logError 
					@idPostByUser,
					@CodigoError,
					@EstadoError,
					'High',
					@Error_line,
					'sp_ActualizarEmpleado',
					@ErrorMessage,
					@Resultado OUTPUT;
				ROLLBACK;
                RETURN;
            END;

            UPDATE Empleado SET Nombre = @NuevoNombre WHERE id = @idEmpleado;
        END;

        IF @NuevoDocumento IS NOT NULL
        BEGIN
            
            IF @NuevoDocumento LIKE '%[^0-9]%'
            BEGIN
                SET @CodigoError = 50010; -- Documento no numérico
                
				SET @EstadoError = 8;
				SET @Error_line = 92;
				SET @ErrorMessage  = 'Documento no numérico';
				EXEC logError 
					@idPostByUser,
					@CodigoError,
					@EstadoError,
					'High',
					@Error_line,
					'sp_ActualizarEmpleado',
					@ErrorMessage,
					@Resultado OUTPUT;
				ROLLBACK;
                RETURN;
            END;

            -- Validar unicidad
            IF EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = @NuevoDocumento AND id <> @idEmpleado)
            BEGIN
                SET @CodigoError = 50006; -- Documento ya existe
                
				SET @EstadoError = 9;
				SET @Error_line = 112;
				SET @ErrorMessage  = 'Documento ya existe';
				EXEC logError 
					@idPostByUser,
					@CodigoError,
					@EstadoError,
					'High',
					@Error_line,
					'sp_ActualizarEmpleado',
					@ErrorMessage,
					@Resultado OUTPUT;
				ROLLBACK;
                RETURN;
            END;

            UPDATE Empleado SET ValorDocumentoIdentidad = @NuevoDocumento WHERE id = @idEmpleado;
        END;

        IF @NuevoIdPuesto IS NOT NULL
        BEGIN
            -- Validar puesto existente
            IF NOT EXISTS (SELECT 1 FROM Puesto WHERE id = @NuevoIdPuesto)
            BEGIN
                SET @CodigoError = 50012; -- Puesto no existe
               
				SET @EstadoError = 10;
				SET @Error_line = 137;
				SET @ErrorMessage  = 'Puesto no existe';
				EXEC logError 
					@idPostByUser,
					@CodigoError,
					@EstadoError,
					'High',
					@Error_line,
					'sp_ActualizarEmpleado',
					@ErrorMessage,
					@Resultado OUTPUT;
				ROLLBACK;
                RETURN;
            END;

            UPDATE Empleado SET idPuesto = @NuevoIdPuesto WHERE id = @idEmpleado;
        END;

        -- Obtener valores después de actualizar
        SELECT 
            @ValoresDespues = CONCAT(
                'Nombre: ', ISNULL(@NuevoNombre, E.Nombre), ', ',
                'Documento: ', ISNULL(@NuevoDocumento, E.ValorDocumentoIdentidad), ', ',
                'Puesto: ', P.Nombre
            )
        FROM Empleado E
        JOIN Puesto P ON E.idPuesto = P.id
        WHERE E.id = @idEmpleado;

        -- Registrar en bitácora
        SET @Descripcion = CONCAT('Antes: ', @ValoresAntes, ' | Después: ', @ValoresDespues);
        EXEC logEvent 
			@TipoEvento
			, @idPostByUser
			, @Descripcion
			, @PostInIP
			, @Resultado OUTPUT;

        COMMIT;
        SET @CodigoError = 0; -- Éxito
    END TRY
    BEGIN CATCH
        
        SET @CodigoError = ERROR_NUMBER();
		SET @EstadoError = ERROR_STATE();
		SET @Error_line  = ERROR_LINE();
		SET @ErrorMessage  = ERROR_MESSAGE();
        
        -- Registrar error técnico
        EXEC logError 
            @idPostByUser
			, @CodigoError
			, @EstadoError
			, 'High'
			, @Error_line
			, 'sp_ActualizarEmpleado'
			, @ErrorMessage
			, @Resultado OUTPUT;
        
        -- Registrar evento fallido
        SET @TipoEvento = 7; -- Update no exitoso
        EXEC logEvent 
			@TipoEvento
			, @idPostByUser
			, 'Error al actualizar empleado'
			, @PostInIP
			, @Resultado OUTPUT;
    END CATCH;
END;