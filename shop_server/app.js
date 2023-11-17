const express = require('express');

const authRouter = require('./routers/auth_route');
const AdminRouter = require('./routers/admin_route');
const ProductRouter = require('./routers/product_route');
const userRouter = require('./routers/user_route');
const CategoryRoute = require('./routers/category_route');


const app = express();

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*'); // Cho phép yêu cầu từ bất kỳ nguồn nào
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, x-auth-token');
    next();
  });

app.use(express.json());

app.use(authRouter);
app.use(AdminRouter);
app.use(ProductRouter);
app.use(userRouter);
app.use(CategoryRoute);

module.exports = app;