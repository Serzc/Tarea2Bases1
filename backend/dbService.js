const { pool, poolConnect } = require('./dbConfig.js');

async function executeProcedure(procedureName, params) {
    await poolConnect;
    const request = pool.request();
    
    // Agregar parámetros
    params.forEach(param => {
        request.input(param.name, param.type, param.value);
    });

    try {
        const result = await request.execute(procedureName);
        return result.recordset;
    } catch (err) {
        console.error(`Error ejecutando procedimiento ${procedureName}:`, err);
        throw err;
    }
}

module.exports = {
    executeProcedure
};