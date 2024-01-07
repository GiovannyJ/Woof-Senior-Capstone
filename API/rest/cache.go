package rest

import (
	"github.com/allegro/bigcache"
	"time"
	"encoding/json"
	// "github.com/gin-gonic/gin"
	"strings"
	"fmt"
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
func getCacheData(cacheKey string) ([]interface{}, error) {
    var data []interface{}
    cacheData, err := DataCache.Get(cacheKey)
    if err != nil {
        // Log or print the error for debugging purposes
        // fmt.Println("Cache Get Error:", err)
        return nil, err
    }

    if err := json.Unmarshal([]byte(cacheData), &data); err != nil {
        // Log or print the error for debugging purposes
        // fmt.Println("JSON Unmarshal Error:", err)
        return nil, err
    }

    return data, nil
}


func generateCacheKey(queryParams map[string]string, uid string) string {
	var cacheKeyParts []string
	for key, value := range queryParams {
		if len(value) > 0 {
			cacheKeyParts = append(cacheKeyParts, fmt.Sprintf("%s-%s", key, value))
		}
	}

	key := fmt.Sprintf("%s-%s", uid, strings.Join(cacheKeyParts, "-"))
	return key
}
