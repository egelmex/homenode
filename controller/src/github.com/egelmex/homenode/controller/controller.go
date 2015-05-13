package main

import (
	"fmt"
	"sync"
	mqtt "git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git"
	fsm "github.com/looplab/fsm"
	"strconv"
)

var wg sync.WaitGroup

func main() {
	wg.Add(1)

	fmt.Printf("Hello, world.\n")
	opts := mqtt.NewClientOptions().AddBroker("tcp://rock:1883")
	opts.SetClientID("go-simple")

	c := mqtt.NewClient(opts)
	if token := c.Connect(); token.Wait() && token.Error() != nil {
		panic(token.Error())
	}

	f := fsm.NewFSM(
		"radiatorOff",
		fsm.Events{
			{Name: "temp_update", Src: []string{"radiatorOff"}, Dst: "radiatorOn"},
			{Name: "temp_update", Src: []string{"radiatorOn"}, Dst: "radiatorOff"},
		},
		fsm.Callbacks{
			"leave_radiatorOff": func(e *fsm.Event) {
				temp := e.Args[0].(int)
				if temp > 25 {
					e.Cancel()
				}
			},
			"leave_radiatorOn": func(e *fsm.Event) {
				temp := e.Args[0].(int)
				if temp < 26 {
					e.Cancel()
				}
			},
			"enter_radiatorOff": func(e *fsm.Event) {
				fmt.Printf("Switching radiator off\n")
				token := c.Publish("home/bedroom1/radiator", 0, false, strconv.Itoa(0))
				token.Wait()
				if (token.Error() != nil) {
					panic(token.Error())
				}
				fmt.Printf("Radiator off\n")

			},
			"enter_radiatorOn": func(e *fsm.Event) {
				fmt.Printf("Switching radiator on\n")
				token := c.Publish("home/bedroom1/radiator", 0, false, strconv.Itoa(1))
				token.Wait()
				if (token.Error() != nil) {
					panic(token.Error())
				}
				fmt.Printf("Radiator on\n")
			},
		},
	)
	c.Subscribe("home/bedroom1/temp", 0, func(c *mqtt.Client, m mqtt.Message) {
		temp, _ := strconv.Atoi(string(m.Payload()))
		fmt.Printf("Got Temp: %d\n", temp)
		f.Event("temp_update", temp)
	})

	wg.Wait()
	c.Disconnect(250)
}
