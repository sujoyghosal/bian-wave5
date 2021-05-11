while read sd
do
verbs.sh $sd
cp "$sd".yaml wave5/
done<NameOfServiceDomains
