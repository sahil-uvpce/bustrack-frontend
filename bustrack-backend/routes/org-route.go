package routes

import (
	"bustrack/controller"

	"github.com/labstack/echo"
)

// OrgRoute multi route
func OrgRoute(e *echo.Echo) (err error) {
	e.GET("/organization/get/:orgid", controller.GetOrganization)
	e.PUT("/organization/update", controller.UpdateOraganization)
	e.POST("/organization/add", controller.CreateOrganization)
	e.DELETE("/organization/delete/:orgid", controller.DeleteOraganization)
	return err
}
