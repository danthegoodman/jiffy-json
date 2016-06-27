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
doPass "explicitly string"    '{"a":"null"}'   'a(s)':null
echo

echo "--- Collection Literals ---"
doPass "empty object"         '{"a":{}}'       a:{}
doPass "empty array"          '{"a":[]}'       a:[]
echo

echo "--- Explicit String ---"
doPass "string"          '{"a":"hello"}'       'a(s)':hello
doPass "integer"         '{"foo":"100"}'       'foo(s)':100
doPass "boolean"         '{"bar":"true"}'      'bar(s)':true
doPass "null"            '{"cat":"null"}'      'cat(s)':null
doPass "empty object"    '{"dog":"{}"}'        'dog(s)':null


echo "--- Objects ---"
doPass "colon in key"             '{"a:b":"x"}'          'a\:b':x
doPass "dot in key"               '{"a.b":100}'          'a\.b':100
doPass "array notation in key"    '{"[foo]":"x"}'        [foo]:x
doPass "bracket without escaping" '{"[0]":"x"}'          '\[0]':x
doPass "(s) in key"               '{"x(s)":100}'         'x\(s)':100
doPass "empty key"                '{"":"x"}'             :x
doPass "empty key at path end"    '{"a":{"":"x"}}'       a.:x
doPass "empty key in path"        '{"a":{"":{"b":"x"}}}' a..b:x
echo

echo "--- Array ---"
doPass "push syntax"           '[1,2,3]'          []:1  []:2  []:3
doPass "indexed"               '[1,2,3]'          [0]:1 [1]:2 [2]:3
doPass "indexed unordered"     '[3,1,2]'          [1]:1 [2]:2 [0]:3
doPass "indexed with gaps"     '[null,null,"x"]'  [2]:x
doPass "mix push and indexed"  '[null,2,1,3]'     [1]:2 []:1  []:3
echo

echo "--- Arrays in Arrays --- "
doPass "push syntax"   '[[1,2],[3,4],[5,6]]'  [0][]:1  [0][]:2  [1][]:3  [1][]:4  [2][]:5  [2][]:6
doPass "indexed"       '[[1,2],[3,4],[5,6]]'  [0][1]:2 [0][0]:1 [2][0]:5 [2][1]:6 [1][0]:3 [1][1]:4
echo

echo "--- Arrays in Objects ---"
doPass "push syntax"     '{"a":[1,2,3]}'      a[]:1   a[]:2   a[]:3
doPass "indexed"         '{"a":[3,2,1]}'      a[2]:1  a[1]:2  a[0]:3
echo

echo "--- Objects in Arrays ---"
doPass "several layers deep"    '[{"a":1},[{"b":"x"}]]'           [0].a:1  [1][0].b:x
echo

echo "--- Objects in Objects ---"
doPass "several layers deep"    '{"a":{"b1":"x","b2":{"c":2}}}'   a.b1:x a.b2.c:2
echo

echo "--- No Args ---"
doPass "no args"             '{}'              # literally nothing
echo

echo "--- Combining multiple concepts ---"
doPass "Sample 1" \
       '{"a":{"b":[{"c":1,"d":4.3,"e":false},true,"x"],"x":null},"y":["100"],"z":"z"}' \
       a.b[0].c:1  a.b[0].d:4.3  a.b[0].e:false  a.b[1]:true  a.b[2]:x  a.x:null  'y[](s):100'  z:z
echo

#      expected error message                         invalid input
echo "--- Errors ---"
doFail "unable to parse argument"                     a
doFail "cannot treat array as object"                 a[]:1  a.x:2
doFail "cannot treat object as array"                 a.x:2  a[]:1
doFail "push syntax can only be used at end of path"  a[].b:1
doFail "array index is already set"                   a[0]:1  a[0]:2
doFail "object property is already set"               a.b:1  a.b:2

echo
report_test_status

