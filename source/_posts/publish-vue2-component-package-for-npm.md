# 安装vue simple手脚架，并初始化项目

针对vue组件的开发，我通常使用webpack作为前段资源的加载/打包工具。为了达到快速开发的目的，vue官方也制作了针对webpack的手脚架，我们只需要对手脚架的稍微改动就能完成开发组件前的准备工作。

```javascript

//安装vue手脚架
npm install -g vue-cli

//使用手脚架初始化一个简单的vue项目
vue init webpack-simple vue-test

//初始化项目
cd vue-test
npm i

//运行查看项目
npm run dev

```

# 创建并开发组件

初始化项目之后，文件目录结构为：

我们将 src 文件夹中文文件移出至根目录，并修改根目录下 webpack.config.js 文件，将 entry: './src/main.js' 改为 entry: './main.js'，这是为了在开发初期方便测试。

之后再 src 文件夹中建立 index.js 文件和 vue-test.vue 组件。

在 vue-test.vue 中编写组件代码后，编辑 index.js，此文件为组件出口。使用时，外部项目导入形式有：

```javascript

//ES6
import VueTest from 'vue-test'

//AMD
var VueTest from require('VueTest')

//直接引用
<script src="./dist/vue-pay-keyboard.js"></script>

```

所以，编写 index.js 为

```javascript

import VueTest from './vue-test.vue'

VueTest.install = function(Vue){
  Vue.component('VueTest', VueTest)
}

// 针对直接引用
if (typeof window !== 'undefined' && window.Vue) {
  window.Vue.use(VueTest);
}

// 针对ES6和AMD导入
export default VueTest

```

# 测试组件

在 app.vue 中测试局部调用

```html
<vue-test></vue-test>
```

```javascript

import VueTest from './src'
export default {
  name: 'app',
  components: {
    VueTest
  }
}

```

在 main.js 中测试全局调用

```javascript

import VueTest from './src'
Vue.use(VueTest)

```

修改 webpack.config.js 部分配置来进行一次打包

```javascript

module.exports = {
  //entry: './main.js',
  entry: './src/index.js', //将项目入口切换到组件
  output: {
    path: path.resolve(__dirname, './dist'),
    publicPath: '/dist/',
    //filename: 'build.js'
    filename: 'vue-test.js' //打包后输出的文件名
    library: 'vue-test',  //使用导入时的模块名
    libraryTarget: 'umd', //libraryTarget会生成不同umd的代码,可以只是commonjs标准的，也可以是指amd标准的，也可以只是通过script标签引入的
    umdNamedDefine: true // 会对 UMD 的构建过程中的 AMD 模块进行命名。否则就使用匿名的 define
  }
}

```

打包完成，在根目录下建立一个静态文件测试直接引用

```html

<script src="node_modules/vue/dist/vue.min.js"></script>
<script src="dist/vue-test.js"></script>


<vue-test></vue-test>

```

# 发布包到 npm 服务器

修改 package.json 文件，修改部分配置

```javascrit

{
  "name": "vue-test", //名称
  "version": "1.0.0", //版本
  "description": "a plugin for vue2", //介绍
  "keywords": [
    "vue2",
    "test"
  ], //关键词
  "author": "zdy1988 <virus_zhh@126.com>", //作者
  "main": "dist/vue-test.js", //插件入口
  "private": false, //是否私有
  "license": "MIT", //使用许可
  "repository": {
    "type": "git",
    "url":""
  } //如果有github仓库地址可以注明
}

```

发布到npm服务器命令

```javascrit
npm whoami
npm publish
```





