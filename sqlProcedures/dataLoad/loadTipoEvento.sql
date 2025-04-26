

DECLARE @xmlData XML;

-- Cargar el XML desde una variable (podrías obtener esto de tu aplicación)
SET @xmlData = '
<Datos>
	<TiposEvento>
<TipoEvento Id="1" Nombre="Login Exitoso"/>
<TipoEvento Id="2" Nombre="Login No Exitoso"/>
<TipoEvento Id="3" Nombre="Login deshabilitado"/>
<TipoEvento Id="4" Nombre="Logout"/>
<TipoEvento Id="5" Nombre="Insercion no exitosa"/>
<TipoEvento Id="6" Nombre="Insercion exitosa"/>
<TipoEvento Id="7" Nombre="Update no exitoso"/>
<TipoEvento Id="8" Nombre="Update exitoso"/>
<TipoEvento Id="9" Nombre="Intento de borrado"/>
<TipoEvento Id="10" Nombre="Borrado exitoso"/>
<TipoEvento Id="11" Nombre="Consulta con filtro de nombre"/>
<TipoEvento Id="12" Nombre="Consulta con filtro de cedula"/>
<TipoEvento Id="13" Nombre="Intento de insertar movimiento"/>
<TipoEvento Id="14" Nombre="Insertar movimiento exitoso"/>
</TiposEvento>
</Datos>
';

-- Insertar los datos
INSERT INTO dbo.TipoEvento( id,Nombre)
SELECT
	dato.value('@Id', 'INT'),
    dato.value('@Nombre', 'VARCHAR(64)')
FROM @xmlData.nodes('/Datos/TiposEvento/TipoEvento') AS MY_XML(dato);