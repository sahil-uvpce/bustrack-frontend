package myredis

import "github.com/garyburd/redigo/redis"

func newPool() *redis.Pool {
	return &redis.Pool{
		MaxIdle:   2,
		MaxActive: 5, // max number of connections
		Dial: func() (redis.Conn, error) {
			c, err := redis.Dial("tcp", ":6379")
			return c, err
		},
	}

}

var redisPool *redis.Pool

func initPool() bool {
	redisPool = newPool()
	if redisPool != nil {
		return false
	}
	return true
}

func getConnection() redis.Conn {
	return redisPool.Get()
}

func closePool() bool {
	err := redisPool.Close()
	if err != nil {
		return false
	}
	return true
}

//
// c := pool.Get()
// defer c.Close()
