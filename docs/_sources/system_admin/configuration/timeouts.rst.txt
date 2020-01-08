As MedCo has a complex architecture with many components interacting with others on long-lived connections, time-outs can be tricky.
todo: put in configuration?

list of timeouts

nginx: ALL_TIMEOUTS_SECONDS
controls:
send_timeout ${ALL_TIMEOUTS_SECONDS}s;
proxy_read_timeout ${ALL_TIMEOUTS_SECONDS}s;
proxy_send_timeout ${ALL_TIMEOUTS_SECONDS}s;
proxy_connect_timeout ${ALL_TIMEOUTS_SECONDS}s;

medco-connector: SERVER_HTTP_WRITE_TIMEOUT_SECONDS / I2B2_WAIT_TIME_SECONDS / UNLYNX_TIMEOUT_SECONDS

picsure: HTTP_CLIENT_TIMEOUT_SECONDS all client calls made from picsure (server???)

client: CLIENT_QUERY_TIMEOUT_SECONDS / CLIENT_GENOMIC_ANNOTATIONS_QUERY_TIMEOUT_SECONDS
