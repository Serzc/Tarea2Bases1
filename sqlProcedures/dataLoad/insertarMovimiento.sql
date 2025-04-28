CREATE OR ALTER PROCEDURE sp_InsertarMovimientoEmpleado
    @idEmpleado INT,
    @idTipoMovimiento INT,
    @Monto DECIMAL(10,2),
    @idPostByUser INT,
    @PostInIP VARCHAR(64),
    @Resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @saldoActual DECIMAL(10,2);
    DECLARE @tipoAccion VARCHAR(16);

    -- Get saldo actual
    SELECT @saldoActual = SaldoVacaciones FROM Empleado WHERE id = @idEmpleado;

    -- Get tipo accion (Credito / Debito)
    SELECT @tipoAccion = TipoAccion FROM TipoMovimiento WHERE id = @idTipoMovimiento;

    -- Validate saldo (no negativo)
    IF @tipoAccion = 'Debito' AND @saldoActual - @Monto < 0
    BEGIN
        SET @Resultado = 50010;  -- Código: saldo insuficiente
        RETURN;
    END

    -- Calculate nuevo saldo
    DECLARE @nuevoSaldo DECIMAL(10,2) = CASE
        WHEN @tipoAccion = 'Credito' THEN @saldoActual + @Monto
        ELSE @saldoActual - @Monto
    END;

    -- Insert movimiento
    INSERT INTO Movimiento (idEmpleado, idTipoMovimiento, Monto, NuevoSaldo, idPostByUser, PostInIP)
    VALUES (@idEmpleado, @idTipoMovimiento, @Monto, @nuevoSaldo, @idPostByUser, @PostInIP);

    -- Update saldo empleado
    UPDATE Empleado SET SaldoVacaciones = @nuevoSaldo WHERE id = @idEmpleado;

    SET @Resultado = 0; -- Éxito
END
