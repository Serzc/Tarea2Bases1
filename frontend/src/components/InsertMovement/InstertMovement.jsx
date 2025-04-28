import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getMovimientos, insertMovimiento } from '../../services/api';
import { useAuth } from '../../contexts/AuthContext';
import './InsertMovement.css';

export default function InsertarMovimiento() {
  const { idEmpleado } = useParams();
  const [empleado, setEmpleado] = useState(null);
  const [idTipoMovimiento, setIdTipoMovimiento] = useState('');
  const [monto, setMonto] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();
  const { user } = useAuth();

  const tiposMovimiento = [
    { id: 1, nombre: 'Cumplir mes' },
    { id: 2, nombre: 'Bono vacacional' },
    { id: 3, nombre: 'Reversion Debito' },
    { id: 4, nombre: 'Disfrute de vacaciones' },
    { id: 5, nombre: 'Venta de vacaciones' },
    { id: 6, nombre: 'Reversion de Credito' },

  ];

  useEffect(() => {
    const fetchEmpleado = async () => {
      try {
        const response = await getMovimientos(idEmpleado);
        setEmpleado(response.data.empleado);
      } catch (err) {
        setError('Error cargando empleado');
      }
    };
    fetchEmpleado();
  }, [idEmpleado]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
  
    console.log('Usuario actual:', user?.id, user?.nombre);
    if (!user) {
      setError('No hay usuario autenticado');
      return;
    }

    try {
      await insertMovimiento(idEmpleado, { 
        idTipoMovimiento, 
        Monto: parseFloat(monto),
        idPostByUser: user.id 
      });
      alert('Movimiento insertado exitosamente');
      navigate(`/employees/${idEmpleado}/movimientos`);
    } catch (err) {
      setError(err.response?.data?.mensaje || 'Error al insertar movimiento');
    }
  };

  if (!empleado) return <div className="loading-container">Cargando empleado...</div>;

  return (
    <div className="movement-container">
      <div className="movement-header">
        <h2>Insertar Movimiento para {empleado.Nombre}</h2>
        <div className="employee-info">
          <p><strong>Documento:</strong> {empleado.ValorDocumentoIdentidad}</p>
          <p><strong>Saldo Vacaciones:</strong> {empleado.SaldoVacaciones} días</p>
        </div>
      </div>

      {error && <div className="error-message">{error}</div>}

      <form onSubmit={handleSubmit} className="movement-form">
        <div className="form-group">
          <label>Tipo de Movimiento:</label>
          <select 
            value={idTipoMovimiento} 
            onChange={(e) => setIdTipoMovimiento(e.target.value)} 
            required
            className="form-select"
          >
            <option value="">Seleccionar...</option>
            {tiposMovimiento.map((tipo) => (
              <option key={tipo.id} value={tipo.id}>{tipo.nombre}</option>
            ))}
          </select>
        </div>

        <div className="form-group">
          <label>Monto:</label>
          <input 
            type="number" 
            step="0.01" 
            value={monto} 
            onChange={(e) => setMonto(e.target.value)} 
            required
            className="form-input"
          />
        </div>

        <div className="form-actions">
          <button type="submit" className="submit-button">Insertar Movimiento</button>
        </div>
      </form>
    </div>
  );
}