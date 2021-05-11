/*eslint-env node*/

//------------------------------------------------------------------------------
// node.js starter application for Bluemix
//------------------------------------------------------------------------------

// This application uses express as its web server
// for more info, see: http://expressjs.com
var express = require('express');
var path = require('path');
const writeFile = require('write-file')
const shell = require('shelljs');
var app = express();
var PORT = 9010;
app.use(express.static(__dirname + '/public'));
app.get('/', function(req, resp) {
    var out = "Hey, are you looking for something?";
    out += "  Use /personality?text=<content>";
    resp.jsonp(out);
});
app.get('/process', function(req, res) {
    var config = req.param('config');
    //console.log("Config: " + req.param('config'));
    var data = "sd=" + req.param('sd') + "\n";
    data += "sdpath=" + req.param('sdpath') + "\n";
    data += "crpath=" + req.param('crpath') + "\n";
    data += "crr=" + req.param('crr') + "\n";
    data += "bqs=" + req.param('bqs') + "\n";
    data += "CONFIG\n";
    data += req.param('config') + "\n";
    var cr = req.param('cr');
    var sdName = req.param('sd').replace(/ /g, "");

    writeFile(sdName + "PathConfig", data, function(err) {
        if (err) return console.log(err)
        console.log('file is written')
        setTimeout(writeModel, 1000);
        //res.send("file is written");
    })

    function writeModel() {
        writeFile(sdName + "ModelConfig", cr, function(err) {
            if (err) return console.log(err)
            console.log('file is written');
            setTimeout(processFiles, 1000);
        })
    }

    function processFiles() {
        var command = "./generateSwagger.sh " + sdName;
        shell.exec(command);
        setTimeout(finished, 2000);
    }

    function finished() {
        console.log("Finished Generation");
        var o = shell.cat(sdName + ".yaml");
        console.log(o.stdout);
        shell.cp(sdName + ".yaml", './public/' + sdName + ".yaml");
        //res.send(o.stdout);
        res.redirect('/' + sdName + ".yaml");
    }

});
// start server on the specified port and binding host
app.listen(PORT, '0.0.0.0', function() {
    // print a message when the server starts listening
    console.log("server starting on port " + PORT);
});