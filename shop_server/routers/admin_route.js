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

router.get('/api/categoriesPercentage',AdminController.categoriesPercentage);

//tông don hang theo tung thang
router.get('/orders-per-month', async (req, res) => {
  try {
    const currentYear = new Date().getFullYear();

    // Truy vấn cơ sở dữ liệu để lấy số đơn hàng theo tháng
    const ordersByMonth = await OrderModel.aggregate([
      {
        $match: {
          orderedAt: {
            $gte: new Date(`${currentYear}-01-01`).getTime(),
            $lt: new Date(`${currentYear + 1}-01-01`).getTime(),
          },
        },
      },
      {
        $group: {
          _id: { $month: { $toDate: '$orderedAt' } },
          totalOrders: { $sum: 1 },
        },
      },
    ]);

    // Tạo một mảng 12 phần tử (mỗi tháng) và gán giá trị 0 cho các tháng không có đơn hàng
    const monthlyOrders = Array.from({ length: 12 }, (_, index) => {
      const monthData = ordersByMonth.find(item => item._id === index + 1);
      return monthData ? monthData.totalOrders : 0;
    });

    res.json({ success: true, data: monthlyOrders });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Internal Server Error' });
  }
});

//tông don hang theo tung thang ket qua sai
router.get('/order-statistics', async (req, res) => {
  try {
    const currentYear = new Date().getFullYear();

    const monthlyOrderCounts = await OrderModel.aggregate([
      {
        $match: {
          orderedAt: {
            $gte: new Date(`${currentYear}-01-01`),
            $lt: new Date(`${currentYear + 1}-01-01`),
          },
        },
      },
      {
        $group: {
          _id: { $month: '$orderedAt' }, // Remove $toDate here
          count: { $sum: 1 },
        },
      },
    ]);

    const result = Array.from({ length: 12 }, (_, index) => {
      const month = index + 1;
      const count = monthlyOrderCounts.find((item) => item._id === month)?.count || 0;
      return { month, count };
    });

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// // Định nghĩa API route để tính tổng số tiền bán được của mỗi tháng trong năm hiện tại
// router.get('/api/sales', async (req, res) => {
//   const currentYear = new Date().getFullYear();

//   try {
//     const monthlySales = await OrderModel.aggregate([
//       {
//         $match: {
//           orderedAt: {
//             $gte: new Date(`${currentYear}-01-01`).getTime(),
//             $lt: new Date(`${currentYear + 1}-01-01`).getTime(),
//           },
//         },
//       },
//       {
//         $group: {
//           _id: { $month: '$orderedAt' },
//           totalSales: { $sum: '$totalPrice' },
//         },
//       },
//       {
//         $sort: {
//           _id: 1,
//         },
//       },
//     ]);

//     res.json(monthlySales);
//   } catch (error) {
//     res.status(500).json({ error: 'Internal Server Error' });
//   }
// });


// Helper function to get month name from its index
const getMonthName = (index) => {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[index];
};

// API endpoint to calculate monthly revenue for the current year
router.get('/revenue-by-month', async (req, res) => {
  try {
    const currentYear = new Date().getFullYear();
    const orders = await OrderModel.find({
      orderedAt: {
        $gte: new Date(`${currentYear}-01-01`).getTime(),
        $lt: new Date(`${currentYear + 1}-01-01`).getTime(),
      },
      status: 0, // Only consider orders with status "1" (adjust as needed)
    });

    const monthlyRevenue = Array(12).fill(0);

    orders.forEach((order) => {
      const orderedDate = new Date(order.orderedAt);
      const month = orderedDate.getMonth();
      monthlyRevenue[month] += order.totalPrice;
    });

    const result = monthlyRevenue.map((revenue, index) => ({
      month: getMonthName(index),
      monthlyRevenue: revenue,
    }));

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Internal Server Error' });
  }
});



module.exports = router;
