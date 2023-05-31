const createError = require("http-errors");
const db = require("../models");
require("dotenv").config();

const { fishes, users, fish_types } = require("../models");

exports.getFishById = async (req, res, next) => {
  try {
    //Retrieve id from the body
    const id = req.params.id;

    //Get the fish data using id from the body parameter
    const fish = await fishes.findByPk(id, {
      include: [
        {
          model: users,
          attributes: ["id", "username", "email"],
        },
        {
          model: fish_types,
          attributes: ["id", "name"],
        },
      ],
    });

    //Generate API callback
    res.json({
      fish,
    });
  } catch (error) {
    next(error);
  }
};

exports.getFishByCategory = async (req, res, next) => {
  try {
    //Retrieve id from the body
    const id = req.params.id;

    //Get the fish data using id from the body parameter
    const fish = await fishes.findAll({
      where: {
        fish_type_id: id,
      },
      include: [
        {
          model: users,
          attributes: ["id", "username", "email"],
        },
        {
          model: fish_types,
          attributes: ["id", "name"],
        },
      ],
    });

    //Generate API callback
    res.json({
      fishes: fish,
    });
  } catch (error) {
    next(error);
  }
};

exports.getFish = async (req, res, next) => {
  try {
    //Get all fishes data
    const allfish = await fishes.findAll({
      //include the data from users and fish_types model
      include: [
        {
          model: users,
          attributes: ["id", "username", "email"],
        },
        {
          model: fish_types,
          attributes: ["id", "name"],
        },
      ],
    });

    //Generate API callback
    res.json({
      fishes: allfish,
    });
  } catch (error) {
    next(error);
  }
};

exports.deleteFish = async (req, res, next) => {
  //Retrieve the id parameter from the body
  const { id } = req.body;
  try {
    //Delete the fish
    const deleteFish = await fishes.destroy({
      where: {
        id: id,
      },
      truncate: false,
    });

    //Generate API Callback
    res.json({
      status: "success",
    });
  } catch (error) {
    next(error);
  }
};

exports.addFish = async (req, res, next) => {
  try {
    //Get all the parameters from body
    const { user_id, fish_type_id, name, description, price, image_path } =
      req.body;

    console.log({
      user_id: user_id,
      fish_type_id: fish_type_id,
      name: name,
      description: description,
      price: price,
      image_path: image_path,
    });

    //Find the last record ID to generate the next ID
    const checkData = await fishes.findOne({
      order: [["id", "DESC"]],
    });

    //Create the record for the new fish
    const fish = await fishes.create({
      id: parseInt(checkData.id) + 1,
      user_id: parseInt(user_id),
      fish_type_id: parseInt(fish_type_id),
      name: name,
      description: description.substring(0, 49),
      price: parseInt(price),
      image_path: image_path,
    });

    //Generate API callback
    res.json({
      status: "success",
      // fish,
    });
  } catch (error) {
    return next(createError(400, "Failed to create new fish data."));
  }
};

exports.editFish = async (req, res, next) => {
  try {
    //Get the parameters from the body
    const { id, name, description, fish_type_id, price, image_path } = req.body;

    //Update the fish data using the data from the parameters
    await fishes.update(
      {
        name: name,
        description: description,
        fish_type_id: fish_type_id,
        price: parseInt(price),
        image_path: image_path,
      },
      {
        where: {
          id: id,
        },
      }
    );

    //Find the fish data that already updated
    const fish = await fishes.findOne({
      where: {
        id: id,
      },
    });

    //Generate API Callback
    res.json({
      status: "success",
      fish,
    });
  } catch (error) {
    return next(createError(400, "Failed to update fish data."));
  }
};
