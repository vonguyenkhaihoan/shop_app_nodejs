const app = require('./app');
const db = require('./config/db'); 
const UserModel = require('./models/user_model');


const port = 3000;


app.get('/',(req,res)=>{
    res.send("hello work!! test1");
})

app.listen(port,() => {
    console.log(`Server Listening on Port http://localhost:${port}`);
});
