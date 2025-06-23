import os
from datetime import datetime

# กำหนดพาธไฟล์ที่ต้องการล้างและเขียน
file_path = "C:\\IOT Gateway\\timestamp.config"

# เช็คว่าไฟล์มีอยู่หรือไม่
if os.path.exists(file_path):
    # ถ้ามี ให้ลบเนื้อหาภายในไฟล์
    with open(file_path, 'w') as file:
        file.write('')  # ล้างไฟล์โดยการเขียนข้อมูลว่าง
else:
    # ถ้าไฟล์ไม่พบให้สร้างไฟล์ใหม่
    with open(file_path, 'w') as file:
        pass  # สร้างไฟล์ใหม่โดยไม่ต้องเขียนอะไร

# ตรวจเช็ควันเวลาปัจจุบันในรูปแบบ yyyy-mm-dd hh:mm:ss
current_datetime = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

# เปิดไฟล์อีกครั้งเพื่อเขียนวันเวลาลงไป
with open(file_path, 'w') as file:
    file.write(current_datetime + '\n')

# จบการทำงาน
print("Timestamp has been written to the file.")
