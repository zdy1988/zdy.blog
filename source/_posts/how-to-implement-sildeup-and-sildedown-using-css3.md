---
title: 用CSS3实现SildeUp和SildeDown的正确姿势
date: 2017-07-17 20:56:21
tags: 
- css3
- silde
categories:
- 前端技术
---

通过使用 JQuery 的滑动动画 sildeDown() 与 slideUp() 方法实现一个 Accordion 效果非常简单。

其功能是以动画的效果调整所选元素的高度，使其呈现一种“滑动”的效果，而元素的其他属性不发生变化；参数 speed 为动画显示的速度，可选项 [callback] 为动画显示完成后，执行的回调函数。

如果使用 CSS3 实现这个效果，需要实现的特点和解决的问题有五个：

>1.  以“滑动”的动画效果动态调整显示区域
>2.  所选的元素不设高度，其高度由子元素的多少自适应
>3.  可在调整显示区域的同时不占位置
>4.  可通过参数调整动画显示速度
>5.  可选项 [callback] 为动画显示完成后，执行的回调函数

确认好了问题，我准备从构建一个 Panel 开始。
<!-- more -->

``` bash
    <html>
        <head>
            <meta charset="utf-8" />
            <title></title>
            <style>
                .panel {
                    margin-bottom: 20px;
                    background-color: #fff;
                    border: 1px solid #ddd;
                }

                .panel-heading {
                    cursor:pointer;
                    color: #333;
                    background-color: #f5f5f5;
                    padding: 10px 15px;
                    border-bottom: 1px solid  #ddd;
                }

                .panel-title {
                    margin-top: 0;
                    margin-bottom: 0;
                    font-size: 16px;
                }

                .panel-body {
                    padding: 15px;
                }
            </style>
        </head>
        <body>
            <div class="panel">
                <div class="panel-heading">
                    <h3 class="panel-title">Panel title</h3>
                </div>
                <div class="panel-body">
                    <p>Panel content</p>
                    <p>Panel content</p>
                    <p>Panel content</p>
                    <p>Panel content</p>
                </div>
            </div>
        </body>
    </html>
    
```

构建好了 Panel 之后，按照 JQuery 的思路，我准备对 Panel 高度进行动态调整，以达到我需要的效果。通过对 CSS3 的学习得知，可通过设置过渡属性 *transition* 来实现动画，于是我编写了 CSS 如：

``` bash
    .panel-heading {
        border-bottom: 0;
    }

    .panel-body {
        padding: 0px;
        height: 0px;
        overflow:hidden;
        transition: height .6s;
        -moz-transition: height .6s;
        -webkit-transition: height .6s;
        -o-transition: height .6s;
    }

    .panel:hover .panel-body {
        padding: 15px;
        height:auto;
    }

    .panel:hover .panel-heading {
        border-bottom: 1px solid  #ddd;
    }
```

相信试过的同学已经知道，这样做并没有效果，显示和隐藏的效果倒是实现了，但并没有动画效果，并且为了完全隐藏 panel-body ，强行设置其 padding 值，简直不是我想要的！

这是我踩的第一个坑，相信那些试图实现这个效果的同学也肯定会踩这个坑。我看过 w3school 中的示例，示例中是动态调整了所选元素的宽度（width），当时我以为 height 值也可以，试过之后发现不行，于是查资料找方法，得知实现 *问题1* 的方法有两种：

>1.  在所选元素外围包裹一个 DIV ，通过设置 DIV 的 max-height: 0px  to  999px
>2.  在所选元素外围包裹一个 DIV ，通过设置 DIV 的 overflow:hidden ，设置所选元素的 transform: translateY(-100%) to translateY(0)

值得注意的是 *方法1* 中设置的 999px 看情况，只要这个最大高度大于所估计的的高度就行，而 *方法2* 虽然可以实现 *问题1* 和 *问题2* ，但却无法实现 *问题3* 。

通过以上的总结，我在 panel-bady 之外包裹了一个 panel-collapse ，实现这个 Panel 的 sildeToggle 。

``` bash
    <html>
        <head>
            <meta charset="utf-8" />
            <title></title>
            <style>
                .panel {
                    margin-bottom: 20px;
                    background-color: #fff;
                    border: 1px solid #ddd;
                }

                .panel-heading {
                    cursor:pointer;
                    color: #333;
                    background-color: #f5f5f5;
                    padding: 10px 15px;
                    border-bottom: 1px solid  #ddd;
                }

                .panel-title {
                    margin-top: 0;
                    margin-bottom: 0;
                    font-size: 16px;
                }

                .panel-body {
                    padding: 15px;
                }

                .panel-heading {
                    border-bottom: 0px;
                }

                .panel-collapse {
                    overflow:hidden;
                    max-height: 0px;
                    transition: max-height .6s;
                    -moz-transition: max-height .6s;
                    -webkit-transition: max-height .6s;
                    -o-transition: max-height .6s;
                }

                .panel:hover .panel-collapse {
                    max-height: 200px;
                }

                .panel:hover .panel-heading {
                    border-bottom: 1px solid  #ddd;
                }
            </style>
        </head>
        <body>
            <div class="panel">
                <div class="panel-heading">
                    <h3 class="panel-title">Panel title</h3>
                </div>
                <div class="panel-collapse">
                    <div class="panel-body">
                        <p>Panel content</p>
                        <p>Panel content</p>
                        <p>Panel content</p>
                        <p>Panel content</p>
                    </div>
                </div>
            </div>
        </body>
    </html>
```

哈哈，这样就已经实现了JQuery 的滑动动画 sildeDown() 与 slideUp() 的效果。多复制几个 Panel 不久实现了 Accordion 效果了吗？

于是我将代码稍作修改，如：

``` bash
    <html>
        <head>
            <meta charset="utf-8" />
            <title></title>
            <style>
                .panel {
                    margin-bottom: 20px;
                    background-color: #fff;
                    border: 1px solid #ddd;
                }

                .panel-heading {
                    cursor:pointer;
                    color: #333;
                    background-color: #f5f5f5;
                    padding: 10px 15px;
                    border-bottom: 1px solid  #ddd;
                }

                .panel-title {
                    margin-top: 0;
                    margin-bottom: 0;
                    font-size: 16px;
                }

                .panel-body {
                    padding: 15px;
                }

                .panel-group {
                    width: 300px;
                    margin: 0 auto;
                }

                    .panel-group .panel {
                        margin:5px;
                    }

                .panel-group .panel-heading {
                    border-bottom: 0;
                }

                    .panel-group .panel-heading + .panel-collapse > .panel-body {
                        border-top: 1px solid #ddd !important;
                    }

                .panel-collapse {
                    max-height: 0px;
                    overflow-y: auto;
                    transition: max-height .6s;
                    -moz-transition: max-height .6s;
                    -webkit-transition: max-height .6s;
                    -o-transition: max-height .6s;
                }

                .panel:hover > .panel-collapse {
                    max-height: 100px;
                }
            </style>
        </head>
        <body>
            <div class="panel-group">
                <div class="panel">
                    <div class="panel-heading">
                        <h3 class="panel-title">Panel title</h3>
                    </div>
                    <div class="panel-collapse">
                        <div class="panel-body">
                            <p>Panel content</p>
                        </div>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-heading">
                        <h3 class="panel-title">Panel title</h3>
                    </div>
                    <div class="panel-collapse">
                        <div class="panel-body">
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                        </div>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-heading">
                        <h3 class="panel-title">Panel title</h3>
                    </div>
                    <div class="panel-collapse">
                        <div class="panel-body">
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    </html>
```

是的，我实现了 Accordion 效果，确切的说只实现了一半，因为以上的动效都是在 Hover 时才可以展开，无法保持持续展开！

我想，既要保持展开，又要保证各个 Panel 的展开效果排他。能实现这个效果的方法也只有 *radio + label* 这个大招了！

主要思路：

>1.  通过用 radio 来区别状态，用 label 来关联 radio 选择
>2.  通过 CSS3 伪类选择器 *element1~element2 选择器* 找到所选元素

终得代码：

``` bash
    <html>
        <head>
            <meta charset="utf-8" />
            <title></title>
            <style>
                .panel {
                    margin-bottom: 20px;
                    background-color: #fff;
                    border: 1px solid #ddd;
                }

                .panel-heading {
                    cursor:pointer;
                    color: #333;
                    background-color: #f5f5f5;
                    padding: 10px 15px;
                    border-bottom: 1px solid  #ddd;
                }

                .panel-title {
                    margin-top: 0;
                    margin-bottom: 0;
                    font-size: 16px;
                }

                .panel-body {
                    padding: 15px;
                }

                .panel-group {
                    width: 300px;
                    margin: 0 auto;
                }

                    .panel-group .panel {
                        margin:5px;
                    }

                .panel-group .panel-heading {
                    border-bottom: 0;
                    display:block;
                }

                    .panel-group .panel-heading + .panel-collapse > .panel-body {
                        border-top: 1px solid #ddd !important;
                    }

                    .panel-group input[type="radio"] {
                        position:absolute;
                        display:none;
                    }

                .panel-collapse {
                    max-height: 0px;
                    overflow-y: auto;
                    transition: max-height .6s;
                    -moz-transition: max-height .6s;
                    -webkit-transition: max-height .6s;
                    -o-transition: max-height .6s;
                }    

                input[type="radio"]:checked ~  .panel-collapse {
                    max-height: 100px;
                }
            </style>
        </head>
        <body>
            <div class="panel-group">
                <div class="panel">
                    <input type="radio" name="panels" id="panel1" checked="checked">
                    <label class="panel-heading" for="panel1">
                        <h3 class="panel-title">Panel title</h3>
                    </label>
                    <div class="panel-collapse">
                        <div class="panel-body">
                            <p>Panel content</p>
                        </div>
                    </div>
                </div>
                <div class="panel">
                    <input type="radio" name="panels" id="panel2">
                    <label class="panel-heading" for="panel2">
                        <h3 class="panel-title">Panel title</h3>
                    </label>
                    <div class="panel-collapse">
                        <div class="panel-body">
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                        </div>
                    </div>
                </div>
                <div class="panel">
                    <input type="radio" name="panels" id="panel3">
                    <label class="panel-heading" for="panel3">
                        <h3 class="panel-title">Panel title</h3>
                    </label>
                    <div class="panel-collapse">
                        <div class="panel-body">
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                            <p>Panel content</p>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    </html>
```

至此，以上的五个问题剩下的两个 *问题4* 和 *问题5* 其实也不是问题了， *问题4* 可以通过设置 transition-duration 实现显示时常，当然还可以通过设置 transition-timing-function 来规定过渡效果的时间曲线。而 *问题5* 既然是需要 [callback] ，当然也只能是需要 javascript 的支持，通过监听所选元素的 transitionend 事件来获得。

``` bash
    var panels = document.getElementsByClassName('panel-collapse')
    for (var i = 0; i < panels.length; i++) {
        panels[i].addEventListener('transitionend', function () {
            console.log(arguments) //通过arguments获取相关元素信息
        })
    }
```

相关资料：
[CSS3 transform 属性](http://www.w3school.com.cn/cssref/pr_transform.asp)
[CSS [attribute~=value] 选择器](http://www.w3school.com.cn/cssref/selector_attribute_value_contain.asp)