import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:5000/api',  // Ajusta según tu backend
});

export const login = (username, password) => 
  api.post('/login', { username, password });

export const getEmployees = (filter) => 
  api.get(`/employees?filter=${filter}`);