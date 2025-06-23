import time
import subprocess

def run_bat_file():
    """ ฟังก์ชันสำหรับรันไฟล์ timestamp.bat """
    subprocess.run(["C:\\IOT Gateway\\timestamp.bat"], shell=True)

def check_time():
    """ ตรวจสอบเวลาแบบ Real-time และรันไฟล์เมื่อถึง 00:00 น. """
    last_run_date = None  # เก็บวันที่ล่าสุดที่รันไฟล์

    while True:
        now = time.localtime()
        current_time = time.strftime("%H:%M", now)
        current_date = time.strftime("%Y-%m-%d", now)

        if current_time == "00:00" and last_run_date != current_date:
            print("🔹 Time reached 00:00 -> Running timestamp.bat file.")
            run_bat_file()
            last_run_date = current_date  # อัปเดตวันที่ล่าสุดที่รันไฟล์

        time.sleep(30)  # ตรวจสอบทุกๆ 30 วินาที เพื่อลดการใช้ CPU

if __name__ == "__main__":
    check_time()
