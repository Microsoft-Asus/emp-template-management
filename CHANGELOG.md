![EMP](https://raw.githubusercontent.com/wiki/RYTong/emp-debugger/images/emp.png)

# Emp Template Management Package Change Log

## 0.2.3
1. 适配 Atom Ver1.2
2. 修改 CBB 面板除全部显示外, 其他配置不显示的问题.

## 0.2.2
1. 添加 CBB Tool Bar 搜索功能
2. 优化 CBB TOOl, 现在给以为 tab 配置为所有模板
3. 适配 Atom Ver1.2


## 0.2.0
1. 添加 Keymaps 管理, 位置为 EMP/Help/Key Bindings.目前只能修改用户安装的 package 中的热键.
2. 重定义 CBB 使用流程,现在CSS 样式使用,统一修改一个文件,有开发人员来控制版本与合并.

## 0.1.34
1. 添加 EMP/Help 菜单, 主要内容为帮助文档
2. 现在会根据 UI Snippet 和 CBB 的内容自动构成 API 文档,可以通过 `EMP/Help` 下的
子菜单来查看.

## 0.1.31
1. 为 template 管理添加查找功能
2. 为 snippets 管理添加查找功能

## 0.1.30
1. 更新页面样式, 使页面内容更加紧凑
2. 添加一个 snippets 主动出发按键.(EMP-> Reload Snippets)
3. 修改了一些 bug.

## 0.1.28
1. 添加设置基础模板路径的功能,现在可以直接指定 ui-lib中的 snippet 使用.

## 0.1.27
1. 添加基础模板导入导出管理功能,现在推荐把基础模板管理放在 ui-lib 中.

## 0.1.25
1. 添加基础模板管理功能

## 0.1.23
1. 修改 bug. 修改模板插入失败的问题.

## 0.1.22
2. 修改模板管理资源文件时重复添加的问题.

## 0.1.21
1. 修改package 的 logo 无法保存问题.

## 0.1.19
1. 重定义插入模板流程, 现在不在插入各控件单独的样式.
   而是在插件启动时为每一个 package 生成公共的 ert_ui_package.css 的公共样式.
   在插入模板时,会自动把该公共样式插入到 resource_dev/common/css 下.
   注意,请不要尝试修改插入后的 css 文件,因为每次模板的插入,
   都会覆盖之前插入的公共样式文件.

2.

## 0.1.16
1. 修改隐藏后不显示的 bug.

## 0.1.15
1. 删除Deprecated API

## 0.1.14
1. 重定义 CBB Tool Bar 配置规则, 现在允许配置多个 Pack/Type.
2. 重定义 CBB Tool Bar 显示样式.

## 0.1.14
1. 模板添加过程中,记住选择的包名称和 类型.
2. 修改 因为返回参数错误造成的编辑报错.

## 0.1.13
1. 添加linux 下的中文字体支持.
2. 修改模板编辑时的报错. #16.
3. 在添加模板过程中, 添加创建新文件的操作. #17.

## 0.1.12
* 修改因变量名引起的 bug.

## 0.1.0 - First Release
* Every feature added
* Every bug fixed
