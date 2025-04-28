import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { login as apiLogin } from '../../services/api';
import { useAuth } from '../../contexts/AuthContext';
import './Login.css';

export default function Login() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [lockedOut, setLockedOut] = useState(false);
  const navigate = useNavigate();
  const { login: authLogin } = useAuth(); // Función de login del contexto

  // Verificar bloqueo al montar el componente
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
    setError('');
    
    try {
      // 1. Llamar al endpoint de login
      const response = await apiLogin(username, password);
      
      // 2. Verificar si la respuesta contiene los datos del usuario
      if (response.data && response.data.usuario) {
        const userData = response.data.usuario;
        
        // 3. Guardar el usuario en el contexto y localStorage
        authLogin({
          id: userData.id,
          username: userData.nombre,
          // ...otros datos del usuario si los necesitas
        });
        
        // 4. Redirigir al dashboard
        navigate('/employees');
      } else {
        setError('Respuesta inesperada del servidor');
      }
    } catch (err) {
      if (err.response) {
        if (err.response.status === 401) {
          setError(err.response.data.mensaje || 'Usuario o contraseña incorrectos');
        } else if (err.response.status === 403) {
          setError(err.response.data.mensaje);
          setLockedOut(true);
        } else {
          setError('Error en el servidor');
        }
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
          required
        />
        <input
          type="password"
          placeholder="Contraseña"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          disabled={lockedOut}
          required
        />
        {error && <p className="error">{error}</p>}
        <button type="submit" disabled={lockedOut}>
          Ingresar
        </button>
      </form>
    </div>
  );
}