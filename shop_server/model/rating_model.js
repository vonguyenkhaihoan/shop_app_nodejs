const mongoose = require("mongoose");
const db = require('../config/db');

const ratingSchema = mongoose.Schema({
    userId: {
      type: String,
      required: true,
    },
    rating: {
      type: Number,
      required: true,
    },
    //loi dang gia
    // reviews: {
    //     type: String,
    //     required: false,
    //   },
},
  { timestamps: true },
);

module.exports = ratingSchema;