package controller

import (
	"bustrack/dbs"
	"bustrack/models"
	"bustrack/tools"
	"fmt"
	"net/http"
	"strconv"

	"github.com/labstack/echo"
	_ "github.com/lib/pq" //for postgres driver
)

// CreateRoute create route
func CreateRoute(c echo.Context) (err error) {
	route := &models.Route{
		Organizationid: stringtoInt(c.FormValue("orgid")),
		Source:         c.FormValue("source"),
		Destination:    c.FormValue("destination"),
		Coords:         c.FormValue("coords"),
	}

	if err = c.Bind(route); err != nil {
		return err
	}
	// db := dbs.GetDB()
	result, err := models.InsertRoute(dbs.DB, route)
	tools.PanicIf(err)
	fmt.Println(result)
	// dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusCreated, "Route is created")
	}
	return c.JSON(http.StatusNotFound, "Route is not created")
}

//DeleteRoute delete the route by id
func DeleteRoute(c echo.Context) (err error) {
	// db := dbs.GetDB()
	result, err := models.DeleteRoute(dbs.DB, stringtoInt(c.Param("routeid")))
	tools.PanicIf(err)
	fmt.Println(result)
	//dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusOK, "Deleted")
	}
	return c.JSON(http.StatusNotFound, "Not Deleted")
}

//GetRoute get the route by id
func GetRoute(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	result, err := models.GetRoute(dbs.DB, stringtoInt(c.Param("routeid")))
	tools.PanicIf(err)
	routes := make([]models.Route, 0.0)
	route := models.Route{}
	for result.Next() {
		result.Scan(&route.Routeid, &route.Organizationid, &route.Source, &route.Destination, &route.Coords)
		fmt.Println(route.Routeid, route.Organizationid, route.Source, route.Destination, route.Coords)
		routes = append(routes, route)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, routes)
}

//GetRouteOrg get route organization
func GetRouteOrg(c echo.Context) (err error) {
	fmt.Println("orgid:", c.QueryParam("orgid"))
	fmt.Println("venid:", c.QueryParam("routeid"))
	result, err := models.GetRouteOrg(dbs.DB, stringtoInt(c.QueryParam("orgid")), stringtoInt(c.QueryParam("routeid")))
	tools.PanicIf(err)
	fmt.Println("result:", result, "result end")
	routes := make([]models.Route, 0.0)
	route := models.Route{}
	for result.Next() {
		result.Scan(&route.Routeid, &route.Organizationid, &route.Source, &route.Destination, &route.Coords)
		fmt.Println(route.Routeid, route.Organizationid, route.Source, route.Destination, route.Coords)
		routes = append(routes, route)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, routes)
}

//UpdateRoute update the route by id
func UpdateRoute(c echo.Context) (err error) {
	route := &models.Route{
		Routeid:        stringtoInt(c.FormValue("routeid")),
		Organizationid: stringtoInt(c.FormValue("orgid")),
		Source:         c.FormValue("source"),
		Destination:    c.FormValue("destination"),
		Coords:         c.FormValue("coords"),
	}

	if err = c.Bind(route); err != nil {
		return err
	}
	orm := map[string]string{
		"organization_id": strconv.Itoa(route.Organizationid),
		"source":          route.Source,
		"destination":     route.Destination,
		"coords":          route.Coords,
	}
	query := tools.UpdateBuilder("route", orm, "route_id", strconv.Itoa(route.Routeid))
	//db := dbs.GetDB()
	result, err := models.UpdateVen(dbs.DB, query)
	if err != nil {
		fmt.Println("Error is", err)
	}
	//tools.PanicIf(err)
	//dbs.CloseDB(db)
	fmt.Println("result:", result)
	if result != nil {
		return c.JSON(http.StatusOK, "updated")
	}
	return c.JSON(http.StatusNotFound, "Not updated")
}
