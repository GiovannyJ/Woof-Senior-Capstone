package rest

import (
	"github.com/allegro/bigcache"
	"time"
	"encoding/json"
	"github.com/gin-gonic/gin"
)

// Define a global BigCache instance
var DataCache *bigcache.BigCache

/*
Initialization of the cache
*/
func init(){
	// Initialize the BigCache instance with desired configuration
	cacheConfig := bigcache.Config{
		Shards:             1024,                // number of shards (must be a power of 2)
		LifeWindow:         5 * time.Minute,     // time after which entry can be evicted
		CleanWindow:        10 * time.Minute,    // interval between removing expired entries (clean-up)
		MaxEntriesInWindow: 1000,                // maximum number of entries in life window
		MaxEntrySize:       500,                 // maximum size of entry in bytes
		HardMaxCacheSize:   8192,                // maximum cache size in MB
	}

	var err error
	DataCache, err = bigcache.NewBigCache(cacheConfig)
	if err != nil {
		panic(err)
	}
}

/*
*HELPER METHOD
used to get data from the cache
*/
func getCacheData(cacheKey string) (map[string]interface{}, error){
	var data map[string]interface{}
	if cacheData, err := DataCache.Get(cacheKey); err == nil{
		json.Unmarshal([]byte(cacheData), &data)
		return data, nil
	}

	return nil, gin.Error{}
}