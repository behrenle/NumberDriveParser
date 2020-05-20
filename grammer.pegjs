Expression
  = Definition

Definition
  = left:(DefFunction / Symbol) _ ":=" _ right:Equation _ {
    return {
      type: "definition",
      elements: [left, right]
    };
  }
  / Equation

Equation
  = _ left:Sum _ "=" _ right:Sum _ {
    return {
      type: "equation",
      elements: [left, right]
    };
  }
  / Sum

Sum
  = first:unsignedSummand following:signedSummand+ {
  	var node = {type: "sum", elements: []};
    node.elements.push(first);
    for (var i = 0; i < following.length; i++) {
      node.elements.push(following[i]);
    }
    return node;
  }
  / following:signedSummand+ {
    var node = {type: "sum", elements: []};
    for (var i = 0; i < following.length; i++) {
      node.elements.push(following[i]);
    }
    return node;
  }
  / Product

signedSummand
  = _ sign:("+" / "-") _ expr:Product _ {
    var nExpr = expr;
    nExpr.sign = sign;
    return nExpr;
  }

unsignedSummand
  = _ expr:Product _ {
    var nExpr = expr;
    nExpr.sign = "+";
    return nExpr;
  }

Product
  = first:factor following:factor+ {
    var node = {type: "product", elements: []};
    node.elements.push(first);
    for (var i = 0; i < following.length; i++) {
      node.elements.push(following[i]);
    }
    return node;
  }
  / Power

factor
  = _ sign:("*" / "/")? _ expr:Power _ {
    var nExpr = expr;
    nExpr.mulSign = sign == "/" ? "/" : "*";
    return nExpr;
  }

Power
  = base:Function _ "^" _ exp:Function _ {
    return {
      type: "power",
      elements: [base, exp],
    };
  }
  / Function

DefFunction
  = _ name:Symbol "(" _ first:Symbol following:DefParam* ")" _ {
    var node = {type: "function", name: name.value, elements: []};
    if (first != null) {
      node.elements.push(first);
    }
    for (var i = 0; i < following.length; i++) {
      node.elements.push(following[i]);
    }
    return node;
  }

DefParam
  = _ "," _ symbol:Symbol _ {return symbol;}

Function
  = _ name:Symbol "(" first:FirstParam following:FollowingParam* ")" _ {
    var node = {type: "function", name: name.value, elements: []};
    if (first != null) {
      node.elements.push(first);
    }
    for (var i = 0; i < following.length; i++) {
      node.elements.push(following[i]);
    }
    return node;
  }
  / List

FirstParam
  = _ expr:Expression _ {return expr;}

FollowingParam
  = _ "," _ expr:Expression _ {return expr;}

List
  = _ "[" first:Expression following:ListFollowingElement* "]" _{
    var node = {type: "list", elements: []};
    if (first != null) {
      node.elements.push(first);
    }
    for (var i = 0; i < following.length; i++) {
      node.elements.push(following[i]);
    }
    return node;
  }
  / _ "[" _ "]" _ {
    return {type: "list", elements: []};
  }
  / Primary

ListFollowingElement
  = _ "," _ expr:Expression _ {return expr;}

Primary
  = "(" _ expr:Expression _ ")" {return expr;}
  / number:Number _ {return number;}
  / symbol:Symbol _ {return symbol;}

Number "integer"
  = _ [0-9]+ ("." [0-9]*)?  {
    return {
      type: "number",
      value: parseFloat(text(), 10)
    };
  }

Symbol
  = symbolChars+ (symbolChars / [0-9] / ".")* {
    return {
      type: "symbol",
      value: text()
    }
  }

symbolChars
= [abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_]

_ "whitespace"
  = [ \t\n\r]*
