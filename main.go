package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func main() {
	router := gin.Default()

	// 匹配的url格式:  ?firstname=Jane&lastname=Doe
	router.GET("/", func(c *gin.Context) {
		firstname := c.DefaultQuery("firstname", "Guest")
		lastname := c.Query("lastname") // 是 c.Request.URL.Query().Get("lastname") 的简写

		c.String(http.StatusOK, "HeiHeiHeiHei %s %s", firstname, lastname)
	})
	router.Run(":80")
}
