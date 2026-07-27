# Sử dụng image Tomcat 10 hỗ trợ Jakarta Servlet / JSP
FROM tomcat:10.1-jdk17-temurin

# Xóa các ứng dụng mẫu mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy toàn bộ nội dung thư mục web vào ROOT ứng dụng Tomcat
COPY web /usr/local/tomcat/webapps/ROOT

# Mở cổng 8080
EXPOSE 8080

# Khởi chạy Tomcat
CMD ["catalina.sh", "run"]
