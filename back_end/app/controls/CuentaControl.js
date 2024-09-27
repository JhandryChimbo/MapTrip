"use strict";

var models = require("../models");
var cuenta = models.cuenta;
let jwt = require("jsonwebtoken");
class CuentaControl {
  async inicio_sesion(req, res) {
    if (!req.body.correo || !req.body.clave) {
      return res
        .status(400)
        .json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
    }
    let cuentaA = await cuenta.findOne({
      where: { correo: req.body.correo },
      include: [
        {
          model: models.personal,
          as: "personal",
          attributes: ["nombres", "apellidos", "external_id"],
        },
      ],
    });
    if (cuentaA === null) {
      return res
        .status(401)
        .json({ msg: "ERROR", tag: "Cuenta no encontrada", code: 401 });
    } else {
      if (cuentaA.estado == true) {
        if (cuentaA.clave == req.body.clave) {
          let token_data = {
            external: cuentaA.external_id,
            check: true,
          };
          require("dotenv").config();
          const key = process.env.KEY_JWT;
          const token = jwt.sign(token_data, key, {
            expiresIn: "2h",
          });
          var info = {
            token: token,
            user: cuentaA.personal.apellidos + " " + cuentaA.personal.nombres,
            id: cuentaA.personal.external_id,
          };
          res.status(200).json({ msg: "OK", tag: info, code: 200 });
        } else {
          return res
            .status(401)
            .json({
              msg: "ERROR",
              tag: "La informacion ingresada es incorrecta",
              code: 401,
            });
        }
      } else {
        return res
          .status(403)
          .json({ msg: "ERROR", tag: "Cuenta inactiva", code: 403 });
      }
    }
  }
}

module.exports = CuentaControl;
