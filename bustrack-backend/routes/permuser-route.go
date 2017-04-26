package routes

import (
	"bustrack/controller"

	"github.com/labstack/echo"
)

// PermUserRoute multi route
func PermUserRoute(e *echo.Echo) {
	e.GET("/permuser/get", controller.GetPermUserByEmail)
	e.GET("/permuser/get/:orgid", controller.GetPermUserOrg)
	e.POST("/permuser/add", controller.CreatePermUser)
	e.PUT("/permuser/update", controller.UpdatePermUser)
	e.DELETE("/permuser/delete/:email", controller.DeletePermUser)
}
