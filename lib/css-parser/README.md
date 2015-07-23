css-parser
==========

```javascript
var css = require('lib/css-parser');

var cssText = ".transfer_info_tbl{left:10px;width: 310px;}";
var cssAST = css.parse(cssText);
// modify cssAST here
var cssText2 = css.stringify(cssAST);
```
