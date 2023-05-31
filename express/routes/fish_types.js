const express = require("express");
const router = express.Router();
const fishTypesController = require("../controllers/fishTypesController");
// const authMiddleware = require("../middlewares/authMiddleware");

router.get("/types", fishTypesController.getFishTypes);

module.exports = router;
