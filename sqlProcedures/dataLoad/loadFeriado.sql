
DECLARE @xmlData XML;

-- Cargar el XML desde una variable (podrías obtener esto de tu aplicación)
SET @xmlData = '
<Datos>
<Feriados>
<Feriado Fecha="2024-01-01" Descripcion="Año Nuevo"/>
<Feriado Fecha="2024-05-01" Descripcion="Día del Trabajo"/>
<Feriado Fecha="2024-09-16" Descripcion="Día de la Independencia"/>
<Feriado Fecha="2024-11-01" Descripcion="Día de Todos los Santos"/>
<Feriado Fecha="2024-12-25" Descripcion="Navidad"/>
</Feriados>
</Datos>
';

-- Insertar los datos
INSERT INTO dbo.Feriado(Fecha,Descripcion) 
SELECT 

    dato.value('@Fecha', 'DATE'),
	dato.value('@Descripcion', 'varchar(128)')
FROM @xmlData.nodes('/Datos/Feriados/Feriado') AS MY_XML(dato);