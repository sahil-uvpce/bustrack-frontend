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

// CreateVender create vender
func CreateVender(c echo.Context) (err error) {
	ven := &models.Vendor{
		Email:   c.FormValue("email"),
		Name:    c.FormValue("name"),
		Address: c.FormValue("address"),
		Contact: c.FormValue("contact"),
		Orgid:   stringtoInt(c.FormValue("orgid")),
	}

	if err = c.Bind(ven); err != nil {
		return err
	}
	// db := dbs.GetDB()
	result, err := models.InsertVen(dbs.DB, ven)
	tools.PanicIf(err)
	fmt.Println(result)
	// dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusCreated, "Vendor is created")
	}
	return c.JSON(http.StatusNotFound, "Vendor is not created")
}

//DeleteVendor delete the vendor by id
func DeleteVendor(c echo.Context) (err error) {
	// db := dbs.GetDB()
	result, err := models.DeleteVen(dbs.DB, stringtoInt(c.Param("venid")))
	tools.PanicIf(err)
	fmt.Println(result)
	//dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusOK, "Deleted")
	}
	return c.JSON(http.StatusNotFound, "Not Deleted")
}

//GetVendor get the vendor by id
func GetVendor(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	result, err := models.GetVen(dbs.DB, stringtoInt(c.Param("venid")))
	tools.PanicIf(err)
	vens := make([]models.Vendor, 0.0)
	ven := models.Vendor{}
	for result.Next() {
		result.Scan(&ven.Vendorid, &ven.Email, &ven.Name, &ven.Address, &ven.Contact, &ven.Orgid)
		fmt.Println(ven.Vendorid, ven.Email, ven.Name, ven.Address, ven.Contact, ven.Orgid)
		vens = append(vens, ven)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, vens)
}

//GetVendorOrg get vendor organization
func GetVendorOrg(c echo.Context) (err error) {
	fmt.Println("orgid:", c.QueryParam("orgid"))
	fmt.Println("venid:", c.QueryParam("venid"))
	result, err := models.GetVenOrg(dbs.DB, stringtoInt(c.QueryParam("orgid")), stringtoInt(c.QueryParam("venid")))
	tools.PanicIf(err)
	fmt.Println("result:", result, "result end")
	vens := make([]models.Vendor, 0.0)
	ven := models.Vendor{}
	for result.Next() {
		result.Scan(&ven.Vendorid, &ven.Email, &ven.Name, &ven.Address, &ven.Contact, &ven.Orgid)
		fmt.Println(ven.Vendorid, ven.Email, ven.Name, ven.Address, ven.Contact, ven.Orgid)
		vens = append(vens, ven)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, vens)
}

//UpdateVendor update the vendor by id
func UpdateVendor(c echo.Context) (err error) {
	ven := &models.Vendor{
		Vendorid: stringtoInt(c.FormValue("venid")),
		Email:    c.FormValue("email"),
		Name:     c.FormValue("name"),
		Address:  c.FormValue("address"),
		Contact:  c.FormValue("contact"),
		Orgid:    stringtoInt(c.FormValue("orgid")),
	}
	if err = c.Bind(ven); err != nil {
		return err
	}
	orm := map[string]string{
		"email":           ven.Email,
		"name":            ven.Name,
		"address":         ven.Address,
		"contact":         ven.Contact,
		"organization_id": strconv.Itoa(ven.Orgid),
	}
	query := tools.UpdateBuilder("vendor", orm, "vendor_id", strconv.Itoa(ven.Vendorid))
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
