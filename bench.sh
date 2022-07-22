DIR=~/StarRocksBenchmark/sql/ssb-flat/
echo "query,concurrency,qps" >> result.csv

for file in $(ls ~/StarRocksBenchmark/sql/ssb-flat/ | grep -v '\.'); do
    sql=$(cat $DIR/$file | grep -v '\-\-' | tr '\n' ' ')

    for c in 1 2 4 8 16 32 64; do
        echo "running $file concurrency=$c $sql"


        result=$(src/sysbench  src/lua/sr_query.lua run --mysql-host=172.26.194.221 \
            --mysql-port=19030 --mysql-user=root --mysql-password="" \
            --mysql-db=ssb_100g --report-interval=1 --time=10 \
            --threads=$c \
            --srquery="$sql" | tee bench.log | grep "eps")
        
        qps=$(echo $result | perl -nle 'print $1 if /(\d+\.\d+)/')
        echo "$file,$c,$qps" | tee -a result.csv
        
        # result=$(mysqlslap --concurrency=$c \
        #     --iterations=1 \
        #     --number-of-queries=500 \
        #     --query="$sql" \
        #     --pre-query="set global pipeline_dop=0; set global enable_pipeline_engine=true; " \
        #     -h172.26.194.221 -P19030 -uroot --create-schema=ssb_100g | grep "Average number of seconds")
        #duration=$(echo $result | perl -nle 'print $1 if /(\d+\.\d+) sec/')
        #echo "duration,$duration"
        #echo "qps,"$(echo 500 / $duration | bc)

    done

done
