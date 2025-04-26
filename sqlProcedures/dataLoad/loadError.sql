
DECLARE @xmlData XML;

-- Cargar el XML desde una variable (podrías obtener esto de tu aplicación)
SET @xmlData = '
<Datos>
	<Error>
		<error Codigo="50001" Descripcion="Username no existe"/>
		<error Codigo="50002" Descripcion="Password no existe"/>
		<error Codigo="50003" Descripcion="Login deshabilitado"/>
		<error Codigo="50004" Descripcion="Empleado con ValorDocumentoIdentidad ya existe en inserción"/>
		<error Codigo="50005" Descripcion="Empleado con mismo nombre ya existe en inserción"/>
		<error Codigo="50006" Descripcion="Empleado con ValorDocumentoIdentidad ya existe en actualizacion"/>
		<error Codigo="50007" Descripcion="Empleado con mismo nombre ya existe en actualización"/>
		<error Codigo="50008" Descripcion="Error de base de datos"/>
		<error Codigo="50009" Descripcion="Nombre de empleado no alfabético"/>
		<error Codigo="50010" Descripcion="Valor de documento de identidad no alfabético"/>
		<error Codigo="50011" Descripcion="Monto del movimiento rechazado pues si se aplicar el saldo seria negativo."/>
	</Error>
</Datos>
';

-- Insertar los datos
INSERT INTO dbo.Error (Codigo, Descripcion)
SELECT
    dato.value('@Codigo', 'INT'),
    dato.value('@Descripcion', 'VARCHAR(128)')
FROM @xmlData.nodes('/Datos/Error/error') AS MY_XML(dato);