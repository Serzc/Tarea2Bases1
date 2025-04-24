const express = require('express');
const empleadoController = require('./controllers.js');

const router = express.Router();

router.get('/', empleadoController.listarEmpleados);
router.post('/', empleadoController.crearEmpleado);

module.exports = router;