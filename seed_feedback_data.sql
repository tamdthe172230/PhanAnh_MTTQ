-- File: seed_feedback_data.sql
-- Kịch bản làm sạch và thêm 20 dữ liệu mẫu chuẩn UTF-NVARCHAR cho bảng feedback (Cơ sở dữ liệu: UBND_MatTranLienHoa)

USE [UBND_MatTranLienHoa];
GO

-- Xóa dữ liệu mẫu cũ nếu có
DELETE FROM feedback WHERE voter_name LIKE N'%Nguyễn Văn An%' OR voter_name LIKE N'%Trần Thị Bình%' OR voter_name LIKE N'%Lê Văn Cường%' OR voter_name LIKE N'%Phạm Thị Duyên%' OR voter_name LIKE N'%Hoàng Văn Em%' OR voter_name LIKE N'%Vũ Thị Giang%' OR voter_name LIKE N'%Đặng Văn Hải%' OR voter_name LIKE N'%Bùi Thị Hoa%' OR voter_name LIKE N'%Đỗ Văn Hùng%' OR voter_name LIKE N'%Ngô Thị Khánh%' OR voter_name LIKE N'%Lý Văn Long%' OR voter_name LIKE N'%Dương Thị Mai%' OR voter_name LIKE N'%Mai Văn Nam%' OR voter_name LIKE N'%Phan Thị Oanh%' OR voter_name LIKE N'%Trịnh Văn Phúc%' OR voter_name LIKE N'%Cao Thị Quỳnh%' OR voter_name LIKE N'%Nguyễn Văn Sơn%' OR voter_name LIKE N'%Trần Thị Trang%' OR voter_name LIKE N'%Lê Văn Uy%' OR voter_name LIKE N'%Đỗ Thị Vân%' OR phone IN ('0912345678','0987654321','0905112233','0934567890','0978123456','0918765432','0965432109','0923456789','0945678901','0981122334','0933445566','0977889900','0911223344','0966778899','0988990011','0909090909','0912121212','0934343434','0976767676','0987878787');

DECLARE @streetId INT;
DECLARE @typeId INT;

-- Lấy street_id và type_id mặc định hợp lệ từ bảng
SELECT TOP 1 @streetId = id FROM streets;
SELECT TOP 1 @typeId = id FROM feedback_type;

IF @streetId IS NULL SET @streetId = 1;
IF @typeId IS NULL SET @typeId = 1;

INSERT INTO feedback (voter_name, phone, feedback_date, street_id, type_id, status, status_label, content, reply, is_deleted)
VALUES
(N'Nguyễn Văn An', '0912345678', '15/07/2026', @streetId, @typeId, 'answered', N'Đã trả lời', N'Đề nghị kiểm tra công trình xây dựng lấn chiếm lòng đường tại khu vực tổ 3, gây cản trở giao thông.', N'UBND Phường đã cử cán bộ địa chính xuống kiểm tra và yêu cầu chủ hộ tháo dỡ phần vi phạm.', 0),
(N'Trần Thị Bình', '0987654321', '16/07/2026', @streetId, @typeId, 'processing', N'Đang xử lý', N'Hố rác tập trung tại khu vực bến đò gây ô nhiễm mùi hôi thối vào buổi chiều, đề nghị thu gom rác đúng giờ.', N'Đang giao Ban quản lý môi trường đô thị tăng cường xe thu gom.', 0),
(N'Lê Văn Cường', '0905112233', '17/07/2026', @streetId, @typeId, 'received', N'Đã tiếp nhận', N'Tình trạng thanh thiếu niên tụ tập nẹt bô xe máy ban đêm gây mất trật tự an ninh khu phố.', N'', 0),
(N'Phạm Thị Duyên', '0934567890', '17/07/2026', @streetId, @typeId, 'answered', N'Đã trả lời', N'Đèn chiếu sáng công cộng tuyến đường chính bị hỏng 3 bóng liên tiếp khiến đoạn đường rất tối.', N'Công ty chiếu sáng đô thị đã tiến hành thay thế bóng mới hoàn tất.', 0),
(N'Hoàng Văn Em', '0978123456', '18/07/2026', @streetId, @typeId, 'received', N'Đã tiếp nhận', N'Kiến nghị bổ sung danh sách hỗ trợ quà tết cho các hộ gia đình có hoàn cảnh khó khăn.', N'', 0),
(N'Vũ Thị Giang', '0918765432', '18/07/2026', @streetId, @typeId, 'processing', N'Đang xử lý', N'Cần lắp đặt bổ sung camera an ninh tại ngã tư khu vực giáp ranh để phòng chống trộm cắp.', N'Công an phường đang lập dự toán kinh phí trình UBND phê duyệt.', 0),
(N'Đặng Văn Hải', '0965432109', '18/07/2026', @streetId, @typeId, 'answered', N'Đã trả lời', N'Mương thoát nước khu dân cư bị tắc nghẽn sau đợt mưa lớn gây ngập cục bộ.', N'Tổ dân phố cùng nhân dân đã tổ chức dọn dẹp khơi thông dòng chảy.', 0),
(N'Bùi Thị Hoa', '0923456789', '19/07/2026', @streetId, @typeId, 'received', N'Đã tiếp nhận', N'Đề nghị kiểm tra vệ sinh an toàn thực phẩm tại các quán ăn vặt trước cổng trường học.', N'', 0),
(N'Đỗ Văn Hùng', '0945678901', '19/07/2026', @streetId, @typeId, 'processing', N'Đang xử lý', N'Mặt đường đoạn rẽ vào khu dân cư bị sạt lở nhẹ sau đợt bão vừa qua.', N'Ban địa chính đã khảo sát và lập kế hoạch dải đá dăm khắc phục tạm thời.', 0),
(N'Ngô Thị Khánh', '0981122334', '19/07/2026', @streetId, @typeId, 'answered', N'Đã trả lời', N'Dây cáp viễn thông chùng võng ngang đường gây nguy hiểm cho các xe tải nhỏ đi qua.', N'Nhà mạng Viettel và VNPT đã cử kỹ thuật gia cố buộc lại dây cáp gọn gàng.', 0),
(N'Lý Văn Long', '0933445566', '19/07/2026', @streetId, @typeId, 'received', N'Đã tiếp nhận', N'Xưởng mộc tư nhân hoạt động phát sinh nhiều bụi gỗ và tiếng ồn ảnh hưởng người già.', N'', 0),
(N'Dương Thị Mai', '0977889900', '20/07/2026', @streetId, @typeId, 'answered', N'Đã trả lời', N'Xin hướng dẫn thủ tục làm hồ sơ đề nghị trợ cấp cho đối tượng người có công.', N'Cán bộ Lao động Thương binh & Xã hội đã liên hệ hướng dẫn chi tiết hồ sơ.', 0),
(N'Mai Văn Nam', '0911223344', '20/07/2026', @streetId, @typeId, 'received', N'Đã tiếp nhận', N'Đề nghị hỗ trợ cấp đổi giấy chứng nhận quyền sử dụng đất do bị mờ thông tin.', N'', 0),
(N'Phan Thị Oanh', '0966778899', '20/07/2026', @streetId, @typeId, 'processing', N'Đang xử lý', N'Tiếng ồn từ loa kéo hát karaoke quá 22h đêm tại khu vực nhà xưởng cũ.', N'Tổ an ninh trật tự đã xuống nhắc nhở trực tiếp.', 0),
(N'Trịnh Văn Phúc', '0988990011', '20/07/2026', @streetId, @typeId, 'received', N'Đã tiếp nhận', N'Đề nghị tăng cường tuần tra ban đêm tại khu vực bãi đất trống cuối đường.', N'', 0),
(N'Cao Thị Quỳnh', '0909090909', '20/07/2026', @streetId, @typeId, 'processing', N'Đang xử lý', N'Kiến nghị sửa chữa sân chơi vui chơi cho trẻ em tại nhà văn hóa khu phố.', N'Ủy ban phường đã đưa vào kế hoạch đầu tư công trung hạn.', 0),
(N'Nguyễn Văn Sơn', '0912121212', '20/07/2026', @streetId, @typeId, 'answered', N'Đã trả lời', N'Biển báo giao thông chú ý trẻ em tại khu vực trường tiểu học bị mờ sơn.', N'Đã tiến hành sơn mới biển báo rõ ràng.', 0),
(N'Trần Thị Trang', '0934343434', '20/07/2026', @streetId, @typeId, 'received', N'Đã tiếp nhận', N'Kiểm tra tuyến kênh tưới tiêu nội đồng có hiện tượng ô nhiễm nguồn nước.', N'', 0),
(N'Lê Văn Uy', '0976767676', '20/07/2026', @streetId, @typeId, 'answered', N'Đã trả lời', N'Khen ngợi thái độ phục vụ tận tình của bộ phận Tiếp nhận và trả kết quả 1 cửa.', N'UBND Phường chân thành cảm ơn ý kiến ghi nhận của nhân dân.', 0),
(N'Đỗ Thị Vân', '0987878787', '20/07/2026', @streetId, @typeId, 'processing', N'Đang xử lý', N'Kiến nghị xem xét lại đơn giá đền bù giải phóng mặt bằng dự án mở rộng đường.', N'Hội đồng bồi thường giải phóng mặt bằng đang thụ lý giải quyết.', 0);

PRINT N'Đã cập nhật dữ liệu tiếng Việt Unicode chuẩn vào bảng feedback!';
GO
