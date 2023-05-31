const createError = require("http-errors");
require("dotenv").config();

const { fish_types } = require("../models");

exports.getFishTypes = async (req, res, next) => {
  try {
    const types = await fish_types.findAll({
      attributes: ["id", "name"],
    });
    res.json({
      types,
    });
  } catch (error) {
    return next(createError(400, "Failed to retrieve data"));
  }
};

exports.addFishTypes = async (req, res, next) => {
  const { name } = req.body;

  try {
    //Find the last record ID to generate the next ID
    const checkData = await fish_types.findOne({
      order: [["id", "DESC"]],
    });
    const fishType = await fish_types.create({
      id: parseInt(checkData) + 1,
      name: name,
    });

    res.json({
      status: "success",
      fishType,
    });
  } catch (error) {
    next(error);
  }
};
