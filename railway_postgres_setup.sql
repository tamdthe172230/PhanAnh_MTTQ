-- ===================================================
-- SCRIPT KHỞI TẠO CƠ SỞ DỮ LIỆU CHUẨN CHO RAILWAY POSTGRESQL
-- Dự án: PhanAnh_MTTQ (UBND_MatTranLienHoa)
-- ===================================================

-- 1. Tạo bảng Địa bàn / Khu phố (streets)
CREATE TABLE IF NOT EXISTS streets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- 2. Tạo bảng Lĩnh vực phản ánh (feedback_type)
CREATE TABLE IF NOT EXISTS feedback_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- 3. Tạo bảng Phản ánh kiến nghị (feedback)
CREATE TABLE IF NOT EXISTS feedback (
    id SERIAL PRIMARY KEY,
    voter_name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    feedback_date VARCHAR(50),
    street_id INT REFERENCES streets(id) ON DELETE SET NULL,
    type_id INT REFERENCES feedback_type(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'received',
    status_label VARCHAR(100) DEFAULT 'Đã tiếp nhận',
    content TEXT,
    reply TEXT,
    is_deleted INT DEFAULT 0,
    attached_file VARCHAR(255)
);

-- ===================================================
-- NẠP DỮ LIỆU MẪU CHUẨN VÀO RAILWAY POSTGRESQL
-- ===================================================

-- Nạp các khu phố
INSERT INTO streets (name) VALUES 
('Khu phố Lưu Khê'), 
('Khu phố Liên Hòa 1'), 
('Khu phố Liên Hòa 2'), 
('Khu phố Vĩnh Hòa')
ON CONFLICT DO NOTHING;

-- Nạp các lĩnh vực phản ánh
INSERT INTO feedback_type (name) VALUES 
('An ninh trật tự - Phòng cháy chữa cháy'), 
('Môi trường - Vệ sinh công cộng'), 
('Đô thị - Giao thông'), 
('Hạ tầng - Đô thị'), 
('Lĩnh vực khác')
ON CONFLICT DO NOTHING;

-- Nạp 20 phản ánh mẫu chuẩn tiếng Việt
INSERT INTO feedback (voter_name, phone, feedback_date, street_id, type_id, status, status_label, content, reply, is_deleted)
VALUES
('Nguyễn Văn An', '0912345678', '15/07/2026', 1, 1, 'answered', 'Đã trả lời', 'Đề nghị kiểm tra công trình xây dựng lấn chiếm lòng đường tại khu vực tổ 3, gây cản trở giao thông.', 'UBND Phường đã cử cán bộ địa chính xuống kiểm tra và yêu cầu chủ hộ tháo dỡ phần vi phạm.', 0),
('Trần Thị Bình', '0987654321', '16/07/2026', 1, 2, 'processing', 'Đang xử lý', 'Hố rác tập trung tại khu vực bến đò gây ô nhiễm mùi hôi thối vào buổi chiều, đề nghị thu gom rác đúng giờ.', 'Đang giao Ban quản lý môi trường đô thị tăng cường xe thu gom.', 0),
('Lê Văn Cường', '0905112233', '17/07/2026', 2, 1, 'received', 'Đã tiếp nhận', 'Tình trạng thanh thiếu niên tụ tập nẹt bô xe máy ban đêm gây mất trật tự an ninh khu phố.', '', 0),
('Phạm Thị Duyên', '0934567890', '17/07/2026', 2, 3, 'answered', 'Đã trả lời', 'Đèn chiếu sáng công cộng tuyến đường chính bị hỏng 3 bóng liên tiếp khiến đoạn đường rất tối.', 'Công ty chiếu sáng đô thị đã tiến hành thay thế bóng mới hoàn tất.', 0),
('Hoàng Văn Em', '0978123456', '18/07/2026', 3, 5, 'received', 'Đã tiếp nhận', 'Kiến nghị bổ sung danh sách hỗ trợ quà tết cho các hộ gia đình có hoàn cảnh khó khăn.', '', 0),
('Vũ Thị Giang', '0918765432', '18/07/2026', 3, 1, 'processing', 'Đang xử lý', 'Cần lắp đặt bổ sung camera an ninh tại ngã tư khu vực giáp ranh để phòng chống trộm cắp.', 'Công an phường đang lập dự toán kinh phí trình UBND phê duyệt.', 0),
('Đặng Văn Hải', '0965432109', '18/07/2026', 4, 4, 'answered', 'Đã trả lời', 'Mương thoát nước khu dân cư bị tắc nghẽn sau đợt mưa lớn gây ngập cục bộ.', 'Tổ dân phố cùng nhân dân đã tổ chức dọn dẹp khơi thông dòng chảy.', 0),
('Bùi Thị Hoa', '0923456789', '19/07/2026', 1, 2, 'received', 'Đã tiếp nhận', 'Đề nghị kiểm tra vệ sinh an toàn thực phẩm tại các quán ăn vặt trước cổng trường học.', '', 0),
('Đỗ Văn Hùng', '0945678901', '19/07/2026', 2, 3, 'processing', 'Đang xử lý', 'Mặt đường đoạn rẽ vào khu dân cư bị sạt lở nhẹ sau đợt bão vừa qua.', 'Ban địa chính đã khảo sát và lập kế hoạch dải đá dăm khắc phục tạm thời.', 0),
('Ngô Thị Khánh', '0981122334', '19/07/2026', 3, 4, 'answered', 'Đã trả lời', 'Dây cáp viễn thông chùng võng ngang đường gây nguy hiểm cho các xe tải nhỏ đi qua.', 'Nhà mạng Viettel và VNPT đã cử kỹ thuật gia cố buộc lại dây cáp gọn gàng.', 0),
('Lý Văn Long', '0933445566', '19/07/2026', 4, 2, 'received', 'Đã tiếp nhận', 'Xưởng mộc tư nhân hoạt động phát sinh nhiều bụi gỗ và tiếng ồn ảnh hưởng người già.', '', 0),
('Dương Thị Mai', '0977889900', '20/07/2026', 1, 5, 'answered', 'Đã trả lời', 'Xin hướng dẫn thủ tục làm hồ sơ đề nghị trợ cấp cho đối tượng người có công.', 'Cán bộ Lao động Thương binh & Xã hội đã liên hệ hướng dẫn chi tiết hồ sơ.', 0),
('Mai Văn Nam', '0911223344', '20/07/2026', 2, 5, 'received', 'Đã tiếp nhận', 'Đề nghị hỗ trợ cấp đổi giấy chứng nhận quyền sử dụng đất do bị mờ thông tin.', '', 0),
('Phan Thị Oanh', '0966778899', '20/07/2026', 3, 1, 'processing', 'Đang xử lý', 'Tiếng ồn từ loa kéo hát karaoke quá 22h đêm tại khu vực nhà xưởng cũ.', 'Tổ an ninh trật tự đã xuống nhắc nhở trực tiếp.', 0),
('Trịnh Văn Phúc', '0988990011', '20/07/2026', 4, 1, 'received', 'Đã tiếp nhận', 'Đề nghị tăng cường tuần tra ban đêm tại khu vực bãi đất trống cuối đường.', '', 0),
('Cao Thị Quỳnh', '0909090909', '20/07/2026', 1, 4, 'processing', 'Đang xử lý', 'Kiến nghị sửa chữa sân chơi vui chơi cho trẻ em tại nhà văn hóa khu phố.', 'Ủy ban phường đã đưa vào kế hoạch đầu tư công trung hạn.', 0),
('Nguyễn Văn Sơn', '0912121212', '20/07/2026', 2, 3, 'answered', 'Đã trả lời', 'Biển báo giao thông chú ý trẻ em tại khu vực trường tiểu học bị mờ sơn.', 'Đã tiến hành sơn mới biển báo rõ ràng.', 0),
('Trần Thị Trang', '0934343434', '20/07/2026', 3, 2, 'received', 'Đã tiếp nhận', 'Kiểm tra tuyến kênh tưới tiêu nội đồng có hiện tượng ô nhiễm nguồn nước.', '', 0),
('Lê Văn Uy', '0976767676', '20/07/2026', 4, 5, 'answered', 'Đã trả lời', 'Khen ngợi thái độ phục vụ tận tình của bộ phận Tiếp nhận và trả kết quả 1 cửa.', 'UBND Phường chân thành cảm ơn ý kiến ghi nhận của nhân dân.', 0),
('Đỗ Thị Vân', '0987878787', '20/07/2026', 1, 4, 'processing', 'Đang xử lý', 'Kiến nghị xem xét lại đơn giá đền bù giải phóng mặt bằng dự án mở rộng đường.', 'Hội đồng bồi thường giải phóng mặt bằng đang thụ lý giải quyết.', 0);
