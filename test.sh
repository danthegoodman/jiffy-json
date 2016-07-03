#!/usr/bin/env bash
source ./fixtures.sh

#    description             expected output        command line arguments
echo "--- Strings ---"
doPass "simple"              '{"a":"hello world"}'  a:'hello world'
doPass "with colons"         '{"a":"a:b:c"}'        a:a:b:c
doPass "empty string"        '{"a":""}'             a:
echo

echo "--- Numbers ---"
doPass "integer"             '{"a":1}'         a:1
doPass "float"               '{"a":3.14}'      a:3.14
doPass "multiple digits"     '{"a":299}'       a:299
doPass "not fully a number"  '{"a":"2xx"}'     a:2xx
doPass "numeric key"         '{"1":"x"}'       1:x
echo

echo "--- Bool ---"
doPass "true"                 '{"a":true}'     a:true
doPass "false"                '{"a":false}'    a:false
doPass "true case sensitive"  '{"a":"True"}'   a:True
doPass "false case sensitive" '{"a":"False"}'  a:False
echo

echo "--- Null ---"
doPass "null"                 '{"a":null}'     a:null
doPass "case sensitive"       '{"a":"Null"}'   a:Null
echo

echo "--- Collection Literals ---"
doPass "empty object"         '{"a":{}}'       a:{}
doPass "empty array"          '{"a":[]}'       a:[]
echo

echo "--- String Cast ---"
doPass "string"          '{"a":"hello"}'        a:hello@S
doPass "integer"         '{"foo":"100"}'        foo:100@S
doPass "boolean"         '{"bar":"true"}'       bar:true@S
doPass "null"            '{"cat":"null"}'       cat:null@S
doPass "empty object"    '{"dog":"{}"}'         dog:{}@S
doPass "empty array"     '{"egg":"[]"}'         egg:[]@S
doPass "different tag"   '{"a":"1@S","b":"2"}'  --string-cast @ a:1@S b:2@
echo

echo "--- Objects ---"
doPass "simple"                   '{"x":"hello world"}'  x:'hello world'
doPass "builder"                  '{"x":"hello world"}'  { x:'hello world' }
doPass "array notation in key"    '{"[foo]":"x"}'        [foo]:x
doPass "array notation in key"    '{"[]":"x"}'           []:x
doPass "empty key"                '{"":"x"}'             :x
doPass "empty key at path end"    '{"a":{"":"x"}}'       a.:x
doPass "empty key in path"        '{"a":{"":{"b":"x"}}}' a..b:x
doPass "empty builder"            '{}'                   { }
echo

echo "--- Array ---"
doPass "indexed"               '[1,"a",true]'        [0]:1 [1]:a [2]:true
doPass "builder"               '[1,"a",true]'        [ 1 a true ]
doPass "indexed unordered"     '[3,1,2]'             [1]:1 [2]:2 [0]:3
doPass "indexed with gaps"     '[null,null,"x"]'     [2]:x
doPass "empty builder"         '[]'                  [ ]
echo

echo "--- Arrays in Arrays --- "
doPass "indexed"              '[[1,2],[3,4],[5,6]]'  [0][1]:2 [0][0]:1 [2][0]:5 [2][1]:6 [1][0]:3 [1][1]:4
doPass "builder"              '[[1,2],[3,4],[5,6]]'  [ [ 1 2 ] [ 3 4 ] [ 5 6 ] ]
doPass "indexed then builder" '[[1,2],[3,4],[5,6]]'  [0][ 1 2 ] [1][ 3 4 ] [2][ 5 6 ]
doPass "builder then indexed" '[[1,2],[3,4],[5,6]]'  [ [0]:1 [1]:2 ] [ [0]:3 [1]:4 ] [ [0]:5 [1]:6] ]
echo

echo "--- Arrays in Objects ---"
doPass "ordered"           '{"a":[3,2,1]}'      a[0]:3  a[1]:2  a[2]:1
doPass "unordered"         '{"a":[3,2,1]}'      a[2]:1  a[1]:2  a[0]:3
doPass "array builder"     '{"a":[3,2,1]}'      a[ 3 2 1 ]
doPass "object builder"    '{"a":[3,2,1]}'      { a[0]:3  a[1]:2  a[2]:1 }
doPass "both builders"     '{"a":[3,2,1]}'      { a[ 3 2 1 ] }
echo

echo "--- Objects in Arrays ---"
doPass "several layers deep"    '[{"a":1,"b":2},[{"c":3},{"d":4}]]'           [0].a:1  [0].b:2  [1][0].c:3 [1][1].d:4
doPass "object builder"         '[{"a":1,"b":2},[{"c":3},{"d":4}]]'           [0]{ a:1 b:2 } [1][0]{ c:3 } [1][1]{ d:4 }
doPass "both builders, full"    '[{"a":1,"b":2},[{"c":3},{"d":4}]]'           [ { a:1 b:2 } [ { c:3 } { d:4 } ] ]
echo

echo "--- Objects in Objects ---"
doPass "several layers deep"    '{"a":{"b1":"x","b2":{"c":2}}}'   a.b1:x a.b2.c:2
doPass "several builders deep"  '{"a":{"b1":"x","b2":{"c":2}}}'   a{ b1:x b2{ c:2 } }
echo

echo "--- No Args ---"
doPass "no args"             '{}'              # literally nothing
echo

echo "--- Escapes ---"
doPass "colon in key"             '{"a:b":"x"}'          'a\:b':x
doPass "dot in key"               '{"a.b":100}'          'a\.b':100
doPass "escape array"             '{"[0]":"x"}'          '\[0]':x
doPass

echo "--- Combining multiple concepts ---"
doPass "Sample 1" \
       '{"a":{"b":[{"c":1,"d":4.3,"e":false},true,"x"],"x":null},"y":["100"],"z":"z"}' \
       a.b[0].c:1  a.b[0].d:4.3  a.b[0].e:false  a.b[1]:true  a.b[2]:x  a.x:null  y[0]:100@S  z:z
doPass "Sample 1 with builders" \
       '{"a":{"b":[{"c":1,"d":4.3,"e":false},true,"x"],"x":null},"y":["100"],"z":"z"}' \
       a{ b[ { c:1  d:4.3  e:false } true x ] x:null } y[ 100@S ]  z:z
echo

#      expected error message                         invalid input
echo "--- Errors ---"
doFail "object builder is unclosed"                   {
doFail "no object builder to close"                   }
doFail "array builder is unclosed"                    [
doFail "no array builder to close"                    ]
doFail "items in an object require a key and value"   a
doFail "items in an object require a key and value"   'a\:b'
doFail "items in an array may not have a key"         [ a:1 ]
doFail "cannot treat array as object"                 a[0]:1  a.x:2
doFail "cannot treat object as array"                 a.x:2  a[0]:1
doFail "array index is already set"                   a[0]:1  a[0]:2
doFail "array index is already set"                   a[ 1 ]  a[0]:2
doFail "object property is already set"               a.b:1  a.b:2
doFail "object property is already set"               a{ b:1 }  a.b:2

echo
report_test_status

