window.cast = {
    startPlaylist: function(){
        cordova.exec(callback, function (err) {
            callback('Nothing to echo');
        }, 'Chromecast', 'play', {device_id: 'ssdfd'});
    },
    changePlaylist: function(){},
    play: function(){
        cordova.exec(callback, function (err) {
            callback('Nothing to echo');
        }, 'Chromecast', 'play', {device_id: 'ssdfd'});
    },
    pause: function(){
    },
    next: function(){
    },
    previous: function(){
    },
    goTo: function(index){
    },
    volume: function(){
    },
    scrub: function(){
    },
    echo: function (str, callback) {
        cordova.exec(callback, function (err) {
            callback('Nothing to echo');
        }, 'Chromecast', 'echo', [str]);
    }
};
