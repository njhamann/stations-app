cordova.define("org.apache.cordova.plugin.chromecast.chromecast", function(require, exports, module) {window.chromecast = function (str, callback) {
    alert('hello');
    cordova.exec(callback, function (err) {
        callback('Nothing to echo');
    }, 'Chromecast', 'echo', [str]);
};
});
