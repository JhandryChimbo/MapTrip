"use strict";

module.exports = (sequelize, DataTypes) => {
    const lugar = sequelize.define(
        "lugar",
        {
            nombre: { type: DataTypes.STRING(150), defaultValue: "NONE" },
            tipo: {type: DataTypes.ENUM(['HOTEL', 'PLAZA', 'PARQUE', 'MUSEO', 'RESTAURANTE', 'EDUCATIVO', ]), defaultValue: "HOTEL"},
            longitud: {type: DataTypes.DOUBLE},
            latitud: {type: DataTypes.DOUBLE},
            external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 },
        },
        { freezeTableName: true }
    );
    return lugar;
};

