require("dotenv").config();
const express = require("express");
const path = require("path");
const bodyParser = require("body-parser");
const app = express();
const exphbs = require("express-handlebars");

require("./models");

global.__basedir = __dirname;

app.set("port", process.env.APP_PORT);
app.engine("hbs", exphbs.engine({ extname: ".hbs" }));
app.set("view engine", "hbs");
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.static(path.resolve(__dirname, "./public")));

app.use(async (req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "*");
  res.header("Access-Control-Allow-Methods", "*");
  next();
});
// app.use("/storage", express.static(path.resolve(process.env.rootDir)));
app.use("/", require("./routes/index"));
app.use("/users", require("./routes/users"));
app.use("/fishtypes", require("./routes/fish_types"));
app.use("/fishes", require("./routes/fishes"));

app.use((error, req, res, next) => {
  res.status(error.status || 500);
  console.log("ERROR", error);

  res.json({
    message: error.message,
    stack: process.env.NODE_ENV !== "production" ? error.stack : undefined,
  });
});

app.listen(process.env.APP_PORT, () => {
  console.log("API Running - Listening to port " + process.env.APP_PORT);
});
