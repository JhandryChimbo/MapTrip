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

router.get('/listar', LugarControl.listar_lugares);

router.post('/guardar', PersonalControl.guardar_personal);

router.post('/inicio_sesion', CuentaControl.inicio_sesion);
module.exports = router;
