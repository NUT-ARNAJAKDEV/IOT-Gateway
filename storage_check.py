import os
import time
import shutil
from datetime import datetime

# กำหนดชื่อไฟล์ log ที่ต้องการตรวจสอบ
log_file = 'final_inspected.log'
check_interval = 600  # วินาที
size_threshold_kb = 5


def get_file_size_kb(filepath):
    return os.path.getsize(filepath) / 1024


def duplicate_and_clear_log(filepath):
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    new_filename = f"{os.path.splitext(filepath)[0]}_{timestamp}.log"
    shutil.copy(filepath, new_filename)
    print(f"[{timestamp}] Duplicated to: {new_filename}")

    with open(filepath, 'w') as f:
        f.truncate(0)  # ล้างเนื้อหาไฟล์เดิม
    print(f"[{timestamp}] Cleared original file: {filepath}")


def main():
    print(f"Monitoring '{log_file}' every {check_interval} seconds...")
    while True:
        try:
            if os.path.exists(log_file):
                size_kb = get_file_size_kb(log_file)
                print(f"Checked size: {size_kb:.2f} KB")
                if size_kb >= size_threshold_kb:
                    duplicate_and_clear_log(log_file)
            else:
                print(f"File '{log_file}' does not exist.")
        except Exception as e:
            print(f"Error: {e}")

        time.sleep(check_interval)


if __name__ == "__main__":
    main()
