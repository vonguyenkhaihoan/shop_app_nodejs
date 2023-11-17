const router = require("express").Router();
const AuthMidd = require("../middlewares/auth_middle");
const UserController = require("../controller/user_controller");


// Add product to cart
router.post('/api/add-to-cart', AuthMidd,  UserController.addToCart);

//delete quantiny 1 product to cart
router.delete('/api/remove-a-to-cart/:id', AuthMidd,  UserController.removeAToCart);

//deleta all cart
router.delete("/api/empty-cart", AuthMidd, UserController.removeAllCart);

//delete product by id
router.delete("/api/remove-from-cart/:id", AuthMidd, UserController.removeProductToCart);

// save user address
router.post("/api/save-user-address", AuthMidd,  UserController.saveUserAddress);

// order product
router.post("/api/order", AuthMidd, UserController.OrderProduct);

//don hang của toi
router.get("/api/orders/me", AuthMidd, UserController.MyOrder);
//update prodile
router.post('/api/update-user',AuthMidd, UserController.updateUser);

  


module.exports = router;
