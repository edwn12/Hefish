"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, Sequelize) => {
  class fish_types extends Model {
    static associate(models) {}
  }
  fish_types.init(
    {
      id: {
        allowNull: false,
        primaryKey: true,
        type: Sequelize.INTEGER(10),
      },
      name: {
        allowNull: false,
        type: Sequelize.STRING(50),
      },
    },
    {
      sequelize,
      freezeTableName: true,
      modelName: "fish_types",
      timestamps: false,
    }
  );
  return fish_types;
};
