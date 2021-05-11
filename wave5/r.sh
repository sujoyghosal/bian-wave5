rm s.sh
while read line
do
	grep $line d>>s.sh
done<f
