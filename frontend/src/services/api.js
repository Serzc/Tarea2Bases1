import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:4000/api',  // Ajusta según tu backend
});

export const login = (username, password) => 
  api.post('/login', {user: username, pwd: password} );

export const getEmployees = (filter) => 
  api.get('/empleados', { params: { filtro: filter } });
export const updateEmployee = (id, updates) => 
  api.put(`/empleados/${id}`, updates);
export const getMovimientos = (idEmpleado) => 
  api.get(`/empleados/${idEmpleado}/movimientos`);
export const insertMovimiento = (idEmpleado, movimiento) =>
  api.post(`/empleados/${idEmpleado}/movimientos`, movimiento);


