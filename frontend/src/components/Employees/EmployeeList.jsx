import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

import { getEmployees, updateEmployee } from '../../services/api'; // Cambiado a updateEmployee

const ListaEmpleados = () => {
  const [empleados, setEmpleados] = useState([]);
  const [filtro, setFiltro] = useState('');
  const [selectedEmployee, setSelectedEmployee] = useState(null);
  const [formData, setFormData] = useState({
    id: '',
    nombre: '',
    valorDocumentoIdentidad: '',
    idPuesto: ''
  });
  const navigate = useNavigate();

  // Cargar empleados (sin cambios)
  const cargarEmpleados = async () => {
    try {
      const response = await getEmployees(filtro);
      setEmpleados(response.data);
    } catch (error) {
      alert(error.response?.data?.error || "Error al cargar empleados");
    }
  };

  // Manejar cambios en el formulario (sin cambios)
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  // Seleccionar empleado para editar (sin cambios)
  const handleEditClick = (empleado) => {
    setFormData({
      id: empleado.id,
      nombre: empleado.Nombre,
      valorDocumentoIdentidad: empleado.ValorDocumentoIdentidad,
      idPuesto: empleado.idPuesto
    });
    setSelectedEmployee(empleado);
  };

  // --- Función unificada para actualizar ---
  const handleUpdateEmployee = async () => {
    try {
      const updates = {};
      if (formData.nombre !== selectedEmployee.Nombre) updates.NuevoNombre = formData.nombre;
      if (formData.valorDocumentoIdentidad !== selectedEmployee.ValorDocumentoIdentidad) 
        updates.NuevoDocumento = formData.valorDocumentoIdentidad;
      if (formData.idPuesto !== selectedEmployee.idPuesto) 
        updates.NuevoIdPuesto = formData.idPuesto;
  
      console.log('Enviando actualización:', updates); // Debug
      const response = await updateEmployee(formData.id, updates);
      console.log('Respuesta del servidor:', response.data); // DebugF
  
      alert("¡Actualizado correctamente!");
      cargarEmpleados();
      setSelectedEmployee(null);
    } catch (error) {
      console.error('Error completo:', error); // Debug
      const message = error.response?.data?.details || 
                     error.response?.data?.error || 
                     "Error desconocido";
      alert(`Error: ${message}`);
    }
  };

  // Cargar empleados al inicio y al filtrar (sin cambios)
  useEffect(() => {
    cargarEmpleados();
  }, [filtro]);

  return (
    <div>
      {/* Filtro (sin cambios) */}
      <input
        type="text"
        value={filtro}
        onChange={(e) => setFiltro(e.target.value)}
        placeholder="Filtrar por nombre o documento"
      />

      {/* Tabla de empleados (sin cambios) */}
      <table>
        <thead>
          <tr>
            <th>Documento</th>
            <th>Nombre</th>
            <th>Puesto</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          {empleados.map(empleado => (
            <tr key={empleado.id}>
              <td>{empleado.ValorDocumentoIdentidad}</td>
              <td>{empleado.Nombre}</td>
              <td>{empleado.Puesto}</td>
              <td>
                <button onClick={() => handleEditClick(empleado)}>Editar</button>
                <button onClick={() => navigate(`/employees/${empleado.id}/movimientos`)}> Movimientos </button>
              </td>
              </tr>
          ))}
        </tbody>
      </table>

      {/* Formulario de edición (simplificado) */}
      {selectedEmployee && (
        <div className="edit-form">
          <h3>Editar Empleado</h3>
          <div>
            <label>Nombre:</label>
            <input
              type="text"
              name="nombre"
              value={formData.nombre}
              onChange={handleInputChange}
            />
          </div>
          <div>
            <label>Documento:</label>
            <input
              type="text"
              name="valorDocumentoIdentidad"
              value={formData.valorDocumentoIdentidad}
              onChange={handleInputChange}
            />
          </div>
          <div>
            <label>Puesto:</label>
            <select
              name="idPuesto"
              value={formData.idPuesto}
              onChange={handleInputChange}
            >
                  <option value="" disabled>Seleccionar Puesto</option>
                <option value="1">Cajero</option>
                <option value="2">Camarero</option>
                <option value="3">Cuidador</option>
                <option value="4">Conductor</option>
                <option value="5">Asistente</option>
                <option value="6">Recepcionista</option>
                <option value="7">Fontanero</option>
                <option value="8">Niñera</option>
                <option value="9">Conserje</option>
                <option value="10">Albañil</option>
            </select>
          </div>
          <button onClick={handleUpdateEmployee}>Guardar Cambios</button>
          <button onClick={() => setSelectedEmployee(null)}>Cancelar</button>
        </div>
      )}
    </div>
  );
};

export default ListaEmpleados;