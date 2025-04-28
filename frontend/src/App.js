import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Login from './components/Login/Login';
import EmployeeList from './components/Employees/EmployeeList';
import './App.css';

function App() {
  return (
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/employees" element={<EmployeeList />} />
        </Routes>
      </BrowserRouter>
  );
}

export default App;