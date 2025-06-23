package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
	"time"
)

type DataItem struct {
	Card        string `json:"card"`
	Date        string `json:"date"`
	Description string `json:"description"`
	Hn          string `json:"hn"`
	Machine     string `json:"machine"`
	MCL0210     string `json:"mcl_0210"`
	MCL0211     string `json:"mcl_0211"`
	MCL0220     string `json:"mcl_0220"`
	MCL0221     string `json:"mcl_0221"`
	MCL0230     string `json:"mcl_0230"`
	MCL0231     string `json:"mcl_0231"`
	MCL0232     string `json:"mcl_0232"`
	MCL0240     string `json:"mcl_0240"`
	MCL0241     string `json:"mcl_0241"`
	MCL0242     string `json:"mcl_0242"`
	MCL0243     string `json:"mcl_0243"`
	MCL0244     string `json:"mcl_0244"`
	MCL0245     string `json:"mcl_0245"`
	MCL0246     string `json:"mcl_0246"`
	MCL0247     string `json:"mcl_0247"`
	MCL0248     string `json:"mcl_0248"`
	MCL0249     string `json:"mcl_0249"`
	MCL0250     string `json:"mcl_0250"`
	MCL0315     string `json:"mcl_0315"`
	Province    string `json:"province"`
	Region      string `json:"region"`
	State       string `json:"state"`
	TestResult  string `json:"test_result"`
}

type Params struct {
	Region   string     `json:"region"`
	SerialNo string     `json:"serial_no"`
	Location string     `json:"location"`
	Province string     `json:"province"`
	IotName  string     `json:"iot_name"`
	Data     []DataItem `json:"data"`
}

type RequestBody struct {
	Jsonrpc string `json:"jsonrpc"`
	Method  string `json:"method"`
	ID      int    `json:"id"`
	Params  Params `json:"params"`
}

func isFileEmpty(filePath string) bool {
	fileInfo, err := os.Stat(filePath)
	if err != nil {
		fmt.Printf("ไม่สามารถเปิดไฟล์: %v\n", err)
		return true // ถ้าเปิดไม่ได้ให้ถือว่าเป็นค่าว่าง
	}
	return fileInfo.Size() == 0
}

func readConfig(filename string) (string, error) {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(data)), nil
}

func sendAPI() {
	url, err := readConfig("C:\\IOT Gateway\\url.config")
	if err != nil {
		fmt.Println("Error reading URL config:", err)
		return
	}

	token, err := readConfig("C:\\IOT Gateway\\token.config")
	if err != nil {
		fmt.Println("Error reading token config:", err)
		return
	}

	region, _ := readConfig("C:\\IOT Gateway\\region.config")
	serialNo, _ := readConfig("C:\\IOT Gateway\\machine.config")
	location, _ := readConfig("C:\\IOT Gateway\\location.config")
	province, _ := readConfig("C:\\IOT Gateway\\province.config")
	iotName, _ := readConfig("C:\\IOT Gateway\\sheet.config")

	state, err := readConfig("C:\\IOT Gateway\\state.config")
	if err != nil || strings.TrimSpace(state) == "" {
		return
	}

	// ใช้เวลาปัจจุบันลบ 7 ชั่วโมง
	layout := "2006-01-02 15:04:05"
	formattedDate := time.Now().Add(-7 * time.Hour).Format(layout)

	data := []DataItem{
		{
			Card:        "N/A",
			Date:        formattedDate,
			Description: "Destination host unreachable",
			Hn:          "N/A",
			Machine:     serialNo,
			MCL0210:     "N/A",
			MCL0211:     "N/A",
			MCL0220:     "N/A",
			MCL0221:     "N/A",
			MCL0230:     "N/A",
			MCL0231:     "N/A",
			MCL0232:     "N/A",
			MCL0240:     "N/A",
			MCL0241:     "N/A",
			MCL0242:     "N/A",
			MCL0243:     "N/A",
			MCL0244:     "N/A",
			MCL0245:     "N/A",
			MCL0246:     "N/A",
			MCL0247:     "N/A",
			MCL0248:     "N/A",
			MCL0249:     "N/A",
			MCL0250:     "N/A",
			MCL0315:     "N/A",
			Province:    province,
			Region:      region,
			State:       state,
			TestResult:  "N/A",
		},
	}

	requestBody := RequestBody{
		Jsonrpc: "2.0",
		Method:  "call",
		ID:      1,
		Params: Params{
			Region:   region,
			SerialNo: serialNo,
			Location: location,
			Province: province,
			IotName:  iotName,
			Data:     data,
		},
	}

	jsonData, err := json.MarshalIndent(requestBody, "", "  ")
	if err != nil {
		return
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		return
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("token", token)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	fmt.Println("Response Status:", resp.Status)
	fmt.Println("Response Body:", string(body))

	if resp.StatusCode == http.StatusOK {
		err := ioutil.WriteFile("C:\\IOT Gateway\\state.config", []byte(""), 0644)
		if err != nil {
			fmt.Println("Error clearing state.config:", err)
		} else {
			fmt.Println("Successfully cleared state.config")
		}
	}
}

func main() {
	filePath := "C:\\IOT Gateway\\final_inspected.log"

	for {
		if isFileEmpty(filePath) {
			fmt.Println("ไฟล์ว่าง กำลังเริ่มนับถอยหลัง 1 ชั่วโมง...")

			countdown := 3600 // เปลี่ยนเป็น 3600 ตามจริงถ้าจะเอา 1 ชั่วโมง
			stopCountdown := false

			for countdown > 0 {
				time.Sleep(1 * time.Second)

				if !isFileEmpty(filePath) {
					fmt.Println("ไฟล์ไม่ว่างแล้ว หยุดนับถอยหลัง กลับไปตรวจสอบไฟล์ใหม่")
					stopCountdown = true
					break
				}

				fmt.Printf("เหลือเวลา %d วินาที\n", countdown)
				countdown--
			}

			if !stopCountdown && countdown == 0 {
				fmt.Println("ครบกำหนดเวลา นับถอยหลังเสร็จสิ้น ส่ง API แจ้งเตือน")
				sendAPI()
			}

		} else {
			fmt.Println("ไฟล์ไม่ว่าง")
		}

		time.Sleep(1 * time.Second)
	}
}
