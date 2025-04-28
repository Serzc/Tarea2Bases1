CREATE OR ALTER PROCEDURE [dbo].[sp_CrearEmpleado]
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
    DECLARE @TipoEvento INT = 6; -- Inserción exitosa (5 si falla)
    DECLARE @Descripcion VARCHAR(256);

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar nombre alfabético
        IF @Nombre LIKE '%[^a-zA-Z ]%'
        BEGIN
            SET @CodigoError = 50009; -- Nombre no alfabético
            ROLLBACK;
            RETURN;
        END;

        -- Validar documento numérico
        IF @ValorDocumentoIdentidad LIKE '%[^0-9]%'
        BEGIN
            SET @CodigoError = 50010; -- Documento no numérico
            ROLLBACK;
            RETURN;
        END;

        -- Validar unicidad
        IF EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = @ValorDocumentoIdentidad)
        BEGIN
            SET @CodigoError = 50004; -- Documento ya existe
            ROLLBACK;
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Empleado WHERE Nombre = @Nombre)
        BEGIN
            SET @CodigoError = 50005; -- Nombre ya existe
            ROLLBACK;
            RETURN;
        END;

        -- Insertar empleado
        INSERT INTO Empleado (
            idPuesto
			, ValorDocumentoIdentidad
			, Nombre
			, FechaContratacion
			, EsActivo
        )
        VALUES (
            @idPuesto
			, @ValorDocumentoIdentidad
			, @Nombre
			, @FechaContratacion
			, 1
        );

        -- Registrar en bitácora
        SET @Descripcion = CONCAT(
            'Nuevo empleado: ', @Nombre, 
            ' (Documento: ', @ValorDocumentoIdentidad, ')'
        );
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
        ROLLBACK;
        SET @CodigoError = ERROR_NUMBER();
		DECLARE @EstadoError VARCHAR(64)= ERROR_STATE();
		DECLARE @Error_line INT = ERROR_LINE();
		DECLARE @ErrorMessage NVARCHAR(128) = ERROR_MESSAGE();
        EXEC logError 
		@idPostByUser
		, @CodigoError
		, @EstadoError
		, 'High'
		, @Error_line
		, 'sp_CrearEmpleado'
		, @ErrorMessage
		, @Resultado OUTPUT;
    END CATCH;
END;