var path = require('path');
var parse = require('./lib/parser').parse;


module.exports.parse = parse;
module.exports.stringify = function(ast, indent) {
  if (!indent) {
    indent = '  ';
  }
  var outs = ast.rules.map(function(node) {
    return stringify(node, indent);
  });

  return outs.join('\n');
}

function stringify(node, indent) {
  var selector = stringify_selector(node.selectors);
  var declarations = stringify_declaration(node.declarations, indent);
  var out = "";

  out += selector + " {\n";
  out += declarations + "\n";
  out += "}";

  return out;
}

function stringify_selector(selectors) {
  var qualifiers = selectors[0].qualifiers;

  var out = qualifiers.map(function(q) {
    var qs = _qualifier[q.type];
    if (typeof qs != 'function') throw('[ERROR] No qualifier stringifier found for ' + q.type);
    return qs(q);
  });

  return out.join('');
}

function stringify_declaration(declarations, indent) {
  var out = declarations.map(function(d) {
    var ds = _declaration[d.type];
    if (typeof ds != 'function') throw('[ERROR] No declaration stringifier found for ' + d.type);
    return ds.call({indent:indent}, d);
  });

  return out.join('\n');
}


var _qualifier = {
  "ClassSelector": function(q) {
    return "." + q.class;
  },
  "PseudoSelector": function(q) {
    return ":" + q.value;
  }
};

var _declaration = {
  "Declaration": function(d) {
    var vs = _value[d.value.type];
    if (typeof vs != 'function') throw('[ERROR] No value stringifier found for ' + d.value.type);
    return this.indent + d.name + ": " + vs(d.value) + ";";
  }
}

var _value = {
  "Hexcolor": function(v) {
    return v.value;
  },
  "URI": function(v) {
    return "url(" + v.value + ")";
  },
  "Ident": function(v) {
    return v.value;
  },
  "Quantity": function(v) {
    var out = v.value.toString();

    if (v.unit) {
      out += v.unit;
    }

    return out;
  },
  "Progid": function(v) {
    var out = "progid(";
    var first = true;

    for (var p in v.value) {
      if (!first) {
        out += ", ";
      } else {
        first = false;
      }
      out += p + "='" + v.value[p] + "'";
    }
    out += ")";

    return out;
  },
  "Expression": function(v) {
    var out = [];
    if (v.right) {
      out.unshift(stringify(v.right));
      out.unshift(arguments.callee(v.left));
    } else {
      out.unshift(stringify(v));
    }

    return out.join(' ');

    function stringify(v) {
      vs = _value[v.type];
      if (typeof vs != 'function') throw('[ERROR] No value stringifier found for ' + v.type);
      return vs(v);
    }
  }
}
