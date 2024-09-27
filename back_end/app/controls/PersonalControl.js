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
        const { apellidos, nombres, celular, correo, clave } = req.body;
        if (!apellidos || !nombres || !celular || !correo || !clave) {
            return res.status(400).json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
        }
        const uuid = require("uuid");
        const data = {
            nombres,
            external_id: uuid.v4(),
            celular,
            apellidos,
            cuenta: {
                estado: true,
                correo,
                clave,
            },
        };
        try {
            const transaction = await models.sequelize.transaction();
            const result = await personal.create(data, {
                include: [{ model: models.cuenta, as: "cuenta" }],
                transaction,
            });
            await transaction.commit();

            if (!result) {
                return res.status(401).json({ msg: "ERROR", tag: "No se pudo guardar", code: 401 });
            }
            res.status(200).json({ msg: "OK", tag: "Cuenta creada correctamente", code: 200 });
        } catch (error) {
            if (transaction) await transaction.rollback();
            res.status(500).json({ msg: "ERROR", tag: error.message, code: 500 });
        }
    }
}

module.exports = PersonalControl;
