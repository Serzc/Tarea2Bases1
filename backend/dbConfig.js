const sql = require('mssql');
require('dotenv').config();

const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,  
    port: parseInt(process.env.DB_PORT),
    database: process.env.DB_DATABASE,
    options: {
        encrypt: true,  
        trustServerCertificate: true, 
        enableArithAbort: true,
    }
};

const pool = new sql.ConnectionPool(dbConfig);
const poolConnect = pool.connect();

module.exports = {
    sql,
    pool,
    poolConnect
};