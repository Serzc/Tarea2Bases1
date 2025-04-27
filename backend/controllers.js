const { sql, pool } = require('./dbConfig.js');
const { executeProcedure } = require('./dbService.js');

const empleadoController = {
    listarEmpleados: async (req, res) => {
        try {
            const { filtro } = req.query;
            const request = new sql.Request(await pool.connect());
            request.input('filtro', sql.VarChar(64), filtro || '');
            
            const result = await request.execute('sp_ListarEmpleados');
            res.json(result.recordset);
        } catch (err) {
            res.status(500).json({ 
                codigoError: err.number || 500,
                mensaje: err.message 
            });
        }
    },

    crearEmpleado: async (req, res) => {
        try {
            const { idPuesto, ValorDocumentoIdentidad, Nombre, FechaContratacion } = req.body;
            const result = await executeProcedure('sp_crear_empleado', [
                { name: 'idPuesto', type: sql.Int, value: idPuesto },
                { name: 'ValorDocumentoIdentidad', type: sql.VarChar(16), value: ValorDocumentoIdentidad },
                { name: 'Nombre', type: sql.VarChar(64), value: Nombre },
                { name: 'FechaContratacion', type: sql.Date, value: FechaContratacion }
            ]);
            res.status(201).json(result);
        } catch (err) {
            res.status(500).json({ error: err.message });
        }
    }
};

/* const loginController = {
    login: async (req, res) => {
        try {
            const { user, pwd } = req.body;
            const ip = req.ip; 
            const request = new sql.Request(await pool.connect());



            request.input('user', sql.VarChar(32), user);
            request.input('pwd', sql.VarChar(16), pwd);
            
            const result = await request.execute('sp_LoginUsuario');
            
            if (result.recordset.length === 0) {
                res.status(401).json({ mensaje: 'Usuario o contraseña incorrectos' });
            } else {
                res.json({ mensaje: 'Login exitoso', usuario: result.recordset[0] });
            }
        } catch (err) {
            res.status(500).json({ 
                codigoError: err.number || 500,
                mensaje: err.message 
            });
        }
    }
}; */

const loginController = {
    login: async (req, res) => {
        try {
            const { user, pwd } = req.body;
            const clientIp = req.ip || req.headers['x-forwarded-for'] || req.connection.remoteAddress;

            // Check recent failed attempts by IP
            const checkAttemptsRequest = new sql.Request(await pool.connect());
            checkAttemptsRequest.input('ip', sql.VarChar(64), clientIp);
            const attemptsResult = await checkAttemptsRequest.execute('sp_GetFailedLoginAttempts');

            const failedAttempts = attemptsResult.recordset.length;
            const maxAttempts = 5;
            const lockoutMinutes = 10;

            if (failedAttempts >= maxAttempts) {
                return res.status(403).json({
                    mensaje: `Demasiados intentos fallidos. Espere ${lockoutMinutes} minutos.`,
                    isLockedOut: true,
                    attemptsLeft: 0
                });
            }

            // Try login with user + pwd
            const request = new sql.Request(await pool.connect());
            request.input('user', sql.VarChar(32), user);
            request.input('pwd', sql.VarChar(16), pwd);

            const result = await request.execute('sp_LoginUsuario');

            if (result.recordset.length === 0) {
                // Login failed → log failed attempt
                const logAttemptRequest = new sql.Request(await pool.connect());
                logAttemptRequest.input('user', sql.VarChar(32), user);
                logAttemptRequest.input('ip', sql.VarChar(64), clientIp);
                await logAttemptRequest.execute('sp_LogFailedLoginAttempt');

                const attemptsLeft = maxAttempts - failedAttempts - 1;

                const warningMessage = attemptsLeft > 0
                    ? `Usuario o contraseña incorrectos. Intentos restantes: ${attemptsLeft}.`
                    : `Último intento fallido. Su IP será bloqueada por ${lockoutMinutes} minutos.`;

                return res.status(401).json({
                    mensaje: warningMessage,
                    attemptsLeft: attemptsLeft
                });
            } else {
                // Successful login → clear failed attempts
                const clearAttemptsRequest = new sql.Request(await pool.connect());
                clearAttemptsRequest.input('ip', sql.VarChar(64), clientIp);
                await clearAttemptsRequest.execute('sp_ClearFailedLoginAttempts');

                res.json({ mensaje: 'Login exitoso', usuario: result.recordset[0] });
            }
        } catch (err) {
            console.error('Login controller error:', err); 
            res.status(500).json({ 
                codigoError: err.number || 500,
                mensaje: err.message 
            });
        }
    
    },
    checkLockout: async (req, res) => {
        try {
          const clientIp = req.ip || req.headers['x-forwarded-for'] || req.connection.remoteAddress;
          const request = new sql.Request(await pool.connect());
          request.input('ip', sql.VarChar(64), clientIp);
    
          const result = await request.execute('sp_CheckLockoutStatus');
    
          if (result.recordset.length > 0) {
            const lockoutTime = result.recordset[0].PostTime;
            const minutesSinceLockout = (new Date() - lockoutTime) / (1000 * 60);
            const minutesLeft = 10 - Math.floor(minutesSinceLockout);
            res.json({ isLockedOut: true, minutesLeft });
          } else {
            res.json({ isLockedOut: false });
          }
        } catch (err) {
          console.error('Error checking lockout:', err);
          res.status(500).json({ mensaje: 'Error checking lockout status' });
        }
      }
};





module.exports = {empleadoController,loginController};
