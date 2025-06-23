import os


def process_final_inspected_files(directory='.'):
    log_filename = 'final_inspected.log'

    with open(log_filename, 'w', encoding='utf-8') as log_file:
        for filename in os.listdir(directory):
            if 'final_inspected_' in filename and os.path.isfile(os.path.join(directory, filename)):
                file_path = os.path.join(directory, filename)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read().strip()
                        log_file.write(
                            f'\n{content}\n\n')
                    os.remove(file_path)
                    print(f'Processed and removed: {filename}')
                except Exception as e:
                    print(f'Error processing {filename}: {e}')
    print(f'Data written to {log_filename}')


# เรียกใช้งาน
process_final_inspected_files()
