import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Login from './components/Login/Login';
import EmployeeList from './components/Employees/EmployeeList';
import MovementList from './components/Movements/MovementList';
import InsertMovement from './components/InsertMovement/InstertMovement';


import './App.css';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/employees" element={<EmployeeList />} />
        <Route path="/employees/:idEmpleado/movimientos" element={<MovementList/>} />
        <Route path="/employees/:idEmpleado/movimientos/nuevo" element={<InsertMovement />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;