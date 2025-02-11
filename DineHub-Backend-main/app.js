const express = require("express");
const bodyParser = require("body-parser");
const UserRoute = require("./routes/user.routes");
const SellerRoute = require('./routes/sellerroutes');
const path = require('path'); // Import the path module
const item = require('./routes/item.routes');
const menu = require('./routes/menu.routes');
const cart = require('./routes/cart.routes'); // Import cart routes
const address = require('./routes/address.routes'); // Import address routes
const order = require('./routes/order.routes'); // Import order routes
const stripeRoutes = require('./routes/stripe.routes');
const app = express();


app.use(bodyParser.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.use("/", UserRoute);
app.use("/", SellerRoute);
app.use("/", menu);
app.use("/", item);
app.use("/", cart); // Use cart routes
app.use("/", address); // Use address routes
app.use("/", order); // Use order routes
app.use('/', stripeRoutes);

module.exports = app;