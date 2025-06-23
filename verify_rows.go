package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	filename := "C:/IOT Gateway/final_inspected2.log"

	// อ่านจำนวนบรรทัดโดยเปิดแล้วปิดทันที
	lineCount, err := countLines(filename)
	if err != nil {
		fmt.Println("ไม่สามารถอ่านไฟล์:", err)
		return
	}

	if lineCount == 27 {
		fmt.Println("ไฟล์มี 27 บรรทัด - ปิดโปรแกรม")
		return
	}

	// พยายามลบไฟล์
	err = os.Remove(filename)
	if err != nil {
		fmt.Println("เกิดข้อผิดพลาดในการลบไฟล์:", err)
		fmt.Println("กรุณาตรวจสอบว่าไฟล์ถูกเปิดใช้งานโดยโปรแกรมอื่นหรือไม่")
		return
	}

	fmt.Println("ลบไฟล์เรียบร้อย - ปิดโปรแกรม")
}

func countLines(path string) (int, error) {
	file, err := os.Open(path)
	if err != nil {
		return 0, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	count := 0
	for scanner.Scan() {
		count++
	}
	return count, scanner.Err()
}