
DECLARE @xmlData XML;

-- Cargar el XML desde una variable (podrías obtener esto de tu aplicación)
SET @xmlData = '
<Datos>
	<Empleados>
<empleado IdPuesto="7" ValorDocumentoIdentidad="7989721" Nombre="Samantha Pratt" FechaContratacion="2021-07-15" SaldoVacaciones="5" EsActivo="1"/>
<empleado IdPuesto="5" ValorDocumentoIdentidad="4249098" Nombre="Jeffrey Watson" FechaContratacion="2022-08-20" SaldoVacaciones="10" EsActivo="1"/>
<empleado IdPuesto="4" ValorDocumentoIdentidad="5380363" Nombre="Carrie Tran" FechaContratacion="2021-04-22" SaldoVacaciones="9" EsActivo="1"/>
<empleado IdPuesto="10" ValorDocumentoIdentidad="2531660" Nombre="Nancy Richards" FechaContratacion="2018-02-07" SaldoVacaciones="11" EsActivo="1"/>
<empleado IdPuesto="3" ValorDocumentoIdentidad="3485480" Nombre="Blake Hood" FechaContratacion="2020-09-30" SaldoVacaciones="10" EsActivo="1"/>
<empleado IdPuesto="2" ValorDocumentoIdentidad="1394620" Nombre="Alexander Dixon" FechaContratacion="2022-05-03" SaldoVacaciones="11" EsActivo="1"/>
<empleado IdPuesto="5" ValorDocumentoIdentidad="1057958" Nombre="Matthew Martin" FechaContratacion="2025-02-19" SaldoVacaciones="13" EsActivo="1"/>
<empleado IdPuesto="3" ValorDocumentoIdentidad="4001003" Nombre="Matthew Rodriguez" FechaContratacion="2025-02-07" SaldoVacaciones="14" EsActivo="1"/>
<empleado IdPuesto="9" ValorDocumentoIdentidad="4047643" Nombre="Crystal Mills" FechaContratacion="2020-11-17" SaldoVacaciones="7" EsActivo="1"/>
<empleado IdPuesto="6" ValorDocumentoIdentidad="1675299" Nombre="Shane Robinson" FechaContratacion="2024-09-17" SaldoVacaciones="6" EsActivo="1"/>
<empleado IdPuesto="9" ValorDocumentoIdentidad="4117682" Nombre="Jeffrey Moon" FechaContratacion="2017-06-23" SaldoVacaciones="11" EsActivo="1"/>
<empleado IdPuesto="10" ValorDocumentoIdentidad="1696912" Nombre="Elizabeth Lin" FechaContratacion="2015-06-06" SaldoVacaciones="13" EsActivo="1"/>
<empleado IdPuesto="3" ValorDocumentoIdentidad="3521153" Nombre="Hannah Peterson" FechaContratacion="2021-11-01" SaldoVacaciones="7" EsActivo="1"/>
<empleado IdPuesto="4" ValorDocumentoIdentidad="6431803" Nombre="Antonio Wallace" FechaContratacion="2021-11-14" SaldoVacaciones="6" EsActivo="1"/>
<empleado IdPuesto="4" ValorDocumentoIdentidad="4011255" Nombre="Patricia Richardson" FechaContratacion="2023-12-27" SaldoVacaciones="10" EsActivo="1"/>
<empleado IdPuesto="6" ValorDocumentoIdentidad="3038513" Nombre="Mr. Mark Nguyen" FechaContratacion="2022-06-05" SaldoVacaciones="5" EsActivo="1"/>
<empleado IdPuesto="8" ValorDocumentoIdentidad="4382196" Nombre="Matthew Wilson" FechaContratacion="2017-10-24" SaldoVacaciones="10" EsActivo="1"/>
<empleado IdPuesto="1" ValorDocumentoIdentidad="2342953" Nombre="Steven Rogers II" FechaContratacion="2018-01-14" SaldoVacaciones="13" EsActivo="1"/>
<empleado IdPuesto="7" ValorDocumentoIdentidad="5836798" Nombre="Brandon Dominguez" FechaContratacion="2017-10-05" SaldoVacaciones="5" EsActivo="1"/>
<empleado IdPuesto="1" ValorDocumentoIdentidad="1053434" Nombre="Stacey Conley" FechaContratacion="2016-11-24" SaldoVacaciones="15" EsActivo="1"/>
<empleado IdPuesto="3" ValorDocumentoIdentidad="5433860" Nombre="Jennifer Tyler" FechaContratacion="2023-02-09" SaldoVacaciones="14" EsActivo="1"/>
<empleado IdPuesto="3" ValorDocumentoIdentidad="7991371" Nombre="Thomas Lopez" FechaContratacion="2021-08-12" SaldoVacaciones="9" EsActivo="1"/>
<empleado IdPuesto="2" ValorDocumentoIdentidad="6544296" Nombre="Christopher Duncan" FechaContratacion="2024-02-01" SaldoVacaciones="15" EsActivo="1"/>
<empleado IdPuesto="7" ValorDocumentoIdentidad="5176529" Nombre="Kayla Butler" FechaContratacion="2017-04-24" SaldoVacaciones="6" EsActivo="1"/>
<empleado IdPuesto="10" ValorDocumentoIdentidad="2135917" Nombre="Natasha Fuller" FechaContratacion="2024-12-26" SaldoVacaciones="7" EsActivo="1"/>
<empleado IdPuesto="7" ValorDocumentoIdentidad="4387142" Nombre="Kiara Hall" FechaContratacion="2024-12-05" SaldoVacaciones="8" EsActivo="1"/>
<empleado IdPuesto="9" ValorDocumentoIdentidad="5904068" Nombre="Jordan Wise" FechaContratacion="2016-04-10" SaldoVacaciones="14" EsActivo="1"/>
<empleado IdPuesto="6" ValorDocumentoIdentidad="5361005" Nombre="Amanda Lloyd" FechaContratacion="2024-05-20" SaldoVacaciones="5" EsActivo="1"/>
<empleado IdPuesto="4" ValorDocumentoIdentidad="2804664" Nombre="Andrea Watson" FechaContratacion="2015-11-14" SaldoVacaciones="6" EsActivo="1"/>
<empleado IdPuesto="8" ValorDocumentoIdentidad="5612560" Nombre="Melissa Morales" FechaContratacion="2022-11-29" SaldoVacaciones="8" EsActivo="1"/>
</Empleados>
</Datos>
';
DECLARE @NextID INT;
SELECT @NextID = ISNULL(MAX(id), 0) + 1 FROM dbo.Empleado;
-- Insertar los datos
INSERT INTO dbo.Empleado(id,idPuesto,ValorDocumentoIdentidad, Nombre, FechaContratacion, SaldoVacaciones, EsActivo) 
SELECT 
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + @NextID - 1,
	dato.value('@IdPuesto', 'INT'),
	dato.value('@ValorDocumentoIdentidad', 'VARCHAR(16)'),
    dato.value('@Nombre', 'VARCHAR(64)'),
	dato.value('@FechaContratacion', 'DATE'),
	dato.value('@SaldoVacaciones', 'INT'),
	dato.value('@EsActivo', 'bit')
FROM @xmlData.nodes('/Datos/Empleados/empleado') AS MY_XML(dato);