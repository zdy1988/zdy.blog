---
title: Vue2.x 按需加载路由
date: 2017-07-30 22:07:51
tags: 
- vue2
- router
- 按需加载
categories:
- 前端技术
---

在 Vue 的开发过程中，有时候会遇到根据不同人的权限加载不同的路由问题，经过一番测试，找到了一个解决方案，举例如：

1.  在 router 文件夹下新建一个 config.json 文件，来作为 router 的数据源

<!-- more -->

``` javascript
[
  {
    "title": "Dashboard",
    "path": "/main/",
    "src": "dashboard",
    "summary": "statistics, charts, recent events and reports",
    "children": []
  },
  {
    "title": "Menu Example",
    "heading": true
  },
  {
    "title": "Multi Level Menu",
    "summary": "",
    "children": [
      {
        "title": "Item 1",
        "summary": "",
        "children": [
          {
            "title": "Item 11",
            "summary": "",
            "path": "/main/1",
            "children": []
          },
          {
            "title": "Item 12",
            "summary": "",
            "path": "/main/1",
            "children": []
          },
          {
            "title": "Item 13",
            "summary": "",
            "path": "/main/1",
            "children": []
          }
        ]
      },
      {
        "title": "Item 2",
        "summary": "",
        "path": "/main/1",
        "children": []
      },
      {
        "title": "Item 3",
        "summary": "",
        "path": "/main/1",
        "children": []
      }
    ]
  }
```

2.  设置 router/index.js ，将 routerConfig 导出时为了动态生成菜单使用

```javascript

import Vue from 'vue'
import VueRouter from 'vue-router'
import routerConfig from './config.json'

Vue.use(VueRouter)

const routers = []

function recursionRouters (routerConfig) {
  for (let item of routerConfig) {
    if (item.src) {
      item.meta = Object.assign({}, item)
      item.component = resolve => require(['@/views/' + item.src], resolve)
      routers.push(item)
    } else if (item.children) {
      recursionRouters(item.children)
    }
  }
}

recursionRouters(routerConfig)

var router = new VueRouter({
  routes: [
    {path: '/', component: resolve => require(['@/views/index'], resolve)},
    {path: '/login', component: resolve => require(['@/views/index'], resolve)},
    {path: '/lock', component: resolve => require(['@/views/lock'], resolve)},
    {
      path: '/main',
      component: resolve => require(['@/views/main'], resolve),
      children: routers
    }
  ]
})

export default router

export {
  routerConfig,
  routers
}

```

3.  编写生成菜单的 component ，递归调用自身形成无限级菜单

```javascript
  Vue.component('page-sidebar-item', {
    template: `<li class="heading" v-if="model.heading">
                   <h3 class="uppercase">{{model.title}}</h3>
               </li>
               <li class="nav-item" v-else>
                  <router-link :to="model.path" class="nav-link" :class="{'nav-toggle':isFolder}" v-if="model.path">
                     <i class="icon-folder"></i>
                     <span class="title">{{model.title}}</span>
                     <span class="arrow" v-if="isFolder"></span>
                  </router-link>
                  <a href="javascript:;" class="nav-link" :class="{'nav-toggle':isFolder}" v-else>
                    <i class="icon-folder"></i>
                    <span class="title">{{model.title}}</span>
                    <span class="arrow" v-if="isFolder"></span>
                  </a>

                  <ul class="sub-menu" v-if="isFolder">
                    <page-sidebar-item v-for="model in model.children" :key="model.title" :model="model"></page-sidebar-item>
                  </ul>
               </li>`,
    props: {
      model: {type: Object}
    },
    computed: {
      isFolder: function () {
        return this.model.children &&
          this.model.children.length
      }
    }
  })
```

4.  调用 component

```javascript
<page-sidebar-item v-for="(sidebarItem, index) in sidebarData" :key="sidebarItem.title" :model="sidebarItem" :class="{'start active': index===0}"></page-sidebar-item>
```


