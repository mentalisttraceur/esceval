escapeEval()
{
 until [ $# = 0 ]
 do
  printf "'"
  printf %s "$1" | sed "s/'/'\\\\''/g"
  printf "' "
  shift
 done
}
