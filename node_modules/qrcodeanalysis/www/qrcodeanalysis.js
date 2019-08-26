var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'qrcodeanalysis', 'coolMethod', [arg0]);
};
exports.scan = function (arg0, success, error) {
    exec(success, error, 'qrcodeanalysis', 'scan', [arg0]);
};
