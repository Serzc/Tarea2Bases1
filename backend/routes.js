const express = require('express');
const {empleadoController,loginController} = require('./controllers.js');

const employeeRouter = express.Router();
const loginRouter = express.Router();

employeeRouter.get('/', empleadoController.listarEmpleados);
employeeRouter.post('/', empleadoController.crearEmpleado);

loginRouter.post('/', loginController.login);
loginRouter.get('/check-lockout', loginController.checkLockout);

module.exports = {employeeRouter, loginRouter};