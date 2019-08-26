var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'awsca', 'coolMethod', [arg0]);
};
exports.getPicture = function (arg0, success, error) {
    exec(success, error, 'awsca', 'getPicture', [arg0]);
};
