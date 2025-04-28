// EmployeeForm.jsx
import React, { useState } from 'react';
import { createEmployee } from '../../services/api';
import { useAuth } from '../../contexts/AuthContext';

const EmployeeForm = ({ onEmployeeCreated }) => {
  const [formData, setFormData] = useState({
    idPuesto: '',
    ValorDocumentoIdentidad: '',
    Nombre: '',
    FechaContratacion: ''
  });
  const { user } = useAuth();

  const handleSubmit = async (e) => {
    e.preventDefault();
    formData.idPostByUser = user.id; // Agregar el id del usuario que crea el empleado
    console.log('Datos a enviar:', formData);
    try {
      await createEmployee(formData);
      alert('Empleado creado exitosamente!');
      onEmployeeCreated(); // Recargar lista
    } catch (error) {
      const errorMessages = {
        '50004': 'Documento ya existe',
        '50005': 'Nombre ya existe',
        '50009': 'Nombre debe contener solo letras',
        '50010': 'Documento debe ser numérico'
      };
      console.error('Error completo:', error.response);
      alert(errorMessages[error.response?.data?.CodigoError] || "Error al crear");
    }
  };

  return (
    <div className="employee-form-container">
      <h3>Nuevo Empleado</h3>
        <form onSubmit={handleSubmit}>
            <input
                type="text"
                name="Nombre"
                placeholder="Nombre"
                value={formData.Nombre}
                onChange={(e) => setFormData({...formData, Nombre: e.target.value})}
                required
            />
            <input
                type="text"
                name="ValorDocumentoIdentidad"
                placeholder="Documento"
                value={formData.ValorDocumentoIdentidad}
                onChange={(e) => setFormData({...formData, ValorDocumentoIdentidad: e.target.value})}
                required
            />
            <select
                name="idPuesto"
                value={formData.idPuesto}
                onChange={(e) => setFormData({...formData, idPuesto: e.target.value})}
                required
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
            <input
                type="date"
                name="FechaContratacion"
                value={formData.FechaContratacion}
                onChange={(e) => setFormData({...formData, FechaContratacion: e.target.value})}
                required
            />
             <button type="submit">Guardar</button>
        </form>
    </div>
  );
};

export default EmployeeForm;