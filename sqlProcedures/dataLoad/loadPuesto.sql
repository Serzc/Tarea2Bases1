

DECLARE @xmlData XML;

-- Cargar el XML desde una variable (podrías obtener esto de tu aplicación)
SET @xmlData = '
<Datos>
	<Puestos>
<Puesto Id="1" Nombre="Cajero" SalarioxHora="11.00"/>
<Puesto Id="2" Nombre="Camarero" SalarioxHora="10.00"/>
<Puesto Id="3" Nombre="Cuidador" SalarioxHora="13.50"/>
<Puesto Id="4" Nombre="Conductor" SalarioxHora="15.00"/>
<Puesto Id="5" Nombre="Asistente" SalarioxHora="11.00"/>
<Puesto Id="6" Nombre="Recepcionista" SalarioxHora="12.00"/>
<Puesto Id="7" Nombre="Fontanero" SalarioxHora="13.00"/>
<Puesto Id="8" Nombre="Niñera" SalarioxHora="12.00"/>
<Puesto Id="9" Nombre="Conserje" SalarioxHora="11.00"/>
<Puesto Id="10" Nombre="Albañil" SalarioxHora="10.50"/>
</Puestos>
</Datos>
';

-- Insertar los datos
INSERT INTO dbo.Puesto ( Nombre, SalarioxHora)
SELECT
    dato.value('@Nombre', 'VARCHAR(64)'),
	dato.value('@SalarioxHora', 'DECIMAL(10,2)')
FROM @xmlData.nodes('/Datos/Puestos/Puesto') AS MY_XML(dato);