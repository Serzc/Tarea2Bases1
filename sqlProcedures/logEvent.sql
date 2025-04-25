CREATE OR ALTER PROCEDURE [dbo].[logEvent]
    @idTipoEvento INT,
    @idPostByUser INT,
    @Descripcion VARCHAR(128) = NULL,
    @PostInIP VARCHAR(64),
    @Resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar tipo de evento
        IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE id = @idTipoEvento)
        BEGIN
            SET @Resultado = 50020; -- Tipo de evento no existe
            RETURN;
        END;
        
        -- Validar usuario
        IF NOT EXISTS (SELECT 1 FROM Usuario WHERE id = @idPostByUser)
        BEGIN
            SET @Resultado = 50021; -- Usuario no existe
            RETURN;
        END;
        
        -- Insertar en bitácora
        INSERT INTO BitacoraEvento (
            id,
            idTipoEvento,
            idPostByUser,
            Descripcion,
            PostInIP,
            PostTime
        )
        VALUES (
            NEXT VALUE FOR dbo.BitacoraEventoSeq,
            @idTipoEvento,
            @idPostByUser,
            @Descripcion,
            @PostInIP,
            GETDATE()
        );
        
        SET @Resultado = 0; -- Éxito
    END TRY
    BEGIN CATCH
        SET @Resultado = ERROR_NUMBER();
        
        -- Registrar el error en DBError usando el idPostByUser
        DECLARE @ErrorMessage NVARCHAR(128) = ERROR_MESSAGE();
        DECLARE @Error_line INT = ERROR_LINE();
        DECLARE @ErrorResult INT;
        
        EXEC dbo.logError 
            @idPostByUser = @idPostByUser,
            @ErrorNumber = Resultado,
            @ErrorState = "Recent",
            @Severity = 'High',
            @ErrorLine = @Error_line,
            @OriginProcedure = 'logEvent',
            @ErrorMessage = @ErrorMessage,
            @Resultado = @ErrorResult OUTPUT;
            
        PRINT 'Error al registrar evento: ' + @ErrorMessage;
    END CATCH;
    
    SET NOCOUNT OFF;
END;
GO