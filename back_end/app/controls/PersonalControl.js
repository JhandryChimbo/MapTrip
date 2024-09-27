"use strict";
var models = require("../models");
var personal = models.personal;
var cuenta = models.cuenta;

class PersonalControl {
    constructor() {
        this.personal = personal;
        this.cuenta = cuenta;
    }

    async listar_personal(req, res) {
        try {
            let personal = await this.personal.findAll({
                include: [
                    {
                        model: this.cuenta,
                        as: "cuenta",
                    },
                ],
            });
            res.status(200).json(personal);
        } catch (error) {
            res.status(500).json(error);
        }
    }

    //TODO: FIX guardar_personal method to save data in the database
    async guardar_personal(req, res) {
        if (req.body.hasOwnProperty("apellidos") && req.body.hasOwnProperty("nombres") && req.body.hasOwnProperty("celular") && req.body.hasOwnProperty("correo") && req.body.hasOwnProperty("clave")) {
            try {
                let personalA = await this.personal.create({
                    apellidos: req.body.apellidos,
                    nombres: req.body.nombres,
                    celular: req.body.celular,
                });
                let cuentaA = await this.cuenta.create({
                    correo: req.body.correo,
                    clave: req.body.clave,
                    id_personal: personalA.id,
                });
                res.status(200).json({ msg: "OK", tag: "Personal creado", code: 200 });
            } catch (error) {
                res.status(500).json(error);
            }

        } else {
            res.status(400).json({ msg: "ERROR", tag: "Faltan datos", code: 400 });

        }
    }
}

module.exports = PersonalControl;
