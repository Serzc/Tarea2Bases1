import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getMovimientos } from '../../services/api';

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

  if (error) return <p>{error}</p>;
  if (!empleado) return <p>Cargando...</p>;

  return (
    <div>
      <h2>Movimientos de {empleado.Nombre}</h2>
      <p><strong>Documento:</strong> {empleado.ValorDocumentoIdentidad}</p>
      <p><strong>Puesto:</strong> {empleado.Puesto}</p>
      <p><strong>Saldo Vacaciones:</strong> {empleado.SaldoVacaciones} días</p>

      <button onClick={() => navigate(`/employees/${idEmpleado}/movimientos/nuevo`)}>
        Insertar Movimiento
      </button>

      <table>
        <thead>
          <tr>
            <th>Fecha</th>
            <th>Tipo</th>
            <th>Monto</th>
            <th>Nuevo Saldo</th>
            <th>Registrado por</th>
            <th>IP</th>
            <th>PostTime</th>
          </tr>
        </thead>
        <tbody>
          {movimientos.map((m, idx) => (
            <tr key={idx}>
              <td>{m.Fecha}</td>
              <td>{m.TipoMovimiento}</td>
              <td>{m.Monto}</td>
              <td>{m.NuevoSaldo}</td>
              <td>{m.UsuarioRegistro}</td>
              <td>{m.PostInIP}</td>
              <td>{m.PostTime}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
