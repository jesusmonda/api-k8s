const express = require('express');
const dotenv = require('dotenv');
const { MongoClient } = require('mongodb');

if(process.env.NODE_ENV != 'production') dotenv.config({ path: `.env` });
const app = express()
const port = 3000


const client = new MongoClient("mongodb://mongodb:27017", {
  useUnifiedTopology: true
});

app.get('/', (req, res) => {
    await client.connect();
    res.send('Welcome to trigger branch ' + process.env.APP_NAME + client.db("test"))
})

app.listen(port)