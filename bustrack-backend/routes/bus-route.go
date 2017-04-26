package routes

import (
	"bustrack/controller"

	"github.com/labstack/echo"
)

// BusRoute multi route
func BusRoute(e *echo.Echo) (err error) {
	e.GET("/bus/get/:busid", controller.GetBus)
	e.GET("/bus/get", controller.GetBusbyVendor)
	e.POST("/bus/add", controller.CreateBus)
	e.PUT("/bus/update", controller.UpdateBus)
	e.DELETE("/bus/delete/:busid", controller.DeleteBus)
	return err
}
