import time
import os
from collections import OrderedDict

# กำหนดชื่อไฟล์ .py ที่ต้องการรัน
#timestamp_program = "C:\\IOT Gateway\\timestamp.py"
#selected_program = "C:\\IOT Gateway\\selected.py"
#err_program = "C:\\IOT Gateway\\err_code.py"

def read_encoding_config():
    encoder_config = "C:\\IOT Gateway\\encoder.config"
    if not os.path.exists(encoder_config):
        return 'UTF-8'  # ค่า default ถ้าไฟล์ encoder.config ไม่มี
    with open(encoder_config, 'r') as file:
        return file.readline().strip()

def read_file_to_list(file_path):
    encoding = read_encoding_config()
    if not os.path.exists(file_path):
        return []
    with open(file_path, 'r', encoding=encoding) as file:
        return [line.strip() for line in file.readlines()]

def append_line_to_file(file_path, line, new_line=False):
    encoding = read_encoding_config()
    with open(file_path, 'a', encoding=encoding) as file:
        if new_line:
            file.write(line + '\n')
        else:
            file.write(line + ',')

def compare_timestamps(ts1, ts2):
    return ts1 >= ts2

def contains_keyword(line):
    return ("END CardReading" in line or "Visio Result:" in line or 
            "Visio Result -" in line or "END Close Scheduler" in line or 
            "START CardFloorInitialization" in line or "Full Error" in line)

def main():
    path_config = "C:\\IOT Gateway\\path.config"
    timestamp_config = "C:\\IOT Gateway\\timestamp.config"
    machine_config = "C:\\IOT Gateway\\machine.config"
    case_config = "C:\\IOT Gateway\\case0.config"
    output_file = "C:\\IOT Gateway\\run1.log"
    error_file = "C:\\IOT Gateway\\err1.log"
    final_file = "C:\\IOT Gateway\\final_inspected.log"
    
    paths = read_file_to_list(path_config)
    timestamps = read_file_to_list(timestamp_config)
    machine_info = read_file_to_list(machine_config)
    case_info = read_file_to_list(case_config)
    
    erytra_log = paths[0] if paths else "erytra.log"
    last_timestamp = timestamps[0] if timestamps else ""
    
    processed_lines = OrderedDict()
    
    while True:
        if not os.path.exists(erytra_log):
            # ดึงข้อมูลวันที่และเวลาปัจจุบัน
            #current_date = time.strftime("%Y-%m-%d")
            #current_time = time.strftime("%H:%M:%S")
            
            # ข้อมูลที่ต้องการเขียน
            #machine = machine_info[0] if machine_info else "N/A"
            #case = case_info[0] if case_info else "N/A"
            
            # สร้างข้อความที่จะเขียนลงไฟล์
            #log_message = f"{current_date}, {current_time}, N/A, Destination host unreachable, N/A, Standby, {machine}, N/A, {case}"
            
            # เขียนข้อความลงไฟล์ standby.log
            #append_line_to_file(final_file, log_message, new_line=True)
            
            time.sleep(60)
            continue
        
        try:
            encoding = read_encoding_config()
            with open(erytra_log, 'r', encoding=encoding) as file:
                for line in file:
                    line = line.strip()
                    if not line:
                        continue
                    
                    timestamp = line[:19]
                    
                    if compare_timestamps(timestamp, last_timestamp) and contains_keyword(line):
                        if line not in processed_lines:
                            processed_lines[line] = True
                            current_date = time.strftime("%Y-%m-%d")
                            current_time = time.strftime("%H:%M:%S")
                            machine = machine_info[0] if machine_info else "N/A"
                            case = case_info[0] if case_info else "N/A"
                            if "END CardReading" in line:
                                append_line_to_file(output_file, line, new_line=True)
                                #subprocess.run(["python", selected_program], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                            elif "END Close Scheduler" in line:
                                log_message = f"{current_date}, {current_time}, N/A, Disable the machine, N/A, Disable, {machine}, N/A, {case}"
                                append_line_to_file(final_file, log_message, new_line=True)
                            elif "START CardFloorInitialization" in line:
                                log_message = f"{current_date}, {current_time}, N/A, Enable the machine, N/A, Enable, {machine}, N/A, {case}"
                                append_line_to_file(final_file, log_message, new_line=True)
                            elif "Full Error" in line:
                                append_line_to_file(error_file, line, new_line=True)
                                #subprocess.run(["python", err_program], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                            else:
                                append_line_to_file(output_file, line, new_line=False)
                            time.sleep(0.1)
        except Exception as e:
            append_line_to_file(final_file, f"Error reading {erytra_log}: {e}", new_line=True)
        
        time.sleep(1)

if __name__ == "__main__":
    main()