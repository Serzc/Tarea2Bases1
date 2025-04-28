import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getMovimientos } from '../../services/api';
import './Movements.css';

export default function MovementList() {
  const { idEmpleado } = useParams();
  const [empleado, setEmpleado] = useState(null);
  const [movimientos, setMovimientos] = useState([]);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await getMovimientos(idEmpleado);
        setEmpleado(response.data.empleado);
        setMovimientos(response.data.movimientos);
      } catch (err) {
        setError('Error cargando movimientos');
      }
    };
    fetchData();
  }, [idEmpleado]);

  if (error) return <div className="error-container">{error}</div>;
  if (!empleado) return <div className="loading-container">Cargando...</div>;

  return (
    <div className="movements-container">
      <div className="movements-header">
        <h2>Movimientos de {empleado.Nombre}</h2>
        <div className="employee-details">
          <p><strong>Documento:</strong> {empleado.ValorDocumentoIdentidad}</p>
          <p><strong>Puesto:</strong> {empleado.Puesto}</p>
          <p><strong>Saldo Vacaciones:</strong> {empleado.SaldoVacaciones} días</p>
        </div>
      </div>

      <div className="actions-bar">
        <button 
          className="add-movement-btn"
          onClick={() => navigate(`/employees/${idEmpleado}/movimientos/nuevo`)}
        >
          Insertar Movimiento
        </button>
      </div>

      <div className="table-container">
        <table className="movements-table">
          <thead>
            <tr>
              
              <th>Tipo</th>
              <th>Monto</th>
              <th>Nuevo Saldo</th>
              <th>Registrado por</th>
              
              <th>Fecha Registro</th>
            </tr>
          </thead>
          <tbody>
            {movimientos.map((m, idx) => (
              <tr key={idx}>
                
                <td>{m.TipoMovimiento}</td>
                <td className={m.Monto >= 0 ? 'positive' : 'negative'}>{m.Monto}</td>
                <td>{m.NuevoSaldo}</td>
                <td>{m.UsuarioRegistro}</td>
                
                <td>{new Date(m.PostTime).toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}