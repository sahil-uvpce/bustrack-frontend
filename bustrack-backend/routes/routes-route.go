package routes

import (
	"bustrack/controller"

	"github.com/labstack/echo"
)

// RouteRoute multi route
func RouteRoute(e *echo.Echo) (err error) {
	e.GET("/route/get/:routeid", controller.GetRoute)
	e.GET("/route/get", controller.GetRouteOrg)
	e.POST("/route/add", controller.CreateRoute)
	e.PUT("/route/update", controller.UpdateRoute)
	e.DELETE("/route/delete/:routeid", controller.DeleteRoute)
	return err
}
