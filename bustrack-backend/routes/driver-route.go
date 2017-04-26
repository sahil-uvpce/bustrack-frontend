package routes

import (
	"bustrack/controller"

	"github.com/labstack/echo"
)

// DriverRoute multi route
func DriverRoute(e *echo.Echo) (err error) {
	e.GET("/driver/get/:drid", controller.GetDriver)
	e.GET("/driver/get", controller.GetDriverbyVendor)
	e.POST("/driver/add", controller.CreateDriver)
	e.PUT("/driver/update", controller.UpdateDrivers)
	e.DELETE("/driver/delete/:drid", controller.DeleteDriver)
	return err
}
