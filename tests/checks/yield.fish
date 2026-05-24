#RUN: %fish %s

# Single value
set -l result (yield hello)
count $result
# CHECK: 1
string escape -- $result
# CHECK: hello

# Multiple values stay as separate elements
set -l result (yield a b c)
count $result
# CHECK: 3
string escape -- $result
# CHECK: a
# CHECK: b
# CHECK: c

# Preserves spaces within elements
set -l result (yield "hello world" "foo bar")
count $result
# CHECK: 2
string escape -- $result
# CHECK: 'hello world'
# CHECK: 'foo bar'

# Empty strings are preserved
set -l result (yield "" "" "")
count $result
# CHECK: 3
string escape -- $result
# CHECK: ''
# CHECK: ''
# CHECK: ''

# Values containing newlines stay as single elements
set -l result (yield "line1
line2" "x
y
z")
count $result
# CHECK: 2
string escape -- $result
# CHECK: line1\nline2
# CHECK: x\ny\nz

# Glob-like values are not expanded
set -l result (yield '*' '?' '[abc]')
count $result
# CHECK: 3
string escape -- $result
# CHECK: '*'
# CHECK: ?
# CHECK: '[abc]'

# Flag-like values pass through
set -l result (yield --foo -bar --help -h)
count $result
# CHECK: 4
string escape -- $result
# CHECK: --foo
# CHECK: -bar
# CHECK: --help
# CHECK: -h

# Double-dash alone passes through
set -l result (yield --)
count $result
# CHECK: 1
string escape -- $result
# CHECK: --

# No arguments: no output, status 0
set -l result (yield)
count $result
# CHECK: 0
yield
echo $status
# CHECK: 0

# Resets status after a failed command
false
echo before (yield) $status
# CHECK: before 0

# Accumulate from a loop
set -l items alpha beta gamma
set -l out
for item in $items
    set -a out (yield prefix-$item)
end
count $out
# CHECK: 3
string escape -- $out
# CHECK: prefix-alpha
# CHECK: prefix-beta
# CHECK: prefix-gamma
