# Small query
small_sql="select count(*) from web_returns"
src/sysbench  src/lua/sr_query.lua run --mysql-host=172.26.195.76 \
    --mysql-port=9030 --mysql-user=root --mysql-password="" \
    --mysql-db=tpcds_10t --report-interval=1 --time=100 \
    --threads=4 \
    --srquery="select count(*) from web_returns"
    
## Large query
large_sql=`cat /home/disk5/mofei/StarRocksBenchmark/sql/tpcds/query01 | grep -v '\-\-'`
src/sysbench  src/lua/sr_query.lua run --mysql-host=172.26.195.76 \
    --mysql-port=9030 --mysql-user=root --mysql-password="" \
    --mysql-db=tpcds_10t --report-interval=5 --time=100 \
    --threads=1 \
    --srquery="$large_sql"
