FROM akaunting/akaunting:latest
# Pristine copy to populate an (initially empty) Railway volume at runtime
RUN cp -a /var/www/html /opt/akaunting-src
# Fix "apache2: More than one MPM loaded": keep only prefork
RUN (a2dismod mpm_event 2>/dev/null || true) && (a2dismod mpm_worker 2>/dev/null || true) && (a2enmod mpm_prefork 2>/dev/null || true)
COPY custom-entry.sh /usr/local/bin/custom-entry.sh
RUN chmod +x /usr/local/bin/custom-entry.sh
ENTRYPOINT ["/usr/local/bin/custom-entry.sh"]
CMD ["--start"]
