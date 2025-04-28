import React, { useState, useEffect } from 'react';
import { getEmployees, updateEmployee, deleteEmployee } from '../../services/api'; 
import EmployeeForm from './EmployeeForm';
import './EmployeeList.css'

const ListaEmpleados = () => {
  const [empleados, setEmpleados] = useState([]);
  const [filtro, setFiltro] = useState('');
  const [selectedEmployee, setSelectedEmployee] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    id: '',
    nombre: '',
    valorDocumentoIdentidad: '',
    idPuesto: ''
  });

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
      console.log('Respuesta del servidor:', response.data); // Debug
  
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
  const handleDeleteEmployee = async (id) => {
    if (!window.confirm('¿Estás seguro de eliminar este empleado?')) {
      return; // Cancelar si el usuario no confirma
    }
    try {
      await deleteEmployee(id);
      alert('Empleado eliminado correctamente');
      cargarEmpleados(); // Refrescar la lista
    } catch (error) {
      const errorMessages = {
        50013: 'El empleado no existe o ya fue eliminado',
        50008: 'Error interno al eliminar'
      };
      alert(errorMessages[error.response?.data?.CodigoError] || 'Error desconocido');
    }
  };

  // Cargar empleados al inicio y al filtrar (sin cambios)
  useEffect(() => {
    cargarEmpleados();
  }, [filtro]);

  return (
    <div className="employee-container">
      <div className="employee-header">
        <button 
          className="btn btn-primary"
          onClick={() => setShowForm(true)}>
          Agregar Nuevo Empleado
        </button>

        <input
          type="text"
          className="filter-input"
          value={filtro}
          onChange={(e) => setFiltro(e.target.value)}
          placeholder="Filtrar por nombre o documento"
        />
      </div>
      
      {showForm && (
        <EmployeeForm 
          onSuccess={() => {
            setShowForm(false); 
            cargarEmpleados(); 
          }}
          onCancel={() => setShowForm(false)}
        />
      )}
      
      <table className="employee-table">
        <thead>
          <tr>
            <th>Documento</th>
            <th>Nombre</th>
            <th>Puesto</th>
            <th className="actions-header">Acciones</th>
          </tr>
        </thead>
        <tbody>
          {empleados.map(empleado => (
            <tr key={empleado.id}>
              <td>{empleado.ValorDocumentoIdentidad}</td>
              <td>{empleado.Nombre}</td>
              <td>{empleado.Puesto}</td>
              <td className="actions-cell">
                <button 
                  className="btn btn-edit"
                  onClick={() => handleEditClick(empleado)}>
                  Editar
                </button>
                <button 
                  className="btn btn-delete"
                  onClick={() => handleDeleteEmployee(empleado.id)}>
                  Eliminar
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {selectedEmployee && (
        <div className="edit-modal">
          <div className="modal-content">
            <h3>Editar Empleado</h3>
            <div className="form-group">
              <label>Nombre:</label>
              <input
                type="text"
                name="nombre"
                value={formData.nombre}
                onChange={handleInputChange}
              />
            </div>
            <div className="form-group">
              <label>Documento:</label>
              <input
                type="text"
                name="valorDocumentoIdentidad"
                value={formData.valorDocumentoIdentidad}
                onChange={handleInputChange}
              />
            </div>
            <div className="form-group">
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
            <div className="modal-actions">
              <button className="btn btn-save" onClick={handleUpdateEmployee}>
                Guardar Cambios
              </button>
              <button className="btn btn-cancel" onClick={() => setSelectedEmployee(null)}>
                Cancelar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ListaEmpleados;