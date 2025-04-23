require('dotenv').config();
const express = require('express');
const sql = require('mssql');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

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


let pool;
async function connectToDatabase() {
    try {
        pool = await sql.connect(dbConfig);
        console.log("Conectado a la base de Datos :D");
    } catch (err) {
        console.error("Conexión no se logró:", err.message);
    }
}


connectToDatabase();
// Start the Server
const PORT = 10298 || 4000;
app.listen(PORT, () => console.log(`Servidor en http://localhost:${PORT} :D`));
