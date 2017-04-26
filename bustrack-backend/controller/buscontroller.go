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

// CreateBus create bus
func CreateBus(c echo.Context) (err error) {
	bus := &models.Bus{
		Venid:     stringtoInt(c.FormValue("venid")),
		VehicleNo: c.FormValue("vehicle_no"),
	}

	if err = c.Bind(bus); err != nil {
		return err
	}
	// db := dbs.GetDB()
	result, err := models.InsertBus(dbs.DB, bus)
	tools.PanicIf(err)
	fmt.Println("result:", result)
	// dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusCreated, "Busid is created")
	}
	return c.JSON(http.StatusNotFound, "Busid is not created")
}

//DeleteBus delete the trip by id
func DeleteBus(c echo.Context) (err error) {
	// db := dbs.GetDB()
	result, err := models.DeleteBus(dbs.DB, stringtoInt(c.Param("busid")))
	tools.PanicIf(err)
	fmt.Println(result)
	//dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusOK, "Deleted")
	}
	return c.JSON(http.StatusNotFound, "Not Deleted")
}

//GetBus get the trip by id
func GetBus(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	result, err := models.GetBus(dbs.DB, stringtoInt(c.Param("busid")))
	tools.PanicIf(err)
	buses := make([]models.Bus, 0.0)
	bus := models.Bus{}
	for result.Next() {
		result.Scan(&bus.Busid, &bus.Venid, &bus.CurrentTripid, &bus.VehicleNo)
		fmt.Println(bus.Busid, bus.Venid, bus.CurrentTripid, bus.VehicleNo)
		buses = append(buses, bus)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, buses)
}

//GetBusbyVendor get the trip by id
func GetBusbyVendor(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	result, err := models.GetBusVen(dbs.DB, stringtoInt(c.QueryParam("venid")))
	tools.PanicIf(err)
	buses := make([]models.Bus, 0.0)
	bus := models.Bus{}
	for result.Next() {
		result.Scan(&bus.Busid, &bus.Venid, &bus.CurrentTripid, &bus.VehicleNo)
		fmt.Println(bus.Busid, bus.Venid, bus.CurrentTripid, bus.VehicleNo)
		buses = append(buses, bus)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, buses)
}

//UpdateBus update the bus by id
func UpdateBus(c echo.Context) (err error) {
	bus := &models.Bus{
		Busid:     stringtoInt(c.FormValue("busid")),
		Venid:     stringtoInt(c.FormValue("venid")),
		VehicleNo: c.FormValue("vehicalNo"),
	}

	if err = c.Bind(bus); err != nil {
		return err
	}

	orm := map[string]string{
		"vendor_id":  strconv.Itoa(bus.Venid),
		"vehicle_no": bus.VehicleNo,
	}
	query := tools.UpdateBuilder("bus", orm, "bus_id", strconv.Itoa(bus.Busid))
	//db := dbs.GetDB()
	result, err := models.UpdateBus(dbs.DB, query)
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
