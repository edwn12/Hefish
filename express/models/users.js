"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, Sequelize) => {
  class users extends Model {
    static associate(models) {}
  }
  users.init(
    {
      id: {
        allowNull: false,
        primaryKey: true,
        type: Sequelize.INTEGER(10),
      },
      email: {
        allowNull: false,
        type: Sequelize.STRING(50),
        unique: true,
      },
      username: {
        allowNull: false,
        type: Sequelize.STRING(50),
        unique: true,
      },
      password: {
        allowNull: false,
        type: Sequelize.STRING(25),
      },
      token: {
        allowNull: false,
        type: Sequelize.STRING(10),
        unique: true,
      },
    },
    {
      sequelize,
      freezeTableName: true,
      modelName: "users",
      timestamps: false,
    }
  );
  return users;
};
