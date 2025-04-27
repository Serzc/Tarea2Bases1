const { sql, pool } = require('./dbConfig.js');
const { executeProcedure } = require('./dbService.js');

const empleadoController = {
    listarEmpleados: async (req, res) => {
        try {
            const { filtro } = req.query;
            const request = new sql.Request(await pool.connect());
            request.input('filtro', sql.VarChar(64), filtro || '');
            
            const result = await request.execute('sp_ListarEmpleados');
            res.json(result.recordset);
        } catch (err) {
            res.status(500).json({ 
                codigoError: err.number || 500,
                mensaje: err.message 
            });
        }
    },

    crearEmpleado: async (req, res) => {
        try {
            const { idPuesto, ValorDocumentoIdentidad, Nombre, FechaContratacion } = req.body;
            const result = await executeProcedure('sp_crear_empleado', [
                { name: 'idPuesto', type: sql.Int, value: idPuesto },
                { name: 'ValorDocumentoIdentidad', type: sql.VarChar(16), value: ValorDocumentoIdentidad },
                { name: 'Nombre', type: sql.VarChar(64), value: Nombre },
                { name: 'FechaContratacion', type: sql.Date, value: FechaContratacion }
            ]);
            res.status(201).json(result);
        } catch (err) {
            res.status(500).json({ error: err.message });
        }
    }
};

module.exports = empleadoController;
