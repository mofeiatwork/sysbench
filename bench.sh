DIR=~/StarRocksBenchmark/sql/ssb-flat/
truncate -s 0 result.csv
echo "query,concurrency,qps" >> result.csv

for file in $(ls ~/StarRocksBenchmark/sql/ssb-flat/ | grep -v '\.'); do
    sql=$(cat $DIR/$file | grep -v '\-\-' | tr '\n' ' ')

    # warmup 
    result=$(src/sysbench  src/lua/sr_query.lua run --mysql-host=172.26.194.221 \
        --mysql-port=19030 --mysql-user=root --mysql-password="" \
        --mysql-db=ssb_100g --report-interval=1 --time=5 \
        --threads=1 \
        --srquery="$sql" | tee bench.log | grep "eps")

    for c in 1 2 4 8 16 32 64; do
        echo "running $file concurrency=$c"


        result=$(src/sysbench  src/lua/sr_query.lua run --mysql-host=172.26.194.221 \
            --mysql-port=19030 --mysql-user=root --mysql-password="" \
            --mysql-db=ssb_100g --report-interval=1 --time=10 \
            --threads=$c \
            --srquery="$sql" | tee bench.log | grep "eps")
        
        qps=$(echo $result | perl -nle 'print $1 if /(\d+\.\d+)/')
        echo "$file,$c,$qps" | tee -a result.csv
        
    done

done
