const createError = require("http-errors");
require("dotenv").config();

const { users } = require("../models");

exports.login = async (req, res, next) => {
  try {
    const { username, password } = req.body;
    const user = await users.findOne({
      where: {
        username: username,
        password: password,
      },
      attributes: ["id", "email", "username", "password", "token"],
    });

    if (!user) {
      throw createError(400, "Wrong username or password. Please try again.");
    } else {
      res.json({
        user,
      });
    }
  } catch (error) {
    next(error);
  }
};

function createToken(length) {
  var result = "";
  var characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  var charactersLength = characters.length;
  for (var i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
}
exports.register = async (req, res, next) => {
  try {
    const { email, username, password } = req.body;
    const checkUser = await users.findOne({
      where: {
        username: username,
      },
    });
    if (checkUser) {
      return next(
        createError(
          400,
          "Username already exists. Please login to your account."
        )
      );
    }
    const existingUser = await users.findAll();
    const token = createToken(10);
    const user = await users.create({
      id: existingUser.length + 1,
      email: email,
      username: username,
      password: password,
      token: token,
    });

    res.json({
      user,
      token,
    });
  } catch (error) {
    next(error);
  }
};
