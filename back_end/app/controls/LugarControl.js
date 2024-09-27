"use strict";

var models = require("../models");
var lugar = models.lugar;

class LugarControl {
    async crear_lugar(req, res) {
        if (req.body.hasOwnProperty("nombre") && req.body.hasOwnProperty("tipo") && req.body.hasOwnProperty("longitud") && req.body.hasOwnProperty("latitud")) {
            let lugarA = await lugar.create({
                nombre: req.body.nombre,
                tipo: req.body.tipo,
                longitud: req.body.longitud,
                latitud: req.body.latitud,
            });
            if (lugarA === null) {
                res.status(400);
                res.json({ msg: "ERROR", tag: "No se pudo crear el lugar", code: 400 });
            } else {
                res.status(200);
                res.json({ msg: "OK", tag: "Lugar creado", code: 200 });
            }
        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
        }
    }
    async listar_lugares(req, res) {
        let lugaresA = await lugar.findAll();
        if (lugaresA === null) {
            res.status(400);
            res.json({ msg: "ERROR", tag: "No hay lugares", code: 400 });
        } else {
            res.status(200);
            res.json({ msg: "OK", tag: "Listo :)", datos: lugaresA, code: 200 });
        }
    }
    async obtener_lugar(req, res) {
        if (req.body.hasOwnProperty("external_id")) {
            let lugarA = await lugar.findOne({
                where: { external_id: req.body.external_id },
            });
            if (lugarA === null) {
                res.status(400);
                res.json({ msg: "ERROR", tag: "No se encontro el lugar", code: 400 });
            } else {
                res.status(200);
                res.json({ msg: "OK", tag: "Listo :)", datos: lugarA, code: 200 });
            }
        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
        }
    }
    async editar_lugar(req, res) {
        if (req.body.hasOwnProperty("external_id") && req.body.hasOwnProperty("nombre") && req.body.hasOwnProperty("tipo") && req.body.hasOwnProperty("longitud") && req.body.hasOwnProperty("latitud")) {
            let lugarA = await lugar.update({
                nombre: req.body.nombre,
                tipo: req.body.tipo,
                longitud: req.body.longitud,
                latitud: req.body.latitud,
            }, {
                where: { external_id: req.body.external_id },
            });
            if (lugarA === null) {
                res.status(400);
                res.json({ msg: "ERROR", tag: "No se pudo editar el lugar", code: 400 });
            } else {
                res.status(200);
                res.json({ msg: "OK", tag: "Lugar editado", code: 200 });
            }
        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
        }
    }
}

module.exports = LugarControl;