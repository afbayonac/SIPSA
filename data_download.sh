#!/bin/bash
PREFIJO="http://www.dane.gov.co/files/investigaciones/agropecuario/sipsa"

function Download() {
  date=$(date -d "$1" '+%Y %m %d')
  IFS=' ' read -r -a array <<< "$date"
  year="${array[0]}"
  mon="${array[1]}"
  day=$(( 10#${array[2]} ))
  mon="${mes[10#$mon]}"
  URL=$(printf $2 "$PREFIJO" "$mon" "$day" "$year")
  # Download
  wget  $URL --output-document="data/${array[0]}${array[1]}${array[2]}.xls" -q --show-progress
}

function Download_2() {
  date=$(date -d "$1" '+%Y %m %d')
  IFS=' ' read -r -a array <<< "$date"
  year="${array[0]}"
  mon="${array[1]}"
  day=$(( 10#${array[2]} ))
  mon="${mes_short[10#$mon]}"
  URL=$(printf $2 "$PREFIJO" "$mon" "$day" "$year")
  # Download
  wget  $URL --output-document="data/${array[0]}${array[1]}${array[2]}.xls" -q --show-progress
}

start=$(date -d 20120611 '+%Y%m%d')
end=$(date +'%Y%m%d' )

mes=(0 enero febrero marzo abril mayo junio \
       julio agosto septiembre octubre noviembre diciembre)

mes_short=(0 ene feb mar abr may jun \
     jul ago sept oct nov dic)

[[ $start != "" && $end != "" ]] || exit 0
[[ $(date -d "$start" +%s) -le $(date -d "$end" +%s) ]] || exit 0

#-------------------------------------------------------------------------------

while [[ $start -ne $end ]]
do
  # Change start
  start=$(date -d "$start +1days" '+%Y%m%d')
  # fines de semana
  name_day=$(date -d "$start"  '+%a')
  [ $name_day == "Sun" -o $name_day == "Sat" ] && continue

  Download $start '%s/mayoristas_%s_%s_%s.xls'
done

#-------------------------------------------------------------------------------

find data/ -type f -empty | grep -o '[0-9]*' > empty

while read date
do
  Download $date '%s/mayoristas_anexo_%s_%s_%s.xls'
done < empty

#-------------------------------------------------------------------------------

find data/ -type f -empty | grep -o '[0-9]*' > empty

while read date
do
  Download_2 $date '%s/mayoristas_anexo_%s_%s_%s.xls'
done < empty

#-------------------------------------------------------------------------------

find data/ -type f -empty | grep -o '[0-9]*' > empty

while read date
do
  Download_2 $date '%s/mayoristas_anexo_%s_0%s_%s.xls'
done < empty

#-------------------------------------------------------------------------------

find data/ -type f -empty | grep -o '[0-9]*' > empty

while read date
do
  Download $date '%s/mayoristas_anexo_%s_0%s_%s.xls'
done < empty

#-------------------------------------------------------------------------------
#NOTE: xlsx files
## find data/ -type f -empty | grep -o '[0-9]*' > empty
##
## while read date
## do
##   Download $date '%s/mayoristas_%s_%s_%s.xlsx'
## done < empty

##-------------------------------------------------------------------------------

find data/ -type f -empty | grep -o '[0-9]*' > empty

while read date
do
  Download $date '%s/mayoristas_%s_0%s_%s.xls'
done < empty

number=$(find data/ -type f -empty | wc -l)
echo $number

rm empty
find  data/ -type f -empty -delete
