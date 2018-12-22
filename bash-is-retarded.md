# Variables
### Defining variable
```
varname=value 
varname='value with spaces'
varname="value with spaces"
```

### Using variable
```
echo $varname                             # --> "value"
echo prefix $varname suffix               # --> "prefix value suffix"
echo prefixnospace$varname suffix         #--> "prefixnospacevalue suffix"
echo prefixnospace${varname}suffixnospace # --> "prefixnospacevaluesuffixnospace"
```
# Comparisons
While multiple syntaxes may work (or not work) in various forms (terminal v.s. shell script), and there is a difference between comparing strings and integers, some things don't seem to work at all, e.g.:
- `$> [ "$a"=="value" ]`   <-- doesn't return true or false
- `$> result=[ "$a"=="value" ]`  <-- tries to execute the value of $a as a command, for some reason

`if [ "$a" = "value" ]; (...)` will work in the terminal, bot not in a shell script, for some reason. So use:
`if [ "$a"=="value" ]; (...)` <-- notice the spaces, they are, somehow, very important. The crack baby that created bash loves spaces, don't offend him.

# Exit status
You can use `$> echo $?` to get the exit status of the previous command. Note that `$> $?` will not work. 
