package routes

import (
	"bustrack/controller"

	"github.com/labstack/echo"
)

// UserRoute multi route
func UserRoute(e *echo.Echo) (err error) {
	e.GET("/user/get/:userid", controller.GetUser)
	e.GET("/user/get", controller.GetUserOrg)
	e.POST("/user/add", controller.CreateUser)
	e.PUT("/user/update", controller.UpdateUser)
	e.DELETE("/user/delete/:userid", controller.DeleteUser)
	return err
}
