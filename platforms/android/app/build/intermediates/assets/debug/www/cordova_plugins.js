cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
  {
    "id": "cordova-plugin-camera.Camera",
    "file": "plugins/cordova-plugin-camera/www/CameraConstants.js",
    "pluginId": "cordova-plugin-camera",
    "clobbers": [
      "Camera"
    ]
  },
  {
    "id": "cordova-plugin-camera.CameraPopoverOptions",
    "file": "plugins/cordova-plugin-camera/www/CameraPopoverOptions.js",
    "pluginId": "cordova-plugin-camera",
    "clobbers": [
      "CameraPopoverOptions"
    ]
  },
  {
    "id": "cordova-plugin-camera.camera",
    "file": "plugins/cordova-plugin-camera/www/Camera.js",
    "pluginId": "cordova-plugin-camera",
    "clobbers": [
      "navigator.camera"
    ]
  },
  {
    "id": "cordova-plugin-camera.CameraPopoverHandle",
    "file": "plugins/cordova-plugin-camera/www/CameraPopoverHandle.js",
    "pluginId": "cordova-plugin-camera",
    "clobbers": [
      "CameraPopoverHandle"
    ]
  },
  {
    "id": "cordova-plugin-backbutton.Backbutton",
    "file": "plugins/cordova-plugin-backbutton/www/Backbutton.js",
    "pluginId": "cordova-plugin-backbutton",
    "clobbers": [
      "navigator.Backbutton"
    ]
  },
  {
    "id": "org.lee.cordova.qrcodeanalysis.qrcodeanalysis",
    "file": "plugins/org.lee.cordova.qrcodeanalysis/www/qrcodeanalysis.js",
    "pluginId": "org.lee.cordova.qrcodeanalysis",
    "clobbers": [
      "cordova.plugins.qrcodeanalysis"
    ]
  },
  {
    "id": "cordova-plugin-splashscreen.SplashScreen",
    "file": "plugins/cordova-plugin-splashscreen/www/splashscreen.js",
    "pluginId": "cordova-plugin-splashscreen",
    "clobbers": [
      "navigator.splashscreen"
    ]
  },
  {
    "id": "cordova-plugin-statusbar.statusbar",
    "file": "plugins/cordova-plugin-statusbar/www/statusbar.js",
    "pluginId": "cordova-plugin-statusbar",
    "clobbers": [
      "window.StatusBar"
    ]
  },
  {
    "id": "im.ltdev.cordova.UserAgent.UserAgent",
    "file": "plugins/im.ltdev.cordova.UserAgent/www/UserAgent.js",
    "pluginId": "im.ltdev.cordova.UserAgent",
    "clobbers": [
      "UserAgent"
    ]
  },
  {
    "id": "cordova-plugin-inappbrowser.inappbrowser",
    "file": "plugins/cordova-plugin-inappbrowser/www/inappbrowser.js",
    "pluginId": "cordova-plugin-inappbrowser",
    "clobbers": [
      "cordova.InAppBrowser.open",
      "window.open"
    ]
  },
  {
    "id": "cordova-plugin-themeablebrowser.themeablebrowser",
    "file": "plugins/cordova-plugin-themeablebrowser/www/themeablebrowser.js",
    "pluginId": "cordova-plugin-themeablebrowser",
    "clobbers": [
      "cordova.ThemeableBrowser"
    ]
  },
  {
    "id": "awsca.awsca",
    "file": "plugins/awsca/www/awsca.js",
    "pluginId": "awsca",
    "clobbers": [
      "cordova.plugins.awsca"
    ]
  }
];
module.exports.metadata = 
// TOP OF METADATA
{
  "cordova-plugin-whitelist": "1.3.4",
  "cordova-plugin-camera": "4.1.0",
  "cordova-plugin-backbutton": "0.3.0",
  "org.lee.cordova.qrcodeanalysis": "1.0.0",
  "cordova-plugin-splashscreen": "5.0.3",
  "cordova-plugin-statusbar": "2.4.3",
  "im.ltdev.cordova.UserAgent": "0.1.0",
  "cordova-plugin-inappbrowser": "3.0.0",
  "cordova-plugin-themeablebrowser": "0.2.17",
  "awsca": "1.0.0"
};
// BOTTOM OF METADATA
});