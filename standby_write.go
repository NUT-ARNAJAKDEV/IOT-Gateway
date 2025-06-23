package main

import (
	"io/ioutil"
	"os"
)

func main() {
	// กำหนดชื่อไฟล์
	filename := "C:\\IOT Gateway\\state.config"

	// อ่านข้อมูลจากไฟล์
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		// ถ้าไฟล์ไม่มีอยู่หรืออ่านไม่ได้ ให้ตรวจสอบว่าเป็นเพราะไฟล์ไม่มีอยู่จริงหรือไม่
		if os.IsNotExist(err) {
			// ไฟล์ไม่มีอยู่ ให้เขียน "Standby" ลงไฟล์
			err = ioutil.WriteFile(filename, []byte("Standby"), 0644)
			if err != nil {
				// fmt.Printf("เกิดข้อผิดพลาดในการเขียนไฟล์: %v\n", err)
				os.Exit(1)
			}
			// fmt.Println("เขียนข้อความ 'Standby' ลงไฟล์ state.config เรียบร้อยแล้ว")
			return
		}
		// ถ้าเป็น error อื่นๆ
		// fmt.Printf("เกิดข้อผิดพลาดในการอ่านไฟล์: %v\n", err)
		os.Exit(1)
	}

	// ตรวจสอบว่าไฟล์ว่างหรือไม่
	if len(data) == 0 {
		// ไฟล์ว่าง ให้เขียน "Standby" ลงไฟล์
		err = ioutil.WriteFile(filename, []byte("Standby"), 0644)
		if err != nil {
			// fmt.Printf("เกิดข้อผิดพลาดในการเขียนไฟล์: %v\n", err)
			os.Exit(1)
		}
		// fmt.Println("เขียนข้อความ 'Standby' ลงไฟล์ state.config เรียบร้อยแล้ว")
	} else {
		// ไฟล์ไม่ว่าง ให้หยุดการทำงานทันที
		// fmt.Println("ไฟล์ state.config ไม่ว่าง หยุดการทำงาน")
		os.Exit(0)
	}
}
