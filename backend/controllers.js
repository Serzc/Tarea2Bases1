const serverConnection = require('./dbConfig.js');

const empleadoController = {
    listarEmpleados: async (req, res) => {
        try {
            const { filtro } = req.query;
            const result = await serverConnection.executeProcedure('sp_listar_empleados', [
                { name: 'filtro', type: sql.VarChar(64), value: filtro || '' }
            ]);
            res.json(result);
        } catch (err) {
            res.status(500).json({ error: err.message });
        }
    },

    crearEmpleado: async (req, res) => {
        try {
            const { idPuesto, ValorDocumentoIdentidad, Nombre, FechaContratacion } = req.body;
            const result = await serverConnection.executeProcedure('sp_crear_empleado', [
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