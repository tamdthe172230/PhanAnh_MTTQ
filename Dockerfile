# Sử dụng Tomcat 10 với Java 17
FROM tomcat:10.1-jdk17-temurin

# Xóa ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Tắt cổng shutdown 8005 của Tomcat để tránh cảnh báo log
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/' /usr/local/tomcat/conf/server.xml

# Copy thư mục giao diện web (JSP, CSS, JS, WEB-INF)
COPY web /usr/local/tomcat/webapps/ROOT

# Tạo thư mục chứa các tệp .class sau khi biên dịch
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# Copy mã nguồn Java từ src/java
COPY src/java /tmp/src

# Biên dịch toàn bộ các tệp Java thành .class đưa vào WEB-INF/classes
RUN javac -encoding UTF-8 \
    -cp "/usr/local/tomcat/lib/*:/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/*" \
    -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    $(find /tmp/src -name "*.java")

# Mở cổng 8080
EXPOSE 8080

# Khởi chạy Tomcat
CMD ["catalina.sh", "run"]
