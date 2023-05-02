create table tblPhim (
PhimID int primary key auto_increment,
Ten_phim nvarchar(30),
Loai_phim nvarchar(25),
Thoi_gian int
);
insert into tblPhim(Ten_phim, Loai_phim, Thoi_gian) values 
('Em bé Hà Nội', 'Tâm lý', 90),
('Nhiệm vụ bất khả thi', 'Hành động', 100),
('Dị nhân', 'Viễn Tưởng', 90),
('Cuốn theo chiều gió', 'Tình cảm', 120);
create table tblphong (
PhongID int primary key auto_increment,
Ten_phong nvarchar (20),
Trang_thai tinyint 
);
insert into tblphong(Ten_phong, Trang_thai) values 
('Phòng chiếu 1', 1),
('Phòng chiếu 2', 1),
('Phòng chiếu 3', 0);
create table tblghe (
GheID int primary key auto_increment,
PhongID int,
So_ghe varchar(10),
foreign key (PhongID) references tblphong(PhongID)
);
insert into tblghe(PhongID, So_ghe) values (1, 'A3'), (1, 'B5'), (2, 'A7'), (2, 'D1'), (3, 'T2');
CREATE TABLE tblve(
PhimID int,
GheID int,
Ngay_chieu datetime,
Trang_thai nvarchar(20),
foreign key(PhimID) references tblphim(PhimID),
foreign key(GheID) references tblghe(GheID)
);
insert into tblve(PhimID, GheID, Ngay_chieu, Trang_thai) values
(1,1,'2008-10-20', 'Đã bán'),
(1,3,'2008-11-20', 'Đã bán'),
(1,4,'2008-12-23', 'Đã bán'),
(2,1,'2009-02-14', 'Đã bán'),
(3,1,'2009-02-14', 'Đã bán'),
(2,5,'2009-03-08', 'Chưa bán'),
(2,3,'2009-03-08', 'Chưa bán');
/* 2.	Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)	*/
select * from tblphim order by Thoi_gian asc;
/*3.	Hiển thị Ten_phim có thời gian chiếu dài nhất */
select Ten_phim from tblphim where Thoi_gian = (select max(Thoi_gian) from tblphim );
/* 4.	Hiển thị Ten_Phim có thời gian chiếu ngắn nhất*/
SELECT  Ten_phim from tblphim where Thoi_gian = (select  min(Thoi_gian) from tblphim);
/* 5.	Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’*/ 
select So_ghe from tblghe where So_ghe like 'A%';
/* 6.	Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)*/ 
alter table tblphong modify column Trang_thai nvarchar(25); 
/* 7.	Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:			
-	Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’
-	Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’
-	Nếu Trang_thai=null thì gán Trang_thai=’Unknow’
Sau đó hiển thị bảng tblPhong 
*/

delimiter //
create procedure after_update_tblphong()
begin
UPDATE tblphong  
SET Trang_thai = CASE Trang_thai  
WHEN 1 THEN 'Đang sử dụng'  
WHEN 0 THEN 'Đang sửa'
WHEN NULL THEN 'Unknow' 
ELSE NULL  
END;
select * from tblphong;
end
// delimiter ;
call after_update_tblphong();
/* 8.	Hiển thị danh sách tên phim mà  có độ dài >15 và < 25 ký tự */
SELECT Ten_phim from tblphim where length(Ten_phim) > 15 and length(Ten_phim) < 25;
/* 9.	Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong  trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’*/ 
select concat(Ten_phong, ' ', Trang_thai)  as 'Trạng thái phòng chiếu' from tblphong;
/* 10.	Tạo bảng mới có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian*/
create view tblRank as select Ten_phim as STT, Thoi_gian from tblphim order by Ten_phim asc;
select * from tblrank;
drop view tblRank;
/* 11.	Trong bảng tblPhim :
a.	Thêm trường Mo_ta kiểu nvarchar(max)						
b.	Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại  ” + nội dung trường LoaiPhim										
c.	Hiển thị bảng tblPhim sau khi cập nhật				
d.	Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film”
e.	Hiển thị bảng tblPhim sau khi cập nhật	
*/
alter table tblphim add column Mo_ta nvarchar(255);
update tblphim set Mo_ta = concat("Đây là bộ phim thể loại ", Loai_phim);
UPDATE tblphim set Mo_ta =REPLACE(Mo_ta,'bộ phim','film');
/* 
14.	Hiển thị ngày giờ hiện tại và ngày giờ hiện tại cộng thêm 5000 phút
*/
select time(Ngay_chieu),addtime(time(Ngay_chieu), '83:20:0') from tblve;