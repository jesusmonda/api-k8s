const express = require('express');
const dotenv = require('dotenv');
const { MongoClient } = require('mongodb');

if(process.env.NODE_ENV != 'production') dotenv.config({ path: `.env` });
const app = express()
const port = 3000


const client = new MongoClient(`mongodb://mongodb.${process.env.NODE_ENV}.svc.cluster.local:27017/mydb`);

app.get('/', async (req, res) => {
    try {
      await client.connect();
      res.send('Hello world ' + process.env.APP_NAME + client.db("test"))
    } catch (error){
      res.send('Hello world ' + process.env.APP_NAME + error)
    }
})

app.listen(port)