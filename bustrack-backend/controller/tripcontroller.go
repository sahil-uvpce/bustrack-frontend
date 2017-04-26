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

// CreateTrip create trip
func CreateTrip(c echo.Context) (err error) {
	trip := &models.Trip{
		Routeid:  stringtoInt(c.FormValue("routeid")),
		Driverid: stringtoInt(c.FormValue("drid")),
		Busid:    stringtoInt(c.FormValue("busid")),
		Details:  c.FormValue("details"),
	}

	if err = c.Bind(trip); err != nil {
		return err
	}
	// db := dbs.GetDB()
	result, err := models.InsertTrip(dbs.DB, trip)
	tools.PanicIf(err)
	trip.Tripid = result
	// dbs.CloseDB(db)
	if result != 0 {
		return c.JSON(http.StatusCreated, result)
	}
	return c.JSON(http.StatusNotFound, "Trip is not created")
}

//DeleteTrip delete the trip by id
func DeleteTrip(c echo.Context) (err error) {
	// db := dbs.GetDB()
	result, err := models.DeleteTrip(dbs.DB, stringtoInt(c.Param("tripid")))
	tools.PanicIf(err)
	fmt.Println(result)
	//dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusOK, "Deleted")
	}
	return c.JSON(http.StatusNotFound, "Not Deleted")
}

//GetTrip get the trip by id
func GetTrip(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	result, err := models.GetTrip(dbs.DB, stringtoInt(c.Param("tripid")))
	tools.PanicIf(err)
	trips := make([]models.Trip, 0.0)
	trip := models.Trip{}
	for result.Next() {
		result.Scan(&trip.Tripid, &trip.Routeid, &trip.Driverid, &trip.Busid, &trip.Details)
		fmt.Println(trip.Tripid, trip.Routeid, trip.Driverid, trip.Busid, trip.Details)
		trips = append(trips, trip)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, trips)
}

//UpdateTrip update the trip by id
func UpdateTrip(c echo.Context) (err error) {
	trip := &models.Trip{
		Tripid:   stringtoInt(c.FormValue("tripid")),
		Routeid:  stringtoInt(c.FormValue("routeid")),
		Driverid: stringtoInt(c.FormValue("drid")),
		Busid:    stringtoInt(c.FormValue("busid")),
		Details:  c.FormValue("details"),
	}

	if err = c.Bind(trip); err != nil {
		return err
	}
	orm := map[string]string{
		"route_id":  strconv.Itoa(trip.Routeid),
		"driver_id": strconv.Itoa(trip.Driverid),
		"bus_id":    strconv.Itoa(trip.Busid),
		"details":   trip.Details,
	}
	query := tools.UpdateBuilder("trip", orm, "trip_id", strconv.Itoa(trip.Tripid))
	//db := dbs.GetDB()
	result, err := models.UpdateTrip(dbs.DB, query)
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
