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

var buildRevision string

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
	var (
		flagSet *flag.FlagSet = flag.NewFlagSet(os.Args[0], flag.ExitOnError)
		version bool

		srv Server

		ctx    context.Context
		cancel context.CancelFunc
		sigCh  chan os.Signal

		err error
	)

	rand.Seed(time.Now().UnixNano())
	log.SetFlags(log.LstdFlags | log.Lshortfile)

	flagSet.BoolVar(&version, "version", false, "version")

	if err = flagSet.Parse(os.Args[1:]); nil != err {
		fmt.Fprintln(os.Stderr, err)
	} else if version {
		fmt.Println(buildRevision)
	} else if srv, err = entry.New(); nil != err {
		fmt.Fprintln(os.Stderr, err)
	} else {
		ctx, cancel = context.WithCancel(context.Background())
		go srv.Serve(ctx)
		sigCh = make(chan os.Signal, 2)
		defer close(sigCh)
		signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)
		defer signal.Stop(sigCh)
		<-sigCh
		cancel()
		srv.Shutdown(29 * time.Second)
	}
}
