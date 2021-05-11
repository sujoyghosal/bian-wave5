rm -rf q splitfilesw12
mkdir splitfilesw12
sd=""
out="/dev/null"
cat AllSDsW12|sed -e $'s/\t/|/g' -e $'s/"//g'>p
while read line
do
if [ "$line" == "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||" ]
then
    read line
    if [ "$line" == "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||" ]
    then
        echo "Found Double lines"
        echo "EOS|">>q
    fi
fi
echo $line>>q
done<p
#exit
while read line
do
a=`echo $line|cut -f1 -d"|"`
if [[ "$a" == "EOS" ]];
then
    read line
    read line
    sd=`echo $line|cut -f1 -d"|"`
    echo $sd
    out=`echo $sd|sed 's/[ (/-]//g'`".txt"
    out="splitfilesw12/$out"
    cr=`echo $line|cut -f10 -d"|"|cut -f2 -d"-"`
    echo $cr
    bq1=`echo $line|cut -f19 -d"|"|cut -f2 -d"-"|sed 's/[ (/-]//g'`
    bq2=`echo $line|cut -f28 -d"|"|cut -f2 -d"-"|sed 's/[ (/-]//g'`
    bq3=`echo $line|cut -f37 -d"|"|cut -f2 -d"-"|sed 's/[ (/-]//g'`
    bq4=`echo $line|cut -f46 -d"|"|cut -f2 -d"-"|sed 's/[ (/-]//g'`
    bq5=`echo $line|cut -f55 -d"|"|cut -f2 -d"-"|sed 's/[ (/-]//g'`
    bq6=`echo $line|cut -f64 -d"|"|cut -f2 -d"-"|sed 's/[ (/-]//g'`
    bq7=`echo $line|cut -f73 -d"|"|cut -f2 -d"-"|sed 's/[ (/-]//g'`
    echo "In	Up	Co	Ec	Ca	Ex	Rq	Gr	Re">$out
    echo "|SD=$sd">>$out
    echo "|CR=$cr">>$out
    echo "|BQs=$bq1 $bq2 $bq3 $bq4 $bq5 $bq6 $bq7">>$out
    echo $line>>$out
    continue
fi
echo $line>>$out
done<q