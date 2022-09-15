package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"math/rand"
	"os"
	"os/signal"
	"syscall"
	"time"

	entry "hostname.local/user/x"
)

var (
	normal        = "0.1.0"
	preRelease    = "alpha"
	buildRevision string
)

type Server interface {
	Serve(ctx context.Context) error
	Shutdown(timeout time.Duration) error
}

type flags []string

func (self *flags) String() string {
	return "[...]"
}

func (self *flags) Set(value string) error {
	*self = append(*self, value)
	return nil
}

func main() {
	var flagSet = flag.NewFlagSet(os.Args[0], flag.ExitOnError)
	var version bool

	rand.Seed(time.Now().UnixNano())
	log.SetFlags(log.Lshortfile)

	flagSet.BoolVar(&version, "version", false, "version")

	if err := flagSet.Parse(os.Args[1:]); nil != err {
		fmt.Fprintln(os.Stderr, err)
	} else if version {
		fmt.Printf("%s-%s+%s\r\n", normal, preRelease, buildRevision)
	} else if srv, err := entry.New(); nil != err {
		fmt.Fprintln(os.Stderr, err)
	} else {
		ctx, cancel := context.WithCancel(context.Background())
		go func(){
			ch := make(chan os.Signal, 2)
			signal.Notify(ch, syscall.SIGINT, syscall.SIGTERM)
			<-ch
			signal.Stop(ch)
			close(ch)
			cancel()
			srv.Shutdown(3 * time.Second)
		}()
		srv.Serve(ctx)
	}
}
