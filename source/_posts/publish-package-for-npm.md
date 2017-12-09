# 安装node和npm

[node.js 官网](http://nodejs.cn/).

npm已经包含在node内，安装完成后，通过查看版本检测安装是否成功

```javascript

node -v
npm -v

```

# 创建和发开包

创建包的目录，并完成npm初始化

```javascript

mkdir npm-test
cd npm-test
npm init

```

初始化过程中，npm会提示创建一个配置文件package.json，包括包的命名等等...

在 npm-test 文件夹下创建一个 index.js 文件，编写一个简单的插件

```javascrit

exports.hello = function (name) {
    console.log('hello' + name)
}

```

查看package.json，内容如：

```javascript

{
  "name": "npm-test", //名称，安装插件时，npm服务器会通过此命名查找
  "version": "1.0.0", //版本
  "description": "", //简介
  "main": "index.js", //插件出口
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  }, //执行脚本，例如在控制台执行 npm run test
  "author": "", //作者
  "license": "ISC" //许可证
}

```

# 发布包

完成了以上操作，我们需要一个npm账号来发布包，这个账号会被添加到npm本地配置中，用来后续发布使用。

已有账号的，可以通过命令查询本地认证信息

```javascript

npm whoami

```

没有认证信息，可通过命令登陆

```javascript

npm login

```

没有账号的，可通过命令注册账号

```javascript

npm adduser

```

登陆成功后，发布npm包

```javascript

npm publish

```

发布成功后，获取npm包

```javascript

npm install npm-test

```

使用npm包

```javascript

let a = require('npm-test')
a.hello('npm')

```

更新npm包，修改package.json中的version版本号，继续发布即可

客户端更新已发布的更新包

```javascript

npm update npm-test

```