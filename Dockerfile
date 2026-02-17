FROM alpine:latest
 
WORKDIR /app
COPY app/ /app/
 
CMD ["sh", "-c", "echo App running && sleep 300"]
