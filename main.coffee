express = require 'express'
Primus = require 'primus'
cons = require('consolidate')

app = express()
app.set('view engine', 'ect')
app.engine('ect', cons.ect)
app.set('views', "#{process.cwd()}/web/view")

server = require('http').createServer(app)

app.use '/home', (req, res, next) ->
    res.render 'index'
app.use '/public', express.static('public')

primus = new Primus(server, {})
primus.on 'connection', (spark) ->
    console.log 'connection start'
    spark.write 'hello connection'
    spark.on 'data', (data) ->
        console.log "got data: #{data}"

primus.on 'disconnection', (spark) ->
    console.log 'connection disconnected'
    spark.write 'bye connection'

server.listen 3000, ->
    console.log 'started server'
