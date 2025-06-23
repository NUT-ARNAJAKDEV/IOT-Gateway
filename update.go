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

func readConfig(filename string) (string, error) {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(data)), nil
}

func main() {
	url, err := readConfig("C:/IOT Gateway/url.config")
	if err != nil {
		fmt.Println("Error reading URL config:", err)
		return
	}

	token, err := readConfig("C:/IOT Gateway/token.config")
	if err != nil {
		fmt.Println("Error reading token config:", err)
		return
	}

	region, _ := readConfig("C:/IOT Gateway/region.config")
	serialNo, _ := readConfig("C:/IOT Gateway/machine.config")
	location, _ := readConfig("C:/IOT Gateway/location.config")
	province, _ := readConfig("C:/IOT Gateway/province.config")
	iotName, _ := readConfig("C:/IOT Gateway/sheet.config")

	logFilePath := "C:/IOT Gateway/final_inspected2.log"
	logContent, err := ioutil.ReadFile(logFilePath)
	if err != nil {
		fmt.Println("Error reading final_inspected2.log:", err)
		return
	}

	lines := strings.Split(string(logContent), "\n")
	if len(lines) < 27 {
		fmt.Println("Log file does not have enough lines")
		return
	}

	// แปลงวันที่ + เวลาด้วยการลบ 7 ชั่วโมง
	layout := "2006-01-02 15:04:05"
	originalDateTime := lines[0] + " " + lines[1]
	parsedTime, err := time.Parse(layout, originalDateTime)
	if err != nil {
		fmt.Println("Error parsing date:", err)
		return
	}
	utcTime := parsedTime.Add(-7 * time.Hour)
	formattedDate := utcTime.Format(layout)

	data := []DataItem{
		{
			Card:        lines[7],
			Date:        formattedDate,
			Description: lines[3],
			Hn:          lines[2],
			Machine:     lines[6],
			MCL0210:     lines[10],
			MCL0211:     lines[8],
			MCL0220:     lines[26],
			MCL0221:     lines[25],
			MCL0230:     lines[12],
			MCL0231:     lines[11],
			MCL0232:     lines[13],
			MCL0240:     lines[18],
			MCL0241:     lines[23],
			MCL0242:     lines[19],
			MCL0243:     lines[24],
			MCL0244:     lines[14],
			MCL0245:     lines[16],
			MCL0246:     lines[22],
			MCL0247:     lines[17],
			MCL0248:     lines[20],
			MCL0249:     lines[15],
			MCL0250:     lines[21],
			MCL0315:     lines[9],
			Province:    province,
			Region:      region,
			State:       lines[5],
			TestResult:  lines[4],
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
		fmt.Println("Error marshaling JSON:", err)
		return
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("token", token)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error sending request:", err)
		return
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	fmt.Println("Response Status:", resp.Status)
	fmt.Println("Response Body:", string(body))
	if resp.StatusCode == 200 {
		err := os.Remove(logFilePath)
		if err != nil {
			fmt.Println("Error deleting final_inspected2.log:", err)
		} else {
			fmt.Println("final_inspected2.log deleted successfully.")
		}
	} else {
		fmt.Println("Status is not 200. File not deleted.")
	}

}
