cordova.define("aws-camera-album.aws-camera-album", function(require, exports, module) {
var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'aws-camera-album', 'coolMethod', [arg0]);
};

exports.getPicture = function (arg0, success, error) {
    exec(success, error, 'awsca', 'getPicture', [arg0]);
};

exports.remark = function (arg0, success, error) {
    exec(success, error, 'awsca', 'remark', [arg0]);
};

});
