const express = require('express');
const dotenv = require('dotenv');

if(process.env.NODE_ENV != 'production') dotenv.config({ path: `.env` });
const app = express()
const port = 3000


app.get('/', (req, res) => res.send('Welcome to trigger branch ' + process.env.APP_NAME))

app.listen(port)