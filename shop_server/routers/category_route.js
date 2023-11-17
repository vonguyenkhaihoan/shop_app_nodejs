const router = require("express").Router();
const AdminMidd = require("../middlewares/admin_middle");
const CategoryController = require("../controller/category_controller");
const CategoryModel =require('../model/catyerogy_model.js');



router.get('/api/categories', CategoryController.getAllCategories);

router.post('/create-categories', AdminMidd,CategoryController.createCategory);

// router.put('/update-categories/:id', CategoryController.updateCategory);

router.delete('/delete-categories/:id', CategoryController.deleteCategory);

// Route để cập nhật danh mục theo ID
router.put('/api/update-categories/:id', async (req, res) => {
    try {
        const categoryId = req.params.id;
        const { name, description } = req.body;

        // Kiểm tra xem danh mục có tồn tại không
        const existingCategory = await CategoryModel.findById(categoryId);

        if (!existingCategory) {
            return res.status(404).json({ message: 'Category not found' });
        }

        // Cập nhật thông tin danh mục
        existingCategory.name = name || existingCategory.name;
        existingCategory.description = description || existingCategory.description;

        // Lưu lại vào cơ sở dữ liệu
        const updatedCategory = await existingCategory.save();

        res.status(200).json(updatedCategory);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
