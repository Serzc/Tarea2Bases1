import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getMovimientos, insertMovimiento } from '../../services/api';

export default function InsertarMovimiento() {
  const { idEmpleado } = useParams();
  const [empleado, setEmpleado] = useState(null);
  const [idTipoMovimiento, setIdTipoMovimiento] = useState('');
  const [monto, setMonto] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const tiposMovimiento = [
    { id: 1, nombre: 'Acreditar Vacaciones' },
    { id: 2, nombre: 'Debitar Vacaciones' },
    // ...otros si tienes más tipos en tu DB
  ];

  useEffect(() => {
    const fetchEmpleado = async () => {
      try {
        const response = await getMovimientos(idEmpleado); // Reuse previous API
        setEmpleado(response.data.empleado);
      } catch (err) {
        setError('Error cargando empleado');
      }
    };
    fetchEmpleado();
  }, [idEmpleado]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await insertMovimiento(idEmpleado, { idTipoMovimiento, Monto: parseFloat(monto) });
      alert('Movimiento insertado exitosamente');
      navigate(`/employees/${idEmpleado}/movimientos`);
    } catch (err) {
      setError(err.response?.data?.mensaje || 'Error al insertar movimiento');
    }
  };

  if (!empleado) return <p>Cargando empleado...</p>;

  return (
    <div>
      <h2>Insertar Movimiento para {empleado.Nombre}</h2>
      <p><strong>Documento:</strong> {empleado.ValorDocumentoIdentidad}</p>
      <p><strong>Saldo Vacaciones:</strong> {empleado.SaldoVacaciones} días</p>

      {error && <p style={{ color: 'red' }}>{error}</p>}

      <form onSubmit={handleSubmit}>
        <label>Tipo de Movimiento:</label>
        <select value={idTipoMovimiento} onChange={(e) => setIdTipoMovimiento(e.target.value)} required>
          <option value="">Seleccionar...</option>
          {tiposMovimiento.map((tipo) => (
            <option key={tipo.id} value={tipo.id}>{tipo.nombre}</option>
          ))}
        </select>
        <br />
        <label>Monto:</label>
        <input type="number" step="0.01" value={monto} onChange={(e) => setMonto(e.target.value)} required />
        <br />
        <button type="submit">Insertar Movimiento</button>
      </form>
    </div>
  );
}
