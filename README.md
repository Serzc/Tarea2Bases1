# Tarea2Bases1
 
para correr la app ingresar el comando (se necesita node js)
npm start



rutas:
localhost:3000/  (frontend)

backend:
localhost:4000/  (root/test)

TODO:
backend:
    login SP
    getEmployeesSorted SP
    fill tables with XML

    connect routes

frontend:
    table filled with a JSON
    insert employee form
    pretty everything



1. Login y Seguridad (R1)
    Validar usuario/contraseña en tabla Usuario.

    Bloquear tras 5 intentos fallidos en 30 minutos (mensaje: "Demasiados intentos, intente en 10 minutos").

    Registrar eventos en BitacoraEvento (éxito/fallo/login deshabilitado).

2. CRUD de Empleados (R2, R3, R4)
    Listar empleados con filtros por:

        Nombre aproximado (si el filtro contiene letras).

        Valor de documento de identidad (si el filtro es numérico).

    Insertar empleados:

        Validar que no exista otro con mismo nombre o documento.

        Campos obligatorios: ValorDocumentoIdentidad, Nombre, IdPuesto (dropdown).

    UDC (Update/Delete/Consulta):

        Update: Editar documento, nombre o puesto (validar duplicados).

        Delete: Borrado lógico (EsActivo = 0).

        Consulta: Mostrar datos del empleado + saldo de vacaciones.

3. Movimientos de Vacaciones (R5, R6)
    Listar movimientos de un empleado:

        Orden descendente por fecha.

        Mostrar: fecha, tipo de movimiento, monto, nuevo saldo, usuario que lo registró.

    Insertar movimiento:

        Validar que el saldo no sea negativo tras aplicar el monto.

        Registrar en Movimiento y actualizar SaldoVacaciones en Empleado.

4. Bitácora de Eventos (R7)
    Registrar todas las acciones en BitacoraEvento:
        Logins, inserciones, actualizaciones, borrados, consultas con filtros.

5. Manejo de Errores (R8)
    Usar la tabla Error para mostrar mensajes amigables (ej: "Empleado ya existe").

    Capturar errores de SQL en procedimientos almacenados y enviar códigos a la capa lógica.

6. Transacciones SQL
    Asegurar que operaciones críticas (ej: movimiento de vacaciones) usen transacciones en la BD.

