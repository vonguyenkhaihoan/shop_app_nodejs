const jwt = require('jsonwebtoken');

const auth = async(req, res, next) => {
    try{
        const token = req.header("x-auth-token");
        // kiem tra token
        if (!token)
          return res.status(401).json({ msg: "No auth token, access denied" });
        
        //xac minh thong bao
        //lay mat khau tu the token
        const verified = jwt.verify(token, "passwordKey");
        if (!verified)
          return res
            .status(401)
            .json({ msg: "Token verification failed, authorization denied." });

        //luu tru 
        req.user = verified.id;
        req.token = token;
        next();
    } catch(err) {
        res.status(500).json({error: err.message});

    }
}

module.exports = auth;