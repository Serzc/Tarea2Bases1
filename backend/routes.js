const express = require('express');
const {empleadoController,loginController} = require('./controllers.js');

const employeeRouter = express.Router();
const loginRouter = express.Router();

employeeRouter.get('/', empleadoController.listarEmpleados);
employeeRouter.post('/', empleadoController.crearEmpleado);
employeeRouter.put('/:id', empleadoController.actualizarEmpleado);
employeeRouter.delete('/:id', empleadoController.eliminarEmpleado);

loginRouter.post('/', loginController.login);
loginRouter.get('/check-lockout', loginController.checkLockout);

module.exports = {employeeRouter, loginRouter};
