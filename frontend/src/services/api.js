import axios from 'axios';
import { useAuth } from '../contexts/AuthContext.jsx';

const api = axios.create({
  baseURL: 'http://localhost:4000/api',
});

api.interceptors.request.use((config) => {
  const user = JSON.parse(localStorage.getItem('user'));
  if (user) {
    config.headers['X-User-Id'] = user.id;
  }
  return config;
});

export const login = (username, password) => 
  api.post('/login', {user: username, pwd: password} );

export const getEmployees = (filter) => 
  api.get('/empleados', { params: { filtro: filter } });
export const updateEmployee = (id, updates) => 
  api.put(`/empleados/${id}`, updates);
export const createEmployee = (employeeData) => 
  api.post('/empleados', employeeData);
export const deleteEmployee = (id,userData) => 
  api.delete(`/empleados/${id}`,userData);
export const getMovimientos = (idEmpleado) => 
  api.get(`/empleados/${idEmpleado}/movimientos`);
export const insertMovimiento = (idEmpleado, movimiento) =>
  api.post(`/empleados/${idEmpleado}/movimientos`, movimiento);


