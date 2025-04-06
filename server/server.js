require('dotenv').config();
const express = require('express');
const sql = require('mssql');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Azure SQL Database Configuration
const dbConfig = {
    user: process.env.AZURE_SQL_USER,
    password: process.env.AZURE_SQL_PASSWORD,
    server: process.env.AZURE_SQL_SERVER,
    database: process.env.AZURE_SQL_DATABASE,
    options: {
        encrypt: true, // Required for Azure
        enableArithAbort: true
    }
};

// Connect to Azure SQL
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
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor en http://localhost:${PORT}`));
