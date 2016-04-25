express = require 'express'
Primus = require 'primus'
cons = require('consolidate')
robot = require('robotjs')

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
        #console.log "got data: #{JSON.stringify(data)}"
        if data.type == 'deviceOrientationSignal'
            screenSize = robot.getScreenSize()
            n = 180
            a = ((data.data.alpha % n) + n) % n
            b = ((data.data.beta % n) + n) % n
            x = screenSize.width * a / n
            y = screenSize.height * b / n
            #console.log(x,y)
            robot.moveMouse(x, y)

primus.on 'disconnection', (spark) ->
    console.log 'connection disconnected'
    spark.write 'bye connection'

server.listen 3000, ->
    console.log 'started server'
