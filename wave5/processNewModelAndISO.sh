readingRecord="false"
r=""
a=""
name="BaseWithIdAndRoot"
input=$1"ModelConfig"
output="CurrentAccountModel.yaml"
isofile="CurrentAccountISOConfig"
idArray=()
echo "definitions:">$output
lastRead=""
space=""
l3=""
context=""
crr=""
while read line
do
    if  [[ $line == BQ* ]] || [[ $line == CR* ]] ;
    then
        crr=`echo $line|cut -f1 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        echo " $crr:" >>$output
        echo "  type: object" >>$output
        crbq=`echo $line|cut -f2 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        echo "Processing $crbq..."
        continue;
    fi
    if  [[ $line == Properties* ]] || [[ $line == Options* ]] || [[ $line == Variables* ]];
    then
        context=`echo $line|cut -f1 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        context=`echo $context | tr '[:upper:]' '[:lower:]'`
        echo "  $context:" >>$output
        continue;
    fi
    a=`echo $line|cut -f3 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
    a2=`echo $line|cut -f4 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
    a3=`echo $line|cut -f5 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
    a4=`echo $line|cut -f6 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
    s=`echo $line|cut -f1 -d"|"|cut -f1 -d"("`
    if  [[ ! -z "$a" ]]
    then
        lastRead=$a;
        space=""
    fi
    ## check for child object
    if  [[ ! -z "$a" ]] && [[ "$a2" == "#" ]] ;
    then
        echo "   $lastRead:">>$output
        space=" $space"
        continue
    fi

    if  [[ -z "$a" ]] && [[ ! -z "$a2" ]] && [[ "$a3" != "#" ]];
    then
        a=$a2
    fi
    if  [[ -z "$a" ]] && [[ ! -z "$a2" ]] && [[ "$a3" == "#" ]];
    then
        echo "    $a2:">>$output
        space=" $space"
        continue
    fi

    if  [[ -z "$a" ]] && [[ -z "$a2" ]] && [[ ! -z "$a3" ]] && [[ "$a3" != "#" ]];
    then
        a=$a3
    fi
    
    element=$a
    a="$(tr '[:upper:]' '[:lower:]' <<< ${a:0:1})${a:1}"
    echo "$a"
    info=`echo $line|cut -f7 -d"|"`
    z=`echo $a | tr '[:upper:]' '[:lower:]'`
    echo "$space   $a:"|tee -a $output>>/dev/null
    case $z in
        *record)
            echo "$space    type: object"|tee -a $output>>/dev/null
            ;;
        *report)
            echo "$space    type: object"|tee -a $output>>/dev/null
            ;;
        *)
            echo "$space    type: string"|tee -a $output>>/dev/null
            ;;
    esac
    case $z in
        *amount|*charge|*fee)
            echo "$space    example: USD 250"|tee -a $output>>/dev/null
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Amount"
            ;;
        *currency)
            echo "$space    example: USD"|tee -a $output>>/dev/null
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Currency"
            ;;
        *date|*datetime|*time)
            echo "$space    example: \"09-22-2018\""|tee -a $output>>/dev/null
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime"
            ;;
        *reference)
            i=1
            count=`echo $s|wc -w`
            g=
            while [ $i -le $count ]
            do
                w=`echo $s|cut -f"$i" -d" "|cut -b1`
                i=`expr $i + 1`
                g=$g$w
            done
            g=`echo $g|tr '[:lower:]' '[:upper:]'`
            foundInArray="false"
            for m in "${idArray[@]}"
            do
                if [[ $m =~ $g ]];
                then
                    e=$m
                    foundInArray="true"
                    break
                fi
            done
            if [ $foundInArray == "false" ]
            then
                # whatever you want to do when arr doesn't contain value
                    ra=`jot -r 1 700000 799990`
                    e=$g$ra
                    idArray+=($e)
            fi
            echo "$space    example: \"$e\""|tee -a $output>>/dev/null
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::ISO20022andUNCEFACT::Identifier"
            ;;
        *perioid)
            echo "$space    example: \"09-22-2018\" - \"09-29-2018\""|tee -a $output>>/dev/null
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration"
            ;;
        *interval)
            echo "$space    example: monthly"|tee -a $output>>/dev/null
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration"
            ;;
        *reporttype)
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Code"
            ;;
        *record|*report)
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary"
            ;;
        *)
            defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Text"
            ;;
    esac
    echo "$space    description: |"|tee -a $output>>/dev/null
    #element=`echo $line|cut -f2 -d"-"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        if [ -f "$isofile" ]
        then
            cat $isofile|sed -e $'s/\t/|/g'>p
            cat p|cut -f1 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'>bq
            cat p|cut -f2 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'>el
            paste -d"|" bq el>bqel
            cat p|cut -f3,4 -d"|">rest
            paste -d"|" bqel rest>q
            cat q|grep -i "$crbq|$element">isobq
            inisofile="false"
            coredatatype="false"
            while read isorec
            do
                if [ ! -z "$isorec" -a "$isorec" != " " ]; then
                    inisofile="true"
                    status=`echo "$isorec" | cut -f4 -d"|"`
                    s1=`echo $status|grep -i "ISO 20022 Business Model"`
                    s2=`echo $status|grep -i "https://www.iso20022.org"`
                    s3=`echo $status|grep -i "Core Data Type"`
                    if [ ! -z "$s1" -a "$s1" != " " ]; then
                        bref=`echo "$isorec" | cut -f3 -d"|"`
                        echo "$space     \`status: Provisionally Registered\`"|tee -a $output>>/dev/null
                        echo "$space      bian-reference: $bref"|tee -a $output>>/dev/null
                    fi
                    if [ ! -z "$s2" -a "$s2" != " " ]; then
                        bref=`echo "$isorec" | cut -f3 -d"|"`
                        href=`echo "$isorec" | cut -f4 -d"|"`
                        echo "$space     \`status: Registered\`"|tee -a $output>>/dev/null
                        echo "$space      iso-link: $href"|tee -a $output>>/dev/null
                        echo "$space      bian-reference: $bref"|tee -a $output>>/dev/null
                    fi
                    if [ ! -z "$s3" -a "$s3" != " " ]; then
                        coredatatype="true"
                    fi
                else
                    inisofile="false"
                fi
            done<isobq
        else
            inisofile="false"
        fi
        if [ $inisofile == "false" ] || [ $coredatatype == "true" ]
        then
            echo "$space     \`status: Not Mapped\`"|tee -a $output>>/dev/null
            echo "$space      $defaultdatatype"|tee -a $output>>/dev/null
        fi
    echo "$space      general-info: $info"|tee -a $output>>/dev/null

done <CurrentAccountModelConfig