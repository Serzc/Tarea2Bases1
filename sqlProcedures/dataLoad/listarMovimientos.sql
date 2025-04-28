CREATE OR ALTER PROCEDURE sp_ListarMovimientosEmpleado
    @idEmpleado INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Get empleado info
    SELECT 
        e.ValorDocumentoIdentidad,
        e.Nombre,
        e.SaldoVacaciones
    FROM Empleado e
    WHERE e.id = @idEmpleado;

    -- Get movimientos
    SELECT 
        m.Fecha,
        tm.Nombre AS TipoMovimiento,
        m.Monto,
        m.NuevoSaldo,
        u.Nombre AS UsuarioRegistro,
        m.PostInIP,
        m.PostTime
    FROM Movimiento m
    JOIN TipoMovimiento tm ON m.idTipoMovimiento = tm.id
    JOIN Usuario u ON m.idPostByUser = u.id
    WHERE m.idEmpleado = @idEmpleado
    ORDER BY m.Fecha DESC;
END
