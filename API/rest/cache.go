package rest

import (
	"encoding/json"
	"time"
	"github.com/allegro/bigcache"
	// "github.com/gin-gonic/gin"
	"fmt"
	"strings"
)

// Define a global BigCache instance
var DataCache *bigcache.BigCache
var cacheKeys []string


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

/*
*HELPER METHOD
used to create a unique id for cache
*/
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


/*
*HELPER METHOD
used to set cache data as well as update the cache keys list
*/
func setCache(cacheKey string, serializedData []byte){
	DataCache.Set(cacheKey, serializedData)
	cacheKeys = append(cacheKeys, cacheKey)
}


func invalidateCache(pattern string) {
    var updatedKeys []string

    for _, key := range cacheKeys {
        if strings.Contains(key, pattern) {
            // Delete the cache entry associated with the key
            DataCache.Delete(key)
        } else {
            updatedKeys = append(updatedKeys, key)
        }
    }

    // Update the cacheKeys list
    cacheKeys = updatedKeys
}
