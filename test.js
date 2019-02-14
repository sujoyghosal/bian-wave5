const shell = require('shelljs');
//shell.exec('./processCR.sh');
var o = shell.cat('test.js');
console.log(o.stdout);
