package denon

import (
	"errors"
	"net"
)

// CheckConnection checks if a connection to the receiver is possible
func CheckConnection() bool {
	connection, err := getConnection()
	if err != nil {
		return false
	}

	connection.Close()

	return true
}

// SendCommand sends a command to the receiver and returns the response
func SendCommand(command string) (*string, error) {
	connection, err := getConnection()
	if err != nil {
		return nil, errors.New("could not connect to the receiver")
	}
	defer connection.Close()

	data := []byte(command + "\r")
	writeLenght, err := connection.Write(data)
	if (err != nil) || (writeLenght < len(data)) {
		return nil, errors.New("could not send the command")
	}

	response := make([]byte, 1024)
	readLength, err := connection.Read(response)
	if err != nil {
		return nil, errors.New("could not read from the connection")
	}

	responseStr := ""
	if readLength > 0 {
		responseStr = string(response[:readLength])
	}

	return &responseStr, nil
}

func getConnection() (net.Conn, error) {
	connection, err := net.Dial("tcp", configuration.Receiver.Host+":23")

	return connection, err
}
