var express = require('express');
var router = express.Router();

let jwt = require("jsonwebtoken");

const lugarControl = require("../app/controls/LugarControl");
let LugarControl = new lugarControl();

const personalControl = require("../app/controls/PersonalControl");
let PersonalControl = new personalControl();

const cuentaControl = require("../app/controls/CuentaControl");
let CuentaControl = new cuentaControl();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

const auth = function middleware() {
  return async function (req, res, next) {
    const token = req.headers["maptrip-token"];

    if (token === undefined) {
      res.status(401);
      res.json({
        msg: "ERROR",
        tag: "Falta token",
        code: 401,
      });
    } else {
      require("dotenv").config();
      const key = process.env.KEY_JWT;
      jwt.verify(token, key, async (err, decoded) => {
        if (err) {
          res.status(401);
          res.json({
            msg: "ERROR",
            tag: "Token no valido o expirado",
            code: 401,
          });
        } else {
          console.log(decoded.external);
          const models = require("../app/models");
          const cuenta = models.cuenta;
          const aux = await cuenta.findOne({
            where: { external_id: decoded.external },
            include: [
              {
                model: models.personal,
                as: "personal",
                attributes: ["apellidos", "nombres"],
              },
            ],
          });
          if (aux === null) {
            res.status(401);
            res.json({
              msg: "ERROR",
              tag: "Token no valido",
              code: 401,
            });
          } else {
            next();
          }
        }
      });
    }
  };
};

router.get('/listar',LugarControl.listar_lugares);
router.get('/listar_tipo', auth(), LugarControl.listar_lugares_tipo);

router.post('/guardar', PersonalControl.guardar_personal);

router.post('/inicio_sesion', CuentaControl.inicio_sesion);
module.exports = router;
