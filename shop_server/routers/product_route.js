const router = require("express").Router();
const AuthMidd = require("../middlewares/auth_middle");
const {ProductModel} = require("../model/product_model");
const ProductController = require("../controller/product_controller");

//lay tat ca san pham
router.get("/api/products", AuthMidd , ProductController.getProduct);


//tìm kiếm sản phẩm
router.get("/api/products/search/:name", AuthMidd, ProductController.searchProduct);


//danh gia san pham
router.post("/api/rate-product", AuthMidd, async (req, res) => {
    try {
      // Lấy ID sản phẩm và đánh giá từ yêu cầu.
      const { id, rating } = req.body;
  
      // Tìm sản phẩm trong cơ sở dữ liệu.
      let product = await ProductModel.findById(id);
  
      // Kiểm tra xem người dùng đã đánh giá sản phẩm chưa.
      for (let i = 0; i < product.ratings.length; i++) {
        if (product.ratings[i].userId == req.user) {
          // Cập nhật đánh giá của người dùng.
          product.ratings[i].rating = rating;
          break;
        }
      }
  
      // Nếu người dùng chưa đánh giá sản phẩm, hãy thêm đánh giá mới.
      if (!product.ratings.some(rating => rating.userId == req.user)) {
        product.ratings.push({ userId: req.user,
             rating ,});
      }
  
      // Lưu sản phẩm vào cơ sở dữ liệu.
      product = await product.save();
  
      // Trả về sản phẩm cho người dùng.
      res.json(product);
    } catch (e) {
      // Trả về lỗi 500 nếu có lỗi xảy ra.
      res.status(500).json({ error: e.message });
    }
  });

//lay muoi san pham dau trong danh sach danh gia gian pham
router.get("/api/top-rate", AuthMidd, ProductController.toprate);

  // lay san pham dung dau ds danh gia
  router.get("/api/deal-of-day", AuthMidd, async (req, res) => {
    try {
      let products = await ProductModel.find({});
  
      products = products.sort((a, b) => {
        let aSum = 0;
        let bSum = 0;
  
        for (let i = 0; i < a.ratings.length; i++) {
          aSum += a.ratings[i].rating;
        }
  
        for (let i = 0; i < b.ratings.length; i++) {
          bSum += b.ratings[i].rating;
        }
        return aSum < bSum ? 1 : -1;
      });
  
      res.json(products[0]);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

module.exports = router;


