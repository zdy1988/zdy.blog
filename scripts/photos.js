'use strict';

// register `hexo photos` command
hexo.extend.console.register('photos', 'Generate your photos page', function (args) {
    var fs = require("fs");
    var path = require("path");
    var photosDir = "./source/photos/";
    fs.readdir(photosDir, function (err, files) {
        if (err) {
            console.log(err);
            return;
        }
        var json = [];
        (function iterator(index) {
            if (index == files.length) {
                fs.writeFile("./source/photos/data.json", JSON.stringify(json, null, "\t"));
                console.log('get img success!');
                return;
            }
            var fileName = files[index];
            var realFilePath = path.join(photosDir, fileName);
            fs.stat(realFilePath, function (err, stats) {
                if (err) {
                    return;
                }
                if (stats.isFile()) {
                    if (getExtension(fileName) !== 'json') {
                        var photos = [];
                        photos.push({ name: fileName, path: realFilePath });
                        json.push({ name: fileName, cover: realFilePath, ctime: stats.ctime, photos: photos })
                    }
                } else if (stats.isDirectory()) {
                    var files2 = fs.readdirSync(realFilePath);
                    if (files2.length > 0) {
                        var photos = [];
                        for (var i = 0; i < files2.length; i++)
                        {
                            photos.push({ name: fileName, path: path.join(realFilePath, files2[i]) });
                        }
                        json.push({ name: fileName, cover: path.join(realFilePath, files2[0]), ctime: stats.ctime, photos: photos })
                    }
                }
                iterator(index + 1);
            })
        }(0));
    });
});

//获取后缀名
function getExtension(url) {
    var arr = url.split('.');
    var len = arr.length;
    return arr[len - 1];
}