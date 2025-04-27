import React, { useState, useEffect } from 'react';
import { getEmployees } from '../../services/api'; 

const ListaEmpleados = () => {
  const [empleados, setEmpleados] = useState([]);
  const [filtro, setFiltro] = useState('');

  const cargarEmpleados = async () => {
    try {
      const response = await getEmployees(filtro);
      console.log(response.data);  
      setEmpleados(response.data);
    } catch (error) {
      console.error('Error cargando empleados:', error);
      alert(error.response?.data?.mensaje || 'Error al cargar empleados');
    }
  };

  useEffect(() => {
    cargarEmpleados();
  }, [filtro]);

  return (
    <div>
      <input
        type="text"
        value={filtro}
        onChange={(e) => setFiltro(e.target.value)}
        placeholder="Filtrar por nombre o documento"
      />
      
      <table>
        <thead>
          <tr>
            <th>Documento</th>
            <th>Nombre</th>
            <th>Puesto</th>
            <th>Saldo Vacaciones</th>
          </tr>
        </thead>
        <tbody>
          {empleados.map(empleado => (
            <tr key={empleado.id}>
              <td>{empleado.ValorDocumentoIdentidad}</td>
              <td>{empleado.Nombre}</td>
              <td>{empleado.Puesto}</td>
              <td>{empleado.SaldoVacaciones} días</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ListaEmpleados;
