# 基础控件控件列表

## 注意事项
文档中所列基础控件使用5.3版本客户端调试，代码片段中包含slt代码以及ios7适配效果代码，在使用此基础控件时请注意此点。
另外需要注意一点为，调试此基础控件列表时客户端将控件间默认间距为0。

## 最简单基础控件

### select

__说明__
普通select控件。
默认样式为：宽320，高50，背景颜色#147EEC；

__关键字__
`e_select`

__代码片段__
```
<select class="ert_select">
    <option>我是下拉框</option>
    <option>我是下拉框</option>
    <option>我是下拉框</option>
</select>
```

### input_text

__说明__  
普通输入框。
默认样式为：宽320，高50，背景颜色#147EEC,输入字体颜色为白色，字号为16号。
弹出普通键盘

__关键字__
`e_text`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="text" name="some_name" value="" hold="请输入" border="0"/>
```

### input_text_n

__说明__  
实数输入框。
默认样式为：宽320，高50，背景颜色#147EEC,输入字体颜色为白色，字号为16号。
弹出实数键盘。

__关键字__
`e_text_n`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="text" name="some_name" style="-wap-input-format:'n'" value="" hold="请输入" border="0"/>
```

### input_text_N

__说明__  
整数输入框。
默认样式为：宽320，高50，背景颜色#147EEC,输入字体颜色为白色，字号为16号。
弹出整数键盘。

__关键字__
`e_text_N`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="text" name="some_name" style="-wap-input-format:'N'" value="" hold="请输入" border="0"/>
```

### input_text_phone

__说明__  
电话号码输入框。
默认样式为：宽320，高50，背景颜色#147EEC,输入字体颜色为白色，字号为16号，控制输入11位。
弹出电话键盘。

__关键字__
`e_text_phone`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="text" name="some_name" style="-wap-input-format:'phone'" value="" hold="请输入" maxleng="11" minleng="11" border="0" />
```

### input_text_date

__说明__  
日期输入框，显示：2015-07-15,上传：20150715
默认样式为：宽320，高50，背景颜色#147EEC,输入字体颜色为白色，字号为16号。
弹出日期键盘。

__关键字__
e_text_date

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="text" name="date" value="" hold="请输入" border="0" style="-wap-input-format:'date'" showFormat="yyyy-MM-dd" valueFormat="yyyyMMdd" />
```

### input_password

__说明__  
普通密码输入框，
默认样式为：宽320，高50，背景颜色#147EEC,输入字体颜色为白色，字号为16号。
弹出普通键盘。

__关键字__
`e_password`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="password" name="some_name" value="" hold="请输入密码" border="0"/>
```

### input_password_N

__说明__  
数字密码输入框,控制输入为6位。
默认样式为：宽320，高50，背景颜色#147EEC,输入字体颜色为白色，字号为16号。
弹出整数键盘。

__关键字__
`e_password_N`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="password" name="some_name" style="-wap-input-format:'N'" value="" hold="请输入密码" border="0" maxleng="6" minleng="6"/>
```

### btn_block_red

__说明__  
红色按钮块。
默认样式为：宽320，高50，背景颜色#FF00FF,显示字体颜色为白色，字号为16号

__关键字__
`e_btn_b_red`

__代码片段__
```
<input class="ert_w320_h50_red_f16w" type="button" name="some_name" value="我是按钮块" />
```

### btn_block_green

__说明__  
绿色按钮块。
默认样式为：宽320，高50，背景颜色#00FF00,显示字体颜色为白色，字号为16号

__关键字__
`e_btn_b_green`

__代码片段__
```
<input class="ert_w320_h50_green_f16w" type="button" name="some_name" value="我是按钮块" />
```

### btn_block_white

__说明__  
白色按钮块。
默认样式为：宽320，高50，背景颜色#FFFFFF,显示字体颜色为黑色，字号为16号

__关键字__
`e_btn_b_white`

__代码片段__
```
<input class="ert_w320_h50_white_f16b" type="button" name="some_name" value="我是按钮块" />
```
### btn_block_blue

__说明__  
蓝色按钮块。
默认样式为：宽320，高50，背景颜色#147EEC,显示字体颜色为白色，字号为16号

__关键字__
`e_btn_b_blue`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="button" name="some_name" value="我是按钮块" />
```

### btn_block_grew

__说明__  
灰色按钮块。
默认样式为：宽320，高50，背景颜色#C0C0C0,显示字体颜色为黑色，字号为16号

__关键字__
`e_btn_b_grew`

__代码片段__
```
<input class="ert_w320_h50_grew_f16b" type="button" name="some_name" value="我是按钮块" />
```

### radio

__说明__  
普通radio。
默认样式为：宽320，高50，背景颜色#147EEC,显示字体颜色为白色，字号为16号

__关键字__
`e_radio`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="radio" name="radio" value="1">radio1</input>
<input class="ert_w320_h50_blue_f16w" type="radio" name="radio" value="2">radio2</input>
```

### checkbox

__说明__  
普通checkbox。
默认样式为：宽320，高50，背景颜色#147EEC,显示字体颜色为白色，字号为16号

__关键字__
`e_checkbox`

__代码片段__
```
<input class="ert_w320_h50_blue_f16w" type="checkbox" name="checkbox" value="1">checkbox1</input>
<input class="ert_w320_h50_blue_f16w" type="checkbox" name="checkbox" value="2">checkbox2</input>
```

### segment

__说明__  
普通segment。
默认样式为：宽320，高50，背景颜色#147EEC,显示字体颜色为白色，字号为16号

__关键字__
`e_segment`

__代码片段__
```
<input  class="ert_w320_h50_blue_f16w" type="segment" name="segment1"  value="seg1">search</input>
<input type="segment" name="segment1"  value="seg2">find</input>
<input type="segment" name="segment1"  value="seg3">look</input>
```

### switch

__说明__  
普通switch。
默认样式为：宽320，高50，背景颜色#147EEC,显示字体颜色为白色，字号为16号

__关键字__
`e_switch`

__代码片段__
```
<input type="switch" name="switch1">yes</input>
<input type="switch" name="switch1" checked="checked">no</input>
```
### link

__说明__  
普通链接。
默认样式为：显示字体颜色为黑色，字号为16号

__关键字__
`e_link`

__代码片段__
```
<a class="ert_w320_h50_white_f16b" href="http://www.w3school.com.cn">W3School</a>
```

## 常见组合控件

### header

定义一些常用标题类型.

### header-1

__说明__

标题左边为图片和文字,中间为标题,右面为按钮，背景为蓝色,
有IOS7导航栏适配代码，如果为IOS7导航栏适配则自动加上一个20px的div。

__关键字__
`e_header1`

__图例__

![](./img/header1.png)

__代码片段__

```
#{local bar_flag = window:supportStatusBarInXML();}#
<!--Title-->
<div class="ert_position" align="center" valign="middle" border="0">
    #{if bar_flag then}#
    <div class="ert_w320_h20_blue" border = "0"></div>
    #{end}#
    <div class="ert_w320_h50_blue_f16w" align="center" valign="middle" border="0">
        <div class="ert_w50_h45_l10" border="0" valign="middle" >
            <img src="btn_back.png" class="ert_w8_h14"></img>
            <div class="ert_div_w10" border="0"></div>
            <input class="ert_f14w" type="button" value="返回" onclick="back_fun()"/>
        </div>
        <label class="ert_f18w">我的理财</label>
        <input class="ert_f14w_r10" type="button" value="首页" onclick="main_page()"/>
    </div>
</div>
```
## checkbox

### checkbox-1

__说明__

checkbox 选择记住手机号

__关键字__
`e_checkbox1`

__图例__

![](./img/checkbox1.png)

__代码片段__

```
<input class="ert_ckbox_w310_l10" type="checkbox" checked="checked">记住手机号码</input>
```

### checkbox-2

__说明__

多个checkbox的选择,图标左对齐.

__关键字__
`e_checkbox2`

__图例__

![](./img/checkbox2.png)

__代码片段__  

```
<div class="ert_w320_w" border="0">
  <input type="checkbox" class="ert_ckbox_w310_l10">checkbox</input>
  <label class="ert_rline_w310"></label>
  <input type="checkbox" class="ert_ckbox_w310_l10">checkbox</input>
</div>
```

### checkbox-3

__说明__

多个checkbox的选择,图标右对齐.

__关键字__
`e_checkbox3`

__图例__

![](./img/checkbox3.png)

__代码片段__  

```
<div class="ert_w320_w" border="0">
    <div class="ert_h30_l10" border="0" valign="middle">
      <label class="ert_f16g">checkbox</label>
      <input type="checkbox" class="ert_r10"></input>
    </div>
    <label class="ert_rline_w310"></label>
    <div class="ert_h30_l10" border="0" valign="middle">
        <label class="ert_f16g">checkbox</label>
        <input type="checkbox" class="ert_r10"></input>
    </div>
</div>
```

## radio

### radio-1

__说明__

常见radio,图标左对齐

__关键字__
`e_radio1`

__图例__

![](./img/radio1.png)

__代码片段__  

```
<div class="ert_w320_w" border="0">
  <input type="radio" class="ert_radio_w310_l10">Radio</input>
  <label class="ert_rline_w310"></label>
  <input type="radio" class="ert_radio_w310_l10">Radio</input>
</div>
```

### radio-2

__说明__

常见radio,图标右对齐

__关键字__
`e_radio2`

__图例__

![](./img/radio2.png)

__代码片段__  

```
<div class="ert_w320_w" border="0">
    <div class="ert_h30_l10" border="0" valign="middle">
      <label class="ert_f16g">Radio</label>
      <input type="radio" class="ert_r10"></input>
      </div>
    <label class="ert_rline_w310"></label>
    <div class="ert_h30_l10" border="0" valign="middle">
      <label class="ert_f16g">Radio</label>
      <input type="radio" class="ert_r10"></input>
    </div>
</div>
```

## switch

### switch-1

__说明__

常见switch开关-选中为黄色

__关键字__
`e_switch1`

__图例__

![](./img/switch1.png)

__代码片段__

```
<input type="switch" name="switch1" class="ert_switch_w60" onTintColor="#FAA105" checked="checked" >yes</input>
<input type="switch" name="switch1" >no</input>
```

### switch-2

__说明__

常见switch开关-正常switch

__关键字__
`e_switch2`

__图例__

![](./img/switch2.png)

__代码片段__  
```
<input type="switch" name="switch2" class="ert_switch_w60" onTintColor="#147EEC" checked="checked"></input>
<input type="switch" name="switch2" ></input>
```

## select

### select-1

__说明__

常见带下拉箭头的select控件.

__关键字__
`e_select1`

__图例__

![](./img/select1.png)

__代码片段__  
```
<div class="ert_div_select" valign="middle" align="center" border="0">
      <select class="ert_select_w260">
        <option class="ert_option" >622226790365742151(工资卡)</option>
        <option class="ert_option" >622226790365776109(工资卡)</option>
        <option class="ert_option" >622226092470367081(账户)</option>
      </select>
      <div class="ert_w20_inline" valign="middle" align="center" border="0" >
        <img name="select_img" src="down_1.png" class="ert_w12_h8"></img>
      </div>
      <label class="ert_rline_w320_b0"></label>
</div>
```

## button

### div-button

__说明__

常用div作为button块.

__关键字__
`e_div_button`

__图例__

![](./img/div_btn1.png)

__代码片段__  
```
<div class="ert_w320_h50" align="center" valign="middle" border="0" onclick="onclick_add()">
    <img src="add_bank.png" class="ert_w15_h15"></img>
    <div border="0" class="ert_div_w10"></div>
    <label class="ert_f16g">添加常用收款人</label>
</div>
```
### button-1

__说明__

常见两个并排button.

__关键字__
`e_double_button_1`

__图例__

![](./img/double_btn1.png)

__代码片段__  
```
<div class="ert_w320_h50" border="0" align="center" valign="middle">
    <input type="button" class="ert_btn_red_w100" border="0" value="确定" onclick="()"/>
    <label class="ert_vline_h40_g"></label>
    <input type="button" class="ert_btn_red_w100" border="0" value="确定" onclick="()"/>
</div>
```


### button-2

__说明__

常见两个和一起button.

__关键字__
`e_double_button_2`

__图例__

![](./img/double_btn2.png)

__代码片段__  
```
<div border="0" class="ert_w320_h50" align="center" valign="middle">
    <input type="button" class="ert_btn_red_w100" value="下一步" border="0"/>
    <div class="ert_div_w30" border="0"></div>
    <input type="button" class="ert_btn_red_w100" value="下一步" border="0"/>
</div>
```
### button-3

__说明__

常见三个并排button.

__关键字__
`e_three_button`

__图例__

![](./img/three_btn.png)

__代码片段__  
```
<div class="ert_w320_h50" border="0" align="center" valign="middle">
  <input type="button" class="ert_btn_red_w100" border="0" value="确定" onclick="()"/>
  <div class="ert_div_w10" border="0"></div>
  <input type="button" class="ert_btn_red_w100" border="0" value="确定" onclick="()"/>
  <div class="ert_div_w10" border="0"></div>
  <input type="button" class="ert_btn_red_w100" border="0" value="确定" onclick="()"/>
</div>
```

### button-4

__说明__

常见四个并排button.

__关键字__
`e_four_button`

__图例__

![](./img/four_btn.png)

__代码片段__  
```
<div class="ert_w320_h50" border="0">
  <input type="button" class="ert_btn_red_w79" border="0" value="确定" onclick="()"/>
  <label class="ert_vline_h40_g"></label>
  <input type="button" class="ert_btn_red_w79" border="0" value="确定" onclick="()"/>
  <label class="ert_vline_h40_g"></label>
  <input type="button" class="ert_btn_red_w79" border="0" value="确定" onclick="()"/>
  <label class="ert_vline_h40_g"></label>
  <input type="button" class="ert_btn_red_w79" border="0" value="确定" onclick="()"/>
</div>
```

## menu

### menu-1

__说明__

常见菜单类型1.

__关键字__
`e_menu_1`

__图例__

![](./img/div_menu.png)

__代码片段__  
```
<div class="ert_menu_div_row" border="0" valign="middle">
    <label class="ert_rline_w320_t0"></label>
    <img class="ert_menu_img_l20" src="poc_finance.png"></img>
    <label class="ert_f16b_l70">国债计算器</label>
    <img class="ert_menu_img_r15" src="right_arrow.png"></img>
    <label class="ert_rline_w320_b0"></label>
</div>
```

### menu-2


__说明__

常见菜单类型2.

__关键字__
`e_menu_2`

__图例__

![](./img/menu_table1.png)

__代码片段__  
```
<div border="0" name="ert_menu_div">
    <div class="ert_menu_div_row" border="0" valign="middle">
        <img class="ert_menu_img_l20" src="poc_finance.png"></img>
        <div border="0" class="ert_menu_div_w250" align="left" valign="middle">
          <label class="ert_f16b">汇率换算</label> <br/>
          <label class="ert_f14g">出国从此乐无忧</label>
          <label class="ert_rline_w250"></label>
        </div>
    </div>
    <div class="ert_menu_div_row" border="0" valign="middle">
        <img class="ert_menu_img_l20" src="poc_finance.png"></img>
        <div border="0" class="ert_menu_div_w250" align="left" valign="middle">
          <label class="ert_f16b">存款计算</label> <br/>
          <label class="ert_f14g">精打细算就靠你</label>
          <label class="ert_rline_w250"></label>
        </div>
    </div>
    <div class="ert_menu_div_row" border="0" valign="middle">
        <img class="ert_menu_img_l20" src="company_cash.png"></img>
        <div border="0" class="ert_menu_div_w250" align="left" valign="middle">
          <label class="ert_f16b">房贷计算</label> <br/>
          <label class="ert_f14g">购房计划更合理</label>
          <label class="ert_rline_w250"></label>
        </div>
    </div>
</div>
```

### menu-3

__说明__

常见菜单类型3.

__关键字__
`e_menu_3`

__图例__

![](./img/menu_table2.png)

__代码片段__  
```
<div border="0" name="ert_menu_div">
    <div class="ert_menu_div_row" border="0" valign="middle">
        <div class="ert_menu_div_l20"  align="left" valign="middle" border="0">
            <img class="ert_w40_h40" src="btn_contact.png"></img>
            <div class="ert_div_badge_red" align="center" valign="middle">
                <label>3</label>
            </div>
        </div>
        <div border="0" class="ert_menu_div_w250" align="left" valign="middle">
            <label class="ert_f16b">服务窗推荐</label> <br/>
            <label class="ert_f14g">招财宝,北京联通,交通银行微银行</label>
        </div>
        <label class="ert_rline_w320_b0"></label>
    </div>
    <div class="ert_menu_div_row" border="0" valign="middle">
        <div class="ert_menu_div_l20"  align="left" valign="middle" border="0">
            <img class="ert_w40_h40" src="btn_credit.png"></img>
            <div class="ert_div_badge_red" align="center" valign="middle">
                <label>1</label>
            </div>
        </div>
        <div border="0" class="ert_menu_div_w250" align="left" valign="middle">
          <label class="ert_f16b">支付宝服务中心</label> <br/>
          <label class="ert_f14g">给新支付宝用户的一份安全报告</label>
        </div>
        <label class="ert_rline_w320_b0"></label>
    </div>
</div>
```

### menu-4

__说明__

常见菜单类型4.

__关键字__
`e_menu_4`

__图例__

![](./img/menu_table3.png)

__代码片段__  
```
<div border="0" name="ert_menu_div">
    <div class="ert_menu_div_row" border="0" valign="middle">
        <img src="contact.png" class="ert_menu_img_l20"></img>
        <label class="ert_f16b_l70">淘宝电影</label>
        <img src="right_arrow.png" class="ert_menu_img_r15"></img>
        <label class="ert_rline_w250"></label>
    </div>
    <div class="ert_menu_div_row" border="0" valign="middle">
        <img src="finance_wait.png" class="ert_menu_img_l20"></img>
        <label class="ert_f16b_l70">快抢</label>
        <div class="ert_div_w10" border="0"></div>
        <img src="foreign_exc.png" class="ert_w15_h15"></img>
        <label class="ert_f14g_r30">吃货折扣券疯抢</label>
        <img src="right_arrow.png" class="ert_menu_img_r15"></img>
        <label class="ert_rline_w250"></label>
    </div>
    <div class="ert_menu_div_row" border="0" valign="middle">
        <img src="flight.png" class="ert_menu_img_l20"></img>
        <label class="ert_f16b_l70">快的打车</label>
        <img src="right_arrow.png" class="ert_menu_img_r15"></img>
        <label class="ert_rline_w250"></label>
    </div>
</div>
```

### menu-5

__说明__

常见菜单类型5.

__关键字__
`e_menu_5`

__图例__

![](./img/menu_table4.png)

__代码片段__  
```
<div border="0" name="ert_menu_div">
    <div class="ert_menu_div_row" border="0" valign="middle">
        <img class="ert_menu_img_l20" src="mobile_pay.png"></img>
        <div border="0" class="ert_menu_div_w230" align="left" valign="middle">
              <label class="ert_f16b">话费充值</label> <br/>
              <label class="ert_f14g">充100享97折，每天1000名</label>
        </div>
        <img src="right_arrow.png" class="ert_menu_img_r15"></img>
        <label class="ert_rline_w300"></label>
    </div>
    <div class="ert_menu_div_row" border="0" valign="middle">
        <img class="ert_menu_img_l20" src="mobile_pay.png"></img>
        <div border="0" class="ert_menu_div_w230" align="left" valign="middle">
          <label class="ert_f16b">游戏充值</label> <br/>
          <label class="ert_f14g">游戏礼包2折起，百款优惠等您抢</label>
        </div>
        <img src="right_arrow.png" class="ert_menu_img_r15"></img>
        <label class="ert_rline_w300"></label>
    </div>
</div>
```

## div

### div-1

__说明__

常见div由左右文本组成.

__关键字__
`e_div_label_label`

__图例__

![](./img/div_label_label.png)

__代码片段__  
```
<div class="ert_w320_h50_w"  valign="middle" border="0">
  <label class="ert_f16g_l10">账号</label>
  <label class="ert_f16b_r10">工资卡 1234 5678 9008 0934 894</label>
</div>
```

### div-2

__说明__

常见div由文本和图片组成,背景为蓝色.

__关键字__
`e_div_label_img_blue`

__图例__

![](./img/div_img_label_img_blue.png)

__代码片段__  
```
<div class="ert_w320_h50_b8_blue" border="1" valign="middle">
  <img src="transfer_fail_1.png" class="ert_w26_h26_l20" />
  <div class="ert_div_w10" border="0"></div>
  <label class="ert_f16w">提示信息等说明解释提醒</label>
  <img src="transfer_fail_1.png" class="ert_w26_h26_r20" />
</div>
```

### div-3

__说明__

常见div由文本和图片组成,背景为红色.

__关键字__
`e_div_label_img_red`

__图例__

![](./img/div_img_label_img_red.png)

__代码片段__  
```
<div class="ert_w320_h50_b8_red" border="1" valign="middle">
    <img src="transfer_fail_1.png" class="ert_w26_h26_l20" />
    <div class="ert_div_w10" border="0"></div>
    <label class="ert_f16w">网络连接错误提示信息</label>
    <img src="transfer_fail_1.png" class="ert_w26_h26_r20" />
</div>
```

### div-4

__说明__

常见div由文本和图片组成,背景为绿色.

__关键字__
`e_div_label_img_green`

__图例__

![](./img/div_img_label_img_green.png)

__代码片段__  
```
<div class="ert_w320_h50_b8_gre" border="1" valign="middle">
    <img src="transfer_success.png" class="ert_w26_h26_l20" />
    <div class="ert_div_w10" border="0"></div>
    <label class="ert_f16w">成功提示信息</label>
    <img src="transfer_fail_1.png" class="ert_w26_h26_r20" />
</div>
```

### div-5

__说明__

常见div由文本和图片组成,背景为黄色.

__关键字__
`e_div_label_img_green`

__图例__

![](./img/div_img_label_img_yellow.png)

__代码片段__  
```
<div class="ert_w320_h50_b8_y" border="1" valign="middle">
    <img src="transfer_fail_1.png" class="ert_w26_h26_l20" />
    <div class="ert_div_w10" border="0"></div>
    <label class="ert_f16w">警告</label>
    <img src="transfer_fail_1.png" class="ert_w26_h26_r20" />
</div>
```

### div-6

__说明__

常见div由文本和多个图片组成.

__关键字__
`e_div_label_img_img`

__图例__

![](./img/div_img_label_img.png)

__代码片段__  
```
<div class="ert_w320_h50_w" border="0" valign="middle">
  <img src="gs.png" class="ert_w20_h20_l10" />
  <div class="ert_div_w10" border="0"></div>
  <div class="ert_div_w80_h50_in" border="0" align="left" valign="middle">
      <label class="ert_f14g">工商银行</label><br/>
      <label class="ert_f14g">尾号：8809</label>
  </div>
  <div class="ert_div_w50" border="0"></div>
  <div class="ert_div_w80_h50_in" border="0" align="left" valign="middle">
      <i class="ert_f12gre">小额</i>
      <i class="ert_w20_h12_red">支付</i>
  </div>
  <img src="right_arrow.png" class="ert_w20_h20_r10" />
</div>
```

### div-7

__说明__

常见div由文本，输入框，图片组成.

__关键字__
`e_div_label_input_img`

__图例__

![](./img/div_label_input_img.png)

__代码片段__  
```
<div class="ert_w320_h50" border="0" valign="middle">
  <label class="ert_f16b_l10">转入金额</label>
  <div class="ert_div_w10" border="0"></div>
  <input type="text" class="ert_w200_h40_f14r" style="-wap-input-format'n'"  border="0" hold="请输入转入金额" value="2000"/>
  <img src="right_arrow.png" class="ert_w8_h14_r10" />
</div>
```

### div-8

__说明__

常见div由文本和输入框组成.

__关键字__
`e_div_label_input`

__图例__

![](./img/div_label_input.png)

__代码片段__  
```
<div class="ert_w320_h50" border="0" valign="middle">
  <label class="ert_f16b_l10">转账金额</label>
  <div class="ert_div_w10" border="0"></div>
  <input type="text" class="ert_w200_h40_f14g" style="-wap-input-format'n'"  border="0" hold="请输入转账金额"/>
</div>
```

## tr

### tr-1

__说明__

常见tr由图片，文本，图片组成.

__关键字__
`e_tr_img_label_img`

__图例__

![](./img/td_img_label_img.png)

__代码片段__  
```
<tr class="ert_h50" valign="middle">
  <td class="ert_w40" align="center">
    <img class="ert_w20_h20" src="contact.png"/>
  </td>
  <td class="ert_w240" align="left">
    <label class="ert_f16b">动产品01动产品01动产品01</label><br/>
    <label class="ert_f16b">（H12390）</label>
  </td>
  <td class="ert_w40" align="center">
      <img class="ert_w20_h20" src="contact.png"/>
  </td>
</tr>
```

### tr-2

__说明__

常见tr由文本，文本组成.

__关键字__
`e_tr_label_label`

__图例__

![](./img/td_label_label.png)

__代码片段__  
```
<tr class="ert_h50">
  <td >
    <label class="ert_f16b_w80_left">转出卡号</label>
    <label class="ert_f14g_w220_right">2345 3456 4567 5435</label>
  </td>
</tr>
<tr class="ert_h50" >
  <td >
    <label class="ert_f16b_w160_left">人民币境内可用余额</label>
    <label class="ert_f14r_w140_right">￥1，000.00</label>
  </td>
</tr>
<tr class="ert_h50" >
  <td>
    <label class="ert_f16b_w160_left">人民币境外可用余额</label>
    <label class="ert_f14g_w140_right">￥1，000.00</label>
  </td>
</tr>
```

### tr-3

__说明__

常见tr由文本，输入框组成.

__关键字__
`e_tr_label_input`

__图例__

![](./img/td_label_input.png)

__代码片段__  
```
<tr class="ert_h50" valign="middle">
    <td class="ert_w80" align="left">
        <label class="ert_f16b">收款人姓名</label>
    </td>
    <td class="ert_w230" align="right">
        <div class="ert_w220_r10" border="0" align="right">
            <input class="ert_w180_f14g" type="text" hold="收款人姓名" border="0" value="" />
            <img class="ert_w20_h20" src="contact.png"/>
        </div>
    </td>
</tr>
<tr class="ert_h50" valign="middle">
    <td class="ert_w80" align="left">
        <label class="ert_f16b">收款账户</label>
    </td>
    <td  class="ert_w230" align="right">
        <div class="ert_w220_r10" border="0" align="right">
            <input class="ert_w180_f14g" type="text" hold="卡号/手机号/企业帐号" border="0"/>
            <img class="ert_w20_h20" src="camera.png" />
        </div>
    </td>
</tr>
```

## footer

### footer-1

__说明__

常见四个按钮并排底部.

__关键字__
`e_footer_1`

__图例__

![](./img/footer1.png)

__代码片段__  
```
<div class="ert_footer_div" valign="middle" border="0">
   <div class="ert_div_w80_h50_in" align="center" border="0">
             <img src="home.png" class="ert_w30_h30"></img><br/>
             <label class="ert_f14g">首页</label>
   </div>
        <div class="ert_div_w80_h50_in" align="center" border="0">
            <img src="life.png" class="ert_w30_h30"></img><br/>
            <label class="ert_f14g">生活</label>
        </div>
        <div class="ert_div_w80_h50_in" align="center" border="0">
            <img src="banking.png" class="ert_w30_h30"></img><br/>
            <label class="ert_f14g">金融</label>
        </div>
        <div class="ert_div_w80_h50_in" align="center" border="0">
            <img src="me.png" class="ert_w30_h30"></img><br/>
            <label class="ert_f14g">我</label>
        </div>
</div>
```


### footer-2

__说明__

常见四个按钮并排底部并有角标提示.

__关键字__
`e_footer_2`

__图例__

![](./img/footer2.png)

__代码片段__  
```
<div class="ert_footer_div" valign="middle" border="0">
    <div class="ert_div_w80_h50_in" align="center" border="0" >
         <img src="home.png" class="ert_w30_h30"></img><br/>
         <label name="footer_label" class="ert_f14g">支付宝</label>
    </div>
    <div class="ert_div_w80_h50_in" align="center" border="0" >
        <img src="life.png" class="ert_w30_h30"></img>
        <div class="ert_div_badge_w20" valign="middle" align="center" border="1">
            <label class="ert_f10ww">2</label>
        </div>
        <label class="ert_f14g">服务窗</label>
    </div>
    <div class="ert_div_w80_h50_in" align="center" border="0" >
        <img src="banking.png" class="ert_w30_h30"></img>
        <div class="ert_div_badge_w20" valign="middle" align="center" border="1">
            <label class="ert_f10ww">惠</label>
        </div>
        <label name="footer_label" class="ert_f14g">探索</label>
    </div>
    <div class="ert_div_w80_h50_in" align="center" border="0" >
        <img src="me.png" class="ert_w30_h30"></img><br/>
        <label class="ert_f14g">财富</label>
    </div>
</div>
```
