FROM alpine:3.19
COPY flaky.sh /flaky.sh
RUN chmod +x /flaky.sh
HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=2 \
  CMD ps aux | grep -v grep | grep flaky.sh || exit 1
CMD ["/flaky.sh"]
