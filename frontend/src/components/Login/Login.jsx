
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { login } from '../../services/api';
import './Login.css';

export default function Login() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [test, setTest] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await login(username, password);
      if (response.data.errorCode === 0) {
        navigate('/employees');
      } else {
        setError(response.data.message);
      }
    } catch (err) {
      setError('Error de conexión');
    }
  };
  const testClicked = async () =>{

    navigate('/employees');
  }

  return (
    <div>
      <form className="login-form"
      onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Usuario"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
        />
        <input
          
          type="password"
          placeholder="Contraseña"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        {error && <p className="error">{error}</p>}
        <button type="submit">Ingresar</button>
      </form>
      <button onClick={testClicked}>Click Me</button>
      <div id="testDiv"
        value={test}
      >HEHE</div>
    </div>
  );
}