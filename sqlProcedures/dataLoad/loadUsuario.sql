
DECLARE @xmlData XML;

-- Cargar el XML desde una variable (podrías obtener esto de tu aplicación)
SET @xmlData = '
<Datos>
<Usuarios>
<usuario Id="1" Nombre="UsuarioScripts" Pass="1234"/>
<usuario Id="2" Nombre="Arturo" Pass="4325"/>
<usuario Id="3" Nombre="Alejandro" Pass="test"/>
<usuario Id="4" Nombre="Franco" Pass="tset"/>
<usuario Id="5" Nombre="Daniel" Pass="4321"/>
<usuario Id="6" Nombre="Axel" Pass="2465"/>
</Usuarios>
</Datos>
';
DECLARE @NextID INT;
SELECT @NextID = ISNULL(MAX(id), 0) + 1 FROM dbo.Usuario;
-- Insertar los datos
INSERT INTO dbo.Usuario(id,Nombre,Pass) 
SELECT 
	dato.value('@Id', 'INT'),
    dato.value('@Nombre', 'VARCHAR(32)'),
	dato.value('@Pass', 'varchar(16)')
FROM @xmlData.nodes('/Datos/Usuarios/usuario') AS MY_XML(dato); 