FROM akaunting/akaunting:latest
# Keep a pristine copy of the app so we can populate an (initially empty) Railway volume
RUN cp -a /var/www/html /opt/akaunting-src
COPY custom-entry.sh /usr/local/bin/custom-entry.sh
RUN chmod +x /usr/local/bin/custom-entry.sh
ENTRYPOINT ["/usr/local/bin/custom-entry.sh"]
CMD ["--start"]
