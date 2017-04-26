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

// CreateDriver create driver
func CreateDriver(c echo.Context) (err error) {
	dr := &models.Driver{
		Email:    c.FormValue("email"),
		Vendorid: stringtoInt(c.FormValue("venid")),
		Name:     c.FormValue("name"),
		Address:  c.FormValue("address"),
		Password: c.FormValue("password"),
		Contact:  c.FormValue("contact"),
	}
	if err = c.Bind(dr); err != nil {
		return err
	}
	// db := dbs.GetDB()
	result, err := models.InsertDriver(dbs.DB, dr)
	tools.PanicIf(err)
	fmt.Println(result)
	// dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusCreated, "Driverid is created")
	}
	return c.JSON(http.StatusNotFound, "Driverid is not created")
}

//DeleteDriver delete the driver by id
func DeleteDriver(c echo.Context) (err error) {
	// db := dbs.GetDB()
	result, err := models.DeleteDriver(dbs.DB, stringtoInt(c.Param("drid")))
	tools.PanicIf(err)
	fmt.Println(result)
	//dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusOK, "Deleted")
	}
	return c.JSON(http.StatusNotFound, "Not Deleted")
}

//GetDriver get the driver by id
func GetDriver(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	result, err := models.GetDriver(dbs.DB, stringtoInt(c.Param("drid")))
	tools.PanicIf(err)
	drs := make([]models.Driver, 0.0)
	dr := models.Driver{}
	for result.Next() {
		result.Scan(&dr.Driverid, &dr.Email, &dr.Vendorid, &dr.Name, &dr.Address, &dr.Password, &dr.Contact)
		fmt.Println(dr.Driverid, dr.Email, dr.Vendorid, dr.Name, dr.Address, dr.Password, dr.Contact)
		drs = append(drs, dr)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, drs)
}

//GetDriverbyVendor get driver by vendor
func GetDriverbyVendor(c echo.Context) (err error) {
	fmt.Println("drid:", c.QueryParam("drid"))
	fmt.Println("venid:", c.QueryParam("venid"))
	result, err := models.GetDriverbyVen(dbs.DB, stringtoInt(c.QueryParam("drid")), stringtoInt(c.QueryParam("venid")))
	tools.PanicIf(err)
	fmt.Println("result:", result, "result end")
	drs := make([]models.Driver, 0.0)
	dr := models.Driver{}
	for result.Next() {
		result.Scan(&dr.Driverid, &dr.Email, &dr.Vendorid, &dr.Name, &dr.Address, &dr.Password, &dr.Contact)
		fmt.Println(dr.Driverid, dr.Email, dr.Vendorid, dr.Name, dr.Address, dr.Password, dr.Contact)
		drs = append(drs, dr)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, drs)
}

//UpdateDrivers update the vendor by id
func UpdateDrivers(c echo.Context) (err error) {
	dr := &models.Driver{
		Driverid: stringtoInt(c.FormValue("drid")),
		Email:    c.FormValue("email"),
		Vendorid: stringtoInt(c.FormValue("venid")),
		Name:     c.FormValue("name"),
		Address:  c.FormValue("address"),
		Password: c.FormValue("password"),
		Contact:  c.FormValue("contact"),
	}
	if err = c.Bind(dr); err != nil {
		return err
	}
	orm := map[string]string{
		"email":     dr.Email,
		"name":      dr.Name,
		"address":   dr.Address,
		"password":  dr.Password,
		"contact":   dr.Contact,
		"vendor_id": strconv.Itoa(dr.Vendorid),
	}
	query := tools.UpdateBuilder("driver", orm, "driver_id", strconv.Itoa(dr.Driverid))
	//db := dbs.GetDB()
	result, err := models.UpdateDriver(dbs.DB, query)
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
