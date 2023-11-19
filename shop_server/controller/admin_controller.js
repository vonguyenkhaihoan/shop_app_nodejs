const OrderModel = require('../model/order_model');
const {ProductModel} = require("../model/product_model");
const UserModel = require('../model/user_model');
const CategoryModel =require('../model/catyerogy_model.js');




class AdmminController {
  //update admin infor
  async updateAdmin(req, res) {
    try {
      const { name, address, phone, gender} = req.body;
      let user = await UserModel.findById(req.user);
       // Kiểm tra xem người dùng có tồn tại
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      user.name = name;
      user.address = address;
      user.phone = phone;
      user.gender = gender;
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }

 /* //update san pham
  async updateProduct(req, res) {
    try {
      const {id, name, description, quantity ,price, caterogy} = req.body;
      let product = await ProductModel.findById(id);
       // Kiểm tra xem người dùng có tồn tại
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      product.name = name;
      product.description = description;
      product.quantity = quantity;
      product.price = price;
      product.category = caterogy;

      product = await product.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }*/

  //them sản pham có danh mục
  async addProductCaterogy(req, res) {
    try {
        const { name, description, images, quantity, price, categoryId } = req.body;

        // Kiểm tra xem danh mục có tồn tại không
        const category = await CategoryModel.findById(categoryId);
        if (!category) {
            return res.status(400).json({ error: 'Danh mục không tồn tại' });
        }

        // Tạo sản phẩm mới và liên kết với danh mục
        let product = new ProductModel({
            name,
            description,
            images,
            quantity,
            price,
            category: categoryId,
        });

        // Lưu sản phẩm vào database
        product = await product.save();

        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
}

  // them san pham ban
  async addProduct (req, res)  {
    try {
      const { name, description, images, quantity, price, category } = req.body;
      let product = new ProductModel({
        name,
        description,
        images,
        quantity,
        price,
        category,
      });
      product = await product.save();
      res.json(product);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }

  //lay tat ca san pham
  async getAllProduct (req, res)  {
    try {
      //tim tat ca san pham
      // const products = await ProductModel.find({});
      const products = await ProductModel.find().sort({ createdAt: 'desc' });
  
      //tra ve nguoi dung
      res.json(products);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }

  //lay tong so luong san pham
  async totalProduct (req, res)  {
    const totalProduct = await getTotalProduct();
    res.json({ totalProduct });
  }

  // lay tat ca don hang
  async getAllOrder(req, res)  {
    try {
      const orders = await OrderModel.find({});
      res.json(orders);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }

  //xoa san pham 
    async deleteProduct (req, res)  {
      try {
        //lay id san pham tu UI
        const { id } = req.body;
    
        //timf vao xoa san pham theo ID
        let product = await ProductModel.findByIdAndDelete(id);
    
        //phan hoi nguoi dung
        res.json(product);
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
    }

    // change order status
    async changeOrderStatus (req, res)  {
        try {
          //lay id san pham tu UI
          const { id , status} = req.body;
      
          //timf vao xoa san pham theo ID
          // let order = await OrderModel.findById(id);
          // order.status = status
          let order = await OrderModel.findByIdAndUpdate(id, { status });
      
          order = await order.save();
          //phan hoi nguoi dung
          res.json(order);
        } catch (e) {
          res.status(500).json({ error: e.message });
        }
    }

    //get analytics
    async getAnalytics (req, res) {
        try {
            const orders = await OrderModel.find({});
            let totalEarnings = 0;
      
            for (let i = 0; i < orders.length; i++) {
                for (let j = 0; j < orders[i].products.length; j++) {
                totalEarnings +=
                    orders[i].products[j].quantity * orders[i].products[j].product.price;
                }   
            }

            // CATEGORY WISE ORDER FETCHING
            let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
            let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
            let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
            let booksEarnings = await fetchCategoryWiseProduct("Books");
            let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

            let earnings = {
                totalEarnings,
                mobileEarnings,
                essentialEarnings,
                applianceEarnings,
                booksEarnings,
                fashionEarnings,
            };

            res.json(earnings);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    //update product
    // async updateProduct (req, res)  {
    //   const { Id, name, description, images, quantity, price, category } = req.body;
    
    //   // Validate the request body
    //   if (!Id || !name || !description || !images || !quantity || !price || !category) {
    //     return res.status(400).json({
    //       message: 'Invalid request body',
    //     });
    //   }
    
    //   // Find the product to be updated
    //   const product = await ProductModel.findById(Id);
    
    //   // If the product does not exist, return an error
    //   if (!product) {
    //     return res.status(404).json({
    //       message: 'Product not found',
    //     });
    //   }
    
    //   // Update the product information
    //   product.name = name;
    //   product.description = description;
    //   product.images = images;
    //   product.quantity = quantity;
    //   product.price = price;
    //   product.category = category;
    
    //   // Save the product changes
    //   await product.save();
    
    //   // Return the updated product
    //   return res.status(200).json({
    //     product,
    //   });
    // };

     //tổng danh thu
     async totalRevenu (req, res)  {
      let totalRevenue = await getTotalRevenue();
    
      // Trả về tổng doanh thu cho client
      res.status(200).json({ totalRevenue });
    }

     //tổng sl don hang
     async totalOrder (req, res)  {
      let totalOrders = await getTotalOrders();
      res.status(200).json({ totalOrders });
    }

    //phần trăm danh muc
    async categoriesPercentage (req, res)  {
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
    }

    async  categorySalesTotal(req, res) {
      try {
        const categories = await CategoryModel.find();
        
        const salesData = await Promise.all(categories.map(async (category) => {
          // Lấy tất cả đơn hàng chứa sản phẩm thuộc danh mục đó
          const orders = await OrderModel.find({ "products.product.category": category.name });
    
          // Tính tổng số tiền bán được cho từng danh mục
          const categoryTotalSales = orders.reduce((totalSales, order) => {
            return totalSales + order.totalPrice;
          }, 0);
    
          return { name: category.name, totalSales: categoryTotalSales };
        }));
    
        res.json(salesData);
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal Server Error' });
      }
    }
   


}

//ham tong so san pham
async function getTotalProduct() {
  const totalProduct = await ProductModel.countDocuments();
  return totalProduct;
}


//ham tong tien cua tung danh muc 
async function fetchCategoryWiseProduct(category) {
    let earnings = 0;
    let categoryOrders = await OrderModel.find({
      "products.product.category": category,
    });
  
    for (let i = 0; i < categoryOrders.length; i++) {
      for (let j = 0; j < categoryOrders[i].products.length; j++) {
        earnings +=
          categoryOrders[i].products[j].quantity *
          categoryOrders[i].products[j].product.price;
      }
    }
    return earnings;
}

// ham tinh danh thu
const getTotalRevenue = async () => {
  // Lấy tất cả đơn hàng
  const orders = await OrderModel.find({});

  // Tính tổng doanh thu
  const total = orders.reduce((acc, order) => {
    return acc + order.totalPrice;
  }, 0);

  // Trả về tổng doanh thu
  return total;
};

//ham tinhs tong don hang
async function getTotalOrders() {
  const totalOrders = await OrderModel.countDocuments();
  return totalOrders;
}

module.exports = new AdmminController();