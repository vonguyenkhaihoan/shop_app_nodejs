const router = require("express").Router();
const AuthController = require("../controller/auth_controller");
const AuthMidd = require("../middlewares/auth_middle");
const UserModle = require("../model/user_model");


router.post('/api/signup', AuthController.signup);
router.post('/api/signin', AuthController.signin);
router.post('/api/tokenIsValid', AuthController.token);

//get user data
router.get('/', AuthMidd, async (req, res) => {
    const user = await UserModle.findById(req.user);
    res.json({ ...user._doc, token: req.token });
  });




module.exports = router;