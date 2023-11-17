const mongoose = require("mongoose");
const db = require('../config/db');
const ratingSchema = require("./rating_model");

const productSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
      },
      description: {
        type: String,
        required: true,
        trim: true,
      },
      images: [
        {
          type: String,
          required: true,
        },
      ],
      quantity: {
        type: Number,
        required: true,
      },
      price: {
        type: Number,
        required: true,
      },
      category: {
        type: String,
        required: true,
      },
      ratings: [
        ratingSchema
      ]
},{ timestamps: true });

const ProductModel = mongoose.model("Product", productSchema);
module.exports = {ProductModel, productSchema};