cat $1|sed -e $'s/\t/|/g'>pp
sd=`cat pp|cut -f2 -d"|"|head -2|tail -1`
desc=`cat pp|cut -f2 -d"|"|head -3|tail -1`
example=`cat pp|cut -f2 -d"|"|head -4|tail -1`
execSum=`cat pp|cut -f2 -d"|"|head -5|tail -1`
cr=`cat pp|cut -f2 -d"|"|head -10|tail -1`
sd=`cat pp|cut -f2 -d"|"|head -2|tail -1`
cat pp|cut -f5-13 -d"|">crios
