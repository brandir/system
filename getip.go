// Time-stamp: <2020-04-29 17:55:20 (elrond@rivendell) getip.go>

// Get local and public IPs.

package main

import (
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"os"
	"time"
)

const (
	author = "dmon"
        version = "1.0"
        cdate = "04/29/2020"
        carch = "rivendell"
        program = "getip.go"
        github = "https://github.com/brandir/system"
)

var (
        Info = teal
        Log  = purple
        Warn = yellow
        Fata = red
        User = magenta
)

var (
        black   = Color("\033[1;30m%s\033[0m")
        red     = Color("\033[1;31m%s\033[0m")
        green   = Color("\033[1;32m%s\033[0m")
        yellow  = Color("\033[1;33m%s\033[0m")
        purple  = Color("\033[1;34m%s\033[0m")
        magenta = Color("\033[1;35m%s\033[0m")
        teal    = Color("\033[1;36m%s\033[0m")
        white   = Color("\033[1;37m%s\033[0m")
)

func Color(colorstring string) func(...interface{}) string {
        sprint := func(args ...interface{}) string {
                return fmt.Sprintf(colorstring, fmt.Sprint(args...))
        }
        return sprint
}
	
// Look up the local IP.
func getLocalIP() string {
        addrs, err := net.InterfaceAddrs()
        if err != nil {
                return ""
        } else {
                for _, address := range addrs {
                        // check the address type and ignore the loopback IP
                        if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
                                if ipnet.IP.To4() != nil {
                                        return ipnet.IP.String()
                                }
                        }
                }
        }
        return ""
}

// Look up the public IP.
func getPublicIP() string {
        url := "https://api.ipify.org?format=text"
        resp, err := http.Get(url)
        if err != nil {
                panic(err)
        }
        defer resp.Body.Close()
        ip, err := ioutil.ReadAll(resp.Body)
        if err != nil {
                panic(err)
        }
        return string(ip)
}

// Look up the local node name.
func getNodename() string {
        nodename, err := os.Hostname()
        if err != nil {
                panic(err)
        } else {
                return nodename
        }
}

func main() {
	logfile := "/home/elrond/log/ip.log"
	
	fmt.Printf("---  %s V%s [(c] %s %s <%s>] ---\n", program, version, author, cdate, github)
	nodename := getNodename()
	ip_local := getLocalIP()
	ip_public := getPublicIP()
	
	t := time.Now()
	ts := fmt.Sprintf("%04d-%02d-%02d %02d:%02d:%02d", t.Year(), t.Month(), t.Day(), t.Hour(), t.Minute(), t.Second())
	result := fmt.Sprintf("%s\t%s\t%s", ts, ip_local, ip_public)

	f, err := os.OpenFile(logfile, os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	if _, err := f.WriteString(result + "\n"); err != nil {
		panic(err)
	}

	fmt.Println(Log("Hostname   ", nodename))
	fmt.Println(Log("Local IP   ", ip_local))
	fmt.Println(Log("Public IP  ", ip_public))

	
}
