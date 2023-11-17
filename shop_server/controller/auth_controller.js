const UserModel = require('../model/user_model');
const bcryptjs = require('bcryptjs');
const { json } = require('express');
const jwt = require('jsonwebtoken');

class AuthController {
  async signup(req, res) {
    try {
      // Lấy email, name, password từ giao diện
      const { name, email, password } = req.body;

      // Kiểm tra email có tồn tại
      const existingUser = await UserModel.findOne({ email });
      if (existingUser) {
        //tra lại ma loi tu phia nguoi dung và thong bao
        return res.status(400).json({ msg: 'User with same email already exists!' });
      }

      // ma hoa mat khau
      const hasspassword = await bcryptjs.hash(password,8);

      // Tạo user và lưu vào database
      const user = new UserModel({
        email,
        password: hasspassword,
        name,
      });
      await user.save();

      // Trả về user đã tạo
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }

  async signin(req, res) {
    try {
      // Lấy email, name, password từ giao diện
      const {  email, password } = req.body;

      // Kiểm tra email có tồn tại
      const user = await UserModel.findOne({ email });
      if (!user) {
        //tra lại ma loi tu phia nguoi dung và thong bao
        return res.status(400).json({ msg: 'User with email does not exists!' });
      }

        // Kiểm tra so sanh password co dung voi database khong
        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
          //tra lại ma loi tu phia nguoi dung và thong bao
          return res.status(400).json({ msg: 'incorect Password' });
        }

        //xac minh jwt de dam bao dung nguoi dung
        const token = jwt.sign({id:user._id},"passwordKey");
        res.json({token,...user._doc})

    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }

  //token
  async token(req, res) {
    try {

      const token = req.header('x-auth-token');

      //kiem tra ma token co duoc thong qua hay la null
      if(!token)  return res.json(false);
      const verified = jwt.verify(token, "passwordKey");
      if (!verified) return res.json(false);
  
      const user = await UserModel.findById(verified.id);
      if (!user) return res.json(false);
      res.json(true);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
}

module.exports = new AuthController();
