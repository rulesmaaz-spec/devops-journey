FROM alpine:3.19
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY id.sh /home/appuser/id.sh
RUN chmod +x /home/appuser/id.sh
USER appuser
WORKDIR /home/appuser
CMD ["/home/appuser/id.sh"]