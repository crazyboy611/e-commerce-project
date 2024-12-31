Nhóm 7: Hướng dẫn cài đặt web Ecommerce Shopping Online

- Giải nén 
- Trong DOAN: 
	+ FE: ecommerce2024: web bán hàng online (Vuejs)
	      adminecommerce2024: web quản lý bán hàng của admin (Vuejs).
	+ BE:  e-commerce-project : quản lý các api phần backend của dự án( Java Spring Boot).
	
- Cài đặt database: 
	+ Mở file EcommerceShoppingOnline bằng mySQL.
	+ Thực hiện chạy để tạo database có tên là ecommerce.
	
- Cài đặt BE: 
	(Đảm bảo máy có Intellij IDEA)
	+ Mở folder e-commerce-project trong Intellij IDEA.
	+ Trong folder resources thực hiện đổi các dữ liệu của datasource trong file application.yml.
			  datasource:
				url: ${DBMS_CONNECTION:jdbc:mysql://localhost:3306/ecommerce} ( jdbc connect của database trong mySQL)
				username: ${DBMS_USERNAME:root} (username trong mySQL)
				password: ${DBMS_PASSWORD:123456} (password nếu có, không có để trống)
				driver-class-name: com.mysql.cj.jdbc.Driver
	+ Click chuột phải vào file EcommerceBackendApplication, tiếp tực click vào Run để chạy dự án BE.
	
	
- Cài đặt FE: 
	(Đảm bảo máy có cài VSCode + extension(Vue))
	+ Mở folder ecommerce2024 bằng VSCode.
	+ Mở terminal trong VSCode ( Ctrl + Shift + `).
	+ Chạy lệnh npm install.
	+ Chạy lệnh npm run serve.
	+ Ctrl + Click vào http://localhost:3000/ để mở web bán hàng trong trình duyệt.
	 
	 
	+ Mở folder adminecommerce2024 bằng VSCode.
	+ Mở terminal trong VSCode ( Ctrl + Shift + `).
	+ Chạy lệnh npm install.
	+ Chạy lệnh npm run serve.
	+ Ctrl + Click vào http://localhost:3001/ để mở web quản lý bán hàng trong trình duyệt.

