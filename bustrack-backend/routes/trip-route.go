package routes

import (
	"bustrack/controller"

	"github.com/labstack/echo"
)

// TripRoute multi route
func TripRoute(e *echo.Echo) (err error) {
	e.GET("/trip/get/:tripid", controller.GetTrip)
	//e.GET("/trip/get", controller.GetDriverbyVendor)
	e.POST("/trip/add", controller.CreateTrip)
	e.PUT("/trip/update", controller.UpdateTrip)
	e.DELETE("/trip/delete/:tripid", controller.DeleteTrip)
	return err
}
