package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func MoveAndSplitTopRow(sourceFile, destinationFile string) error {
	// เช็คว่า run2.log มีอยู่แล้วหรือไม่
	if _, err := os.Stat(destinationFile); err == nil {
		fmt.Println("พบไฟล์ run2.log อยู่แล้ว ยกเลิกการทำงาน")
		return nil // จบการทำงาน
	} else if !os.IsNotExist(err) {
		// พบข้อผิดพลาดในการเข้าถึงไฟล์
		return fmt.Errorf("เกิดข้อผิดพลาดในการตรวจสอบไฟล์ปลายทาง: %v", err)
	}

	// เปิดไฟล์ต้นทางเพื่ออ่าน
	source, err := os.Open(sourceFile)
	if err != nil {
		return fmt.Errorf("ไม่สามารถเปิดไฟล์ต้นทาง: %v", err)
	}
	defer source.Close()

	scanner := bufio.NewScanner(source)
	var lines []string

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	if len(lines) == 0 {
		return nil // ไม่มีข้อมูล
	}

	topRow := lines[0]
	splitted := strings.Split(topRow, ",")

	var processedLines string
	for _, part := range splitted {
		trimmed := strings.TrimSpace(part)
		if trimmed != "" {
			processedLines += trimmed + "\n"
		}
	}

	// เขียนลง run2.log (จะสร้างใหม่แน่นอน)
	dest, err := os.Create(destinationFile) // ใช้ Create เพื่อบังคับสร้างไฟล์ใหม่
	if err != nil {
		return fmt.Errorf("ไม่สามารถสร้างไฟล์ปลายทาง: %v", err)
	}
	defer dest.Close()

	if _, err := dest.WriteString(processedLines); err != nil {
		return fmt.Errorf("ไม่สามารถเขียนไฟล์ปลายทาง: %v", err)
	}

	// เขียนข้อมูลที่เหลือกลับไปยัง run1.log
	remaining := strings.Join(lines[1:], "\n")
	if err := ioutil.WriteFile(sourceFile, []byte(remaining), 0644); err != nil {
		return fmt.Errorf("ไม่สามารถเขียนกลับไฟล์ต้นทาง: %v", err)
	}

	return nil
}

func main() {
	source := "C:/IOT Gateway/final_inspected.log"
	destination := "C:/IOT Gateway/final_inspected2.log"

	err := MoveAndSplitTopRow(source, destination)
	if err != nil {
		fmt.Println("เกิดข้อผิดพลาด:", err)
	} else {
		fmt.Println("ดำเนินการเสร็จสมบูรณ์")
	}
}
