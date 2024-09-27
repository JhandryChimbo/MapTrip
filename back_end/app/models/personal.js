"use strict";

module.exports = (sequelize, DataTypes) => {
  const personal = sequelize.define(
    "personal",
    {
      apellidos: { type: DataTypes.STRING(150), defaultValue: "NONE" },
      nombres: { type: DataTypes.STRING(150), defaultValue: "NONE" },
      celular: { type: DataTypes.STRING(20), defaultValue: "NONE" },
      external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 },
    },
    { freezeTableName: true }
  );
  personal.associate = function (models) {
    personal.hasOne(models.cuenta, { foreignKey: "id_personal", as: "cuenta" });

  };
  return personal;
};
