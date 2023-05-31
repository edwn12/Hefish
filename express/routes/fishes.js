const express = require("express");
const router = express.Router();
const fishController = require("../controllers/fishControllers");
// const authMiddleware = require("../middlewares/authMiddleware");

router.get("/list", fishController.getFish);
router.post("/add", fishController.addFish);
router.post("/edit", fishController.editFish);
router.post("/delete", fishController.deleteFish);
router.post("/get/:id", fishController.getFishById);
router.get("/category/:id", fishController.getFishByCategory);

module.exports = router;
