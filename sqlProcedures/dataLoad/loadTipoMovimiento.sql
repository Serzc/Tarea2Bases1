DECLARE @xmlData XML;

-- Cargar el XML desde una variable (podrías obtener esto de tu aplicación)
SET @xmlData = '
<Datos>
	<TiposMovimientos>
<TipoMovimiento Id="1" Nombre="Cumplir mes" TipoAccion="Credito"/>
<TipoMovimiento Id="2" Nombre="Bono vacacional" TipoAccion="Credito"/>
<TipoMovimiento Id="3" Nombre="Reversion Debito" TipoAccion="Credito"/>
<TipoMovimiento Id="4" Nombre="Disfrute de vacaciones" TipoAccion="Debito"/>
<TipoMovimiento Id="5" Nombre="Venta de vacaciones" TipoAccion="Debito"/>
<TipoMovimiento Id="6" Nombre="Reversion de Credito" TipoAccion="Debito"/>
</TiposMovimientos>
</Datos>
';

-- Insertar los datos
INSERT INTO dbo.TipoMovimiento (Nombre,TipoAccion) 
SELECT 
    dato.value('@Nombre', 'VARCHAR(64)'),
	dato.value('@TipoAccion', 'VARCHAR(16)')
FROM @xmlData.nodes('/Datos/TiposMovimientos/TipoMovimiento') AS MY_XML(dato);