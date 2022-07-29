# Small query
small_sql="select count(*) from web_returns"
src/sysbench  src/lua/sr_query.lua run --mysql-host=172.26.195.76 \
    --mysql-port=9030 --mysql-user=rg_large --mysql-password="123456" \
    --mysql-db=tpcds_10t --report-interval=2 --time=100 \
    --threads=4 \
    --srquery="select count(*) from web_returns"
    