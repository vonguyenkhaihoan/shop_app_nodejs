const mongoose = require("mongoose");
const db = require('../config/db');
const { productSchema } = require("./product_model");

const orderShema = mongoose.Schema({
    products: [
        {
          product: productSchema,
          quantity: {
            type: Number,
            required: true,
          },
        },
      ],
      totalPrice: {
        type: Number,
        required: true,
      },
      address: {
        type: String,
        required: true,
      },
      phone: {
        type: String,
        default: "",
      },
      userId: {
        required: true,
        type: String,
      },
      orderedAt: {
        type: Number,
        required: true,
      },  
      status: {
        type: Number,
        default: 0,
      },
});

const Order = mongoose.model("Order", orderShema);
module.exports = Order;
