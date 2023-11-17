const CategoryModel =require('../model/catyerogy_model.js');


class CategoryController {
  //lay danh muc
    async getAllCategories(req, res) {
      try {
        //tim tat ca san pham
        const categories = await CategoryModel.find();
  
        //tra ve nguoi dung
        res.json(categories);

      } catch (e) {
        res.status(500).json({ error: e.message });
      }
    }
  
  //tạo danh mục
    async createCategory(req, res) {
      const category = new CategoryModel(req.body);
  
      await category.save();
  
      res.status(200).json(category);
    }
  
    //cap nhat danh muc
    async updateCategory(req, res) {
      const category = await CategoryModel.findByIdAndUpdate(req.params.id, req.body);
  
      res.status(200).json(category);
    }
  
    //xóa danh muc
    async deleteCategory(req, res) {
      await CategoryModel.findByIdAndDelete(req.params.id);
      res.status(200).send();
    }
  }
  
module.exports = new CategoryController();