import os
import time


def process_one_final_inspected_file(directory='.', log_filename='final_inspected.log'):
    # ค้นหาไฟล์ที่มีชื่อว่า final_inspected_
    files = [f for f in os.listdir(directory)
             if 'final_inspected_' in f and os.path.isfile(os.path.join(directory, f))]

    if not files:
        return  # ไม่มีไฟล์ให้ประมวลผล

    # เลือกไฟล์แรกจากรายการ (อาจเลือกแบบอื่นได้ เช่น sorted, random ฯลฯ)
    filename = files[0]
    file_path = os.path.join(directory, filename)

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read().strip()

        with open(log_filename, 'a', encoding='utf-8') as log_file:
            log_file.write(f'\n{content}\n\n')

        os.remove(file_path)
        print(f'Processed and removed: {filename}')

    except Exception as e:
        print(f'Error processing {filename}: {e}')


def continuously_process_files(interval=3600, directory='.', log_filename='final_inspected.log'):
    print(
        f"Start monitoring '{directory}' for files every {interval} seconds...\n")
    while True:
        process_one_final_inspected_file(directory, log_filename)
        time.sleep(interval)


# เรียกใช้งาน
continuously_process_files()
