require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { pool, poolConnect } = require('./dbConfig.js'); // Conexión a SQL Server

// Importar rutas
const {employeeRouter, loginRouter} = require('./routes.js');



const app = express();
const PORT = process.env.PORT || 4000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());

// Conectar a la BD antes de iniciar el servidor
poolConnect.then(() => {
    console.log('Conectado a SQL Server en CloudCluster');
}).catch(err => {
    console.error('Error de conexión a la BD:', err.message);
});

// Rutas
app.use('/api/empleados', employeeRouter);
app.use('/api/login', loginRouter);




// Ruta de prueba
app.get('/', (req, res) => {
    res.send('API de Control de Vacaciones');
});




// Iniciar servidor
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});