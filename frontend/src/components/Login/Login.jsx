import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { login } from '../../services/api';
import './Login.css';

export default function Login() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [lockedOut, setLockedOut] = useState(false);
  const navigate = useNavigate();

  // Check if IP is locked out on mount
  useEffect(() => {
    const checkLockout = async () => {
      try {
        const response = await fetch('http://localhost:4000/api/login/check-lockout');
        const data = await response.json();
        if (data.isLockedOut) {
          setError(`Demasiados intentos fallidos. Intente de nuevo en ${data.minutesLeft} minutos.`);
          setLockedOut(true);
        }
      } catch {
        console.error('Error checking lockout status');
      }
    };
    checkLockout();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('Sending login request:', username, password);
    try {
      const response = await login(username, password);
      setError('¡Éxito!');
      navigate('/employees');
    } catch (err) {
      if (err.response && err.response.status === 401) {
        setError(err.response.data.mensaje || 'Usuario o contraseña incorrectos');
      } else if (err.response && err.response.status === 403) {
        setError(err.response.data.mensaje);
        setLockedOut(true); // Lockout triggered
      } else {
        setError('Error de conexión');
      }
    }
  };

  return (
    <div className="login-container">
      <form className="login-form" onSubmit={handleSubmit}>
        <h2>Iniciar Sesión</h2>
        <input
          type="text"
          placeholder="Usuario"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          disabled={lockedOut}
        />
        <input
          type="password"
          placeholder="Contraseña"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          disabled={lockedOut}
        />
        {error && <p className="error">{error}</p>}
        <button type="submit" disabled={lockedOut}>Ingresar</button>
      </form>
    </div>
  );
}
