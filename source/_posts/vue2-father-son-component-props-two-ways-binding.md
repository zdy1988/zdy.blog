---
title: Vue2.x 父子组件Props双向绑定
date: 2017-07-07 16:48:57
tags: 
- vue2
- component
categories:
- 前端技术
---
![vue](/images/vue.jpg)

在一些情况下，我们可能会需要对一个 prop 进行『双向绑定』。<!-- more -->事实上，这正是 Vue 1.x 中的 .sync修饰符所提供的功能。当一个子组件改变了一个 prop 的值时，这个变化也会同步到父组件中所绑定的值。这很方便，但也会导致问题，因为它破坏了『单向数据流』的假设。由于子组件改变 prop 的代码和普通的状态改动代码毫无区别，当光看子组件的代码时，你完全不知道它何时悄悄地改变了父组件的状态。这在 debug 复杂结构的应用时会带来很高的维护成本。

上面所说的正是我们在 2.0 中移除 .sync 的理由。但是在 2.0 发布之后的实际应用中，我们发现 .sync 还是有其适用之处，比如在开发可复用的组件库时。我们需要做的只是让子组件改变父组件状态的代码更容易被区分。

以上摘自[Vue教程文档](https://cn.vuejs.org/v2/guide/components.html#sync-修饰符)，例如我要实现一个简单的Modal，代码如：

``` bash
    <div id="app">
        <input type="button" value="click" @click="visible = !visible" />
        <p>{{visible}}</p>
        <child v-bind:show="visible"></child>
    </div>
    <script>
        Vue.component('child', {
            props: ['show'],
            template: '<div v-show="show"><input type="button"  value="hide" @click="show=false"/></div>'
        });
        var vm = new Vue({
            el: '#app',
            data: {
                visible: false
            }
        });
    </script>
```

以上代码并不能修改外层父组件"visible"的值，并报出警告：

``` bash
    [Vue warn]: Avoid mutating a prop directly since the value will be overwritten whenever the parent component re-renders. Instead, use a data or computed property based on the prop's value. Prop being mutated: "show"
```

官方的Modal示例，代码如：

``` bash
    <div id="app">
        <input type="button" value="click" @click="visible = !visible" />
        <p>{{visible}}</p>
        <child v-bind:show="visible" @close="visible = false"></child>
    </div>
    <script>
        Vue.component('child', {
            props: ['show'],
            template: '<div v-show="show"><input type="button" value="hide" @click="$emit(\'close\')"/></div>'
        });
        var vm = new Vue({
            el: '#app',
            data: {
                visible: false
            }
        });
    </script>
```
	
当然，我们更多的时候是需要值的传递，代码如：

``` bash
    <div id="app">
        <input type="button" value="click" @click="visible = !visible" />
        <p>{{visible}}</p>
        <child v-bind:show="visible" @show-change="val => visible = val"></child>
    </div>
    <script>
        Vue.component('child', {
            props: ['show'],
            template: '<div v-show="show"><input type="button" value="hide" @click="$emit(\'show-change\', !show)"/></div>',
        });
        var vm = new Vue({
            el: '#app',
            data: {
                visible: false
            }
        });
    </script>
```
	
然而，当我们懂得 *v-model* 的原理，可以简化外层调用，代码如：	

``` bash
    <div id="app">
        <input type="button" value="click" @click="visible = !visible" />
        <p>{{visible}}</p>
        <child v-model="visible"></child>
    </div>
    <script>
        Vue.component('child', {
            props: ['value'],
            template: '<div v-show="value"><input type="button" value="hide" @click="$emit(\'input\', !value)"/></div>',
        });
        var vm = new Vue({
            el: '#app',
            data: {
                visible: false
            }
        });
    </script>
```

也许有时会因为“input”事件冲突，还可以利用 *model* 属性为子组建省下一个“input”事件，代码如：

``` bash
    <div id="app">
        <input type="button" value="click" @click="visible = !visible" />
        <p>{{visible}}</p>
        <child v-model="visible"></child>
    </div>
    <script>
        Vue.component('child', {
            props: ['show'],
            model: {
                prop: 'show',
                event: 'show-change'
            },
            template: '<div v-show="show"><input type="button" value="hide" @click="$emit(\'show-change\', !show)"/></div>',
        });
        var vm = new Vue({
            el: '#app',
            data: {
                visible: false
            }
        });
    </script>
```

以上例子，已经解决了大部分问题了，但都只能处理单个值的双向绑定问题，当出现多个值的需要双向绑定问题时，当然还需要一些技巧，Vue 2.3.0+ 重新引入了 .sync 修饰符，但是这次它只是作为一个编译时的语法糖存在。它会被扩展为一个自动更新父组件属性的 v-on 侦听器。

如代码

``` bash
    <child v-bind:show.sync="visible"></child>
```

会被扩展为：

``` bash
    <child v-bind:show.sync="visible" @update:show="val => visible = val"></child>
```

则原代码示例变化为：

``` bash
    <div id="app">
        <input type="button" value="click" @click="visible = !visible" />
        <p>{{visible}}</p>
        <child v-bind:show.sync="visible"></child>
    </div>
    <script>
        Vue.component('child', {
            props: ['show'],
            template: '<div v-show="show"><input type="button" value="hide" @click="$emit(\'update:show\', !show)"/></div>',
        });
        var vm = new Vue({
            el: '#app',
            data: {
                visible: false
            }
        });
    </script>
```

多个值的时，如代码：

``` bash
    <div id="app">
        <input type="button" value="click" @click="visible = !visible" />
        <p>{{visible}}</p>
        <child v-bind:show.sync="visible" v-bind:value.sync="text"></child>
    </div>
    <script>
        Vue.component('child', {
            props: ['show','value'],
            template: '<div v-show="show"><input type="button" :value="value" @click="$emit(\'update:show\', !show)"/><input type="button" value="changeText" @click="$emit(\'update:value\', value + \'^_^\')"/></div>',
        });
        var vm = new Vue({
            el: '#app',
            data: {
                text: 'hide',
                visible: false
            }
        });
    </script>
```
