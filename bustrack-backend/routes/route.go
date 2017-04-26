package routes

import "github.com/labstack/echo"

// Route multi route
func Route(e *echo.Echo) {
	OrgRoute(e)
	VendorRoute(e)
	DriverRoute(e)
	UserRoute(e)
	PermUserRoute(e)
	RouteRoute(e)
	TripRoute(e)
	BusRoute(e)
}
