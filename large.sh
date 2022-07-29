# Small query
# small_sql="select count(*) from web_returns"
# src/sysbench  src/lua/sr_query.lua run --mysql-host=172.26.195.76 \
    # --mysql-port=9030 --mysql-user=root --mysql-password="" \
    # --mysql-db=tpcds_10t --report-interval=1 --time=100 \
    # --threads=4 \
    # --srquery="select count(*) from web_returns"
    
## Large query
large_sql="(select ss_item_sk from store_sales order by ss_item_sk,ss_list_price,ss_ext_sales_price limit 10) union (select cs_item_sk from catalog_sales order by cs_item_sk, cs_list_price, cs_ext_list_price limit 10)"
# large_sql=`cat /home/disk5/mofei/StarRocksBenchmark/sql/tpcds/query01 | grep -v '\-\-'`
src/sysbench  src/lua/sr_query.lua run --mysql-host=172.26.195.76 \
    --mysql-port=9030 --mysql-user=rg_small --mysql-password="123456" \
    --mysql-db=tpcds_10t --report-interval=5 --time=100 \
    --threads=2 \
    --srquery="$large_sql"
