BEGIN{
h["00"]="a"
h["01"]="b"
h["02"]="c"
h["03"]="d"
h["04"]="e"
h["05"]="f"
h["06"]="g"
h["07"]="h"
h["08"]="i"
h["09"]="j"
h["10"]="k"
h["11"]="l"
h["12"]="m"
h["13"]="n"
h["14"]="o"
h["15"]="p"
h["16"]="q"
h["17"]="r"
h["18"]="s"
h["19"]="t"
h["20"]="u"
h["21"]="v"
h["22"]="w"
h["23"]="x"
}
{
    printf "%s%s%s%s\n",toupper(substr($1,1,4)),substr($1,9,3),h[substr($1,12,2)],substr($1,14)
}
