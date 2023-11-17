const router = require("express").Router();
const AdminMidd = require("../middlewares/admin_middle");
const {ProductModel} = require("../model/product_model");
const OrderModel = require("../model/order_model");
const AdminController = require("../controller/admin_controller");
const CategoryModel =require('../model/catyerogy_model.js');


// Add product
router.post('/admin/add-product', AdminMidd,  AdminController.addProduct);
router.post('/admin/add-product-caterogy',   AdminController.addProductCaterogy);

router.post('/addProduct', async (req, res) => {
    try {
      // Extract product details from the request body
      const { name, description, images, quantity, price, category, ratings } = req.body;
  
      // Create a new product instance
      const newProduct = new ProductModel({
        name,
        description,
        images,
        quantity,
        price,
        category,
        ratings,
      });
  
      // Save the new product to the database
      const savedProduct = await newProduct.save();
  
      res.status(200).json(savedProduct);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });


//get all product
router.get("/admin/get-products", AdminMidd ,AdminController.getAllProduct);

//lay tat ca don hang
router.get("/admin/get-orders", AdminMidd, AdminController.getAllOrder);

// Delete the product
router.post("/admin/delete-product", AdminMidd ,AdminController.deleteProduct);

// change status Order
router.post("/admin/change-order-status", AdminMidd ,AdminController.changeOrderStatus);

//get analytics
router.get("/admin/analytics",  AdminController.getAnalytics);


//update product
router.post('/admin/update-admin',AdminMidd, AdminController.updateAdmin);


//tổng số đơn hàng
router.get('/api/total-order',AdminMidd, AdminController.totalOrder);

//tổng số tiền các don hang
//total revenu
router.get('/admin/api/total-revenue', AdminMidd,AdminController.totalRevenu);

//tong so san pham
router.get('/admin/total-product', AdminController.totalProduct);

router.get('/api/categoriesPercentage', async (req, res) => {
  try {
    const categories = await CategoryModel.find();
    const totalProducts = await ProductModel.countDocuments();

    const percentageData = categories.map(async (category) => {
      const categoryProducts = await ProductModel.countDocuments({ category: category.name });
      const percentage = (categoryProducts / totalProducts) * 100;
      return { name: category.name, percentage };
    });

    Promise.all(percentageData).then((result) => {
      res.json(result);
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});









module.exports = router;
