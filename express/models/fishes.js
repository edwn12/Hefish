"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, Sequelize) => {
  class fishes extends Model {
    static associate(models) {
      this.hasOne(models.users, {
        sourceKey: "user_id",
        foreignKey: "id",
      });
      this.hasOne(models.fish_types, {
        sourceKey: "fish_type_id",
        foreignKey: "id",
      });
    }
  }
  fishes.init(
    {
      id: {
        allowNull: false,
        primaryKey: true,
        type: Sequelize.INTEGER(10),
      },
      user_id: {
        allowNull: false,
        type: Sequelize.INTEGER(10),
      },
      fish_type_id: {
        allowNull: false,
        type: Sequelize.INTEGER(10),
      },
      name: {
        allowNull: false,
        type: Sequelize.STRING(50),
      },
      description: {
        allowNull: false,
        type: Sequelize.STRING(50),
      },
      price: {
        allowNull: false,
        type: Sequelize.INTEGER(20),
      },
      image_path: {
        allowNull: false,
        type: Sequelize.STRING(100),
      },
    },
    {
      sequelize,
      freezeTableName: true,
      modelName: "fishes",
      timestamps: false,
    }
  );
  return fishes;
};
