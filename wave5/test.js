const shell = require('shelljs');
var o = shell.cat('test.js');
console.log(o.stdout);
