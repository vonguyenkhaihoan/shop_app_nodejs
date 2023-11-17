const app = require('./app');
const db = require('./config/db'); 
const UserModel = require('./model/user_model');
const ProductModel = require("./model/product_model");




const port = 3000;


app.get('/',(req,res)=>{
    res.send("hello work!! test1");
})

app.listen(port,() => {
    console.log(`Server Listening on Port http://localhost:${port}`);
});

